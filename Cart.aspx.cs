using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KriyaID
{
    public partial class Cart : Page
    {
        public int ShippingProgressPercent = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            if (!IsPostBack)
            {
                LoadCart();
            }
        }

        private void LoadCart()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            string sql = @"
                SELECT 
                    c.Id AS CartItemId, c.Quantity, c.ProductId, c.VariantId,
                    p.Name AS ProductName, p.Price AS BasePrice, p.DiscountPercent,
                    v.VariantName, v.VariantValue, ISNULL(v.AdditionalPrice, 0) AS AdditionalPrice,
                    ISNULL((SELECT TOP 1 ImageUrl FROM ProductImages WHERE ProductId = p.Id ORDER BY IsPrimary DESC, Id ASC), 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80') AS PrimaryImage
                FROM CartItems c
                INNER JOIN Products p ON c.ProductId = p.Id
                LEFT JOIN ProductVariants v ON c.VariantId = v.Id
                WHERE c.UserId = @UserId
                ORDER BY c.Id DESC";

            DataTable dt = DB.GetDataTable(sql, DB.Param("@UserId", userId));

            if (dt.Rows.Count == 0)
            {
                pnlEmptyCart.Visible = true;
                pnlCartContent.Visible = false;

                var master = Master as Site;
                if (master != null) master.RefreshUserBar();
                return;
            }

            pnlEmptyCart.Visible = false;
            pnlCartContent.Visible = true;

            // Add calculated column for unit price
            dt.Columns.Add("CalculatedUnitPrice", typeof(decimal));

            decimal subTotal = 0;

            foreach (DataRow row in dt.Rows)
            {
                decimal basePrice = Convert.ToDecimal(row["BasePrice"]);
                decimal extra = Convert.ToDecimal(row["AdditionalPrice"]);
                int discount = Convert.ToInt32(row["DiscountPercent"]);
                int qty = Convert.ToInt32(row["Quantity"]);

                decimal unitPrice = (basePrice + extra) * (100 - discount) / 100m;
                row["CalculatedUnitPrice"] = unitPrice;

                subTotal += unitPrice * qty;
            }

            rptCartItems.DataSource = dt;
            rptCartItems.DataBind();

            // Calculate Shipping
            decimal shippingThreshold = 5000m;
            decimal shippingFee = 0m;

            if (subTotal >= shippingThreshold)
            {
                shippingFee = 0m;
                litShippingFee.Text = "<span class='text-success'>FREE (Complimentary)</span>";
                litShippingNotice.Text = "You qualify for FREE Delivery!";
                ShippingProgressPercent = 100;
            }
            else
            {
                shippingFee = 499m;
                litShippingFee.Text = "\u20B9499";
                decimal remaining = shippingThreshold - subTotal;
                litShippingNotice.Text = "Add \u20B9" + string.Format("{0:N0}", remaining) + " more for FREE Delivery";
                ShippingProgressPercent = (int)Math.Min(100, Math.Max(5, (subTotal / shippingThreshold) * 100));
            }

            decimal grandTotal = subTotal + shippingFee;

            litSubTotal.Text = string.Format("{0:N0}", subTotal);
            litGrandTotal.Text = string.Format("{0:N0}", grandTotal);

            // Update Master
            var masterPage = Master as Site;
            if (masterPage != null) masterPage.RefreshUserBar();
        }

        protected void rptCartItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            int cartItemId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "RemoveItem")
            {
                DB.ExecuteNonQuery("DELETE FROM CartItems WHERE Id = @Id AND UserId = @UserId",
                    DB.Param("@Id", cartItemId), DB.Param("@UserId", userId));

                LoadCart();
            }
            else if (e.CommandName == "UpdateQty")
            {
                TextBox txtQty = e.Item.FindControl("txtQty") as TextBox;
                if (txtQty != null)
                {
                    int qty;
                    if (int.TryParse(txtQty.Text.Trim(), out qty))
                    {
                        if (qty > 0)
                        {
                            DB.ExecuteNonQuery("UPDATE CartItems SET Quantity = @Qty WHERE Id = @Id AND UserId = @UserId",
                                DB.Param("@Qty", qty), DB.Param("@Id", cartItemId), DB.Param("@UserId", userId));
                        }
                        else
                        {
                            DB.ExecuteNonQuery("DELETE FROM CartItems WHERE Id = @Id AND UserId = @UserId",
                                DB.Param("@Id", cartItemId), DB.Param("@UserId", userId));
                        }
                    }
                }
                LoadCart();
            }
        }

        protected void btnClearCart_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                DB.ExecuteNonQuery("DELETE FROM CartItems WHERE UserId = @UserId", DB.Param("@UserId", userId));
                LoadCart();
            }
        }
    }
}
