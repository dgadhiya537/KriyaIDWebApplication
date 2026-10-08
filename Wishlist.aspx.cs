using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KriyaID
{
    public partial class WishlistPage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            if (!IsPostBack)
            {
                LoadWishlist();
            }
        }

        private void LoadWishlist()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            string sql = @"
                SELECT 
                    w.Id AS WishlistId, w.ProductId, w.AddedOn,
                    p.Name, p.Price, p.DiscountPercent,
                    c.Name AS CategoryName,
                    ISNULL((SELECT TOP 1 ImageUrl FROM ProductImages WHERE ProductId = p.Id ORDER BY IsPrimary DESC, Id ASC), 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80') AS PrimaryImage
                FROM Wishlist w
                INNER JOIN Products p ON w.ProductId = p.Id
                INNER JOIN SubCategories sc ON p.SubCategoryId = sc.Id
                INNER JOIN Categories c ON sc.CategoryId = c.Id
                WHERE w.UserId = @UserId
                ORDER BY w.Id DESC";

            DataTable dt = DB.GetDataTable(sql, DB.Param("@UserId", userId));

            if (dt.Rows.Count == 0)
            {
                pnlEmpty.Visible = true;
                pnlWishlistContent.Visible = false;
            }
            else
            {
                pnlEmpty.Visible = false;
                pnlWishlistContent.Visible = true;
                rptWishlist.DataSource = dt;
                rptWishlist.DataBind();
            }

            var master = Master as Site;
            if (master != null) master.RefreshUserBar();
        }

        protected void rptWishlist_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            if (e.CommandName == "RemoveWishlist")
            {
                int wishId = Convert.ToInt32(e.CommandArgument);
                DB.ExecuteNonQuery("DELETE FROM Wishlist WHERE Id = @Id AND UserId = @UserId",
                    DB.Param("@Id", wishId), DB.Param("@UserId", userId));

                pnlWishlistAlert.Visible = true;
                litWishlistAlert.Text = "Item removed from your wishlist.";
                LoadWishlist();
            }
            else if (e.CommandName == "MoveToCart")
            {
                int productId = Convert.ToInt32(e.CommandArgument);

                // Check if already in cart
                object cartItemId = DB.ExecuteScalar("SELECT Id FROM CartItems WHERE UserId = @UserId AND ProductId = @ProductId AND VariantId IS NULL",
                    DB.Param("@UserId", userId), DB.Param("@ProductId", productId));

                if (cartItemId != null && cartItemId != DBNull.Value)
                {
                    DB.ExecuteNonQuery("UPDATE CartItems SET Quantity = Quantity + 1 WHERE Id = @Id",
                        DB.Param("@Id", Convert.ToInt32(cartItemId)));
                }
                else
                {
                    DB.ExecuteNonQuery("INSERT INTO CartItems (UserId, ProductId, VariantId, Quantity, AddedOn) VALUES (@UserId, @ProductId, NULL, 1, GETDATE())",
                        DB.Param("@UserId", userId), DB.Param("@ProductId", productId));
                }

                // Delete from wishlist
                DB.ExecuteNonQuery("DELETE FROM Wishlist WHERE UserId = @UserId AND ProductId = @ProductId",
                    DB.Param("@UserId", userId), DB.Param("@ProductId", productId));

                pnlWishlistAlert.Visible = true;
                litWishlistAlert.Text = "Moved to your shopping bag!";
                LoadWishlist();
            }
        }
    }
}
