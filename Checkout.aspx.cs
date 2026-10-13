using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KriyaID
{
    public partial class Checkout : Page
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
                PrefillUserData();
                LoadOrderSummary();
            }
        }

        private void PrefillUserData()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string sql = "SELECT FullName, Phone, Address, City, Pincode FROM Users WHERE Id = @Id";
            DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", userId));

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                txtShippingName.Text = r["FullName"].ToString();
                txtShippingPhone.Text = r["Phone"].ToString();
                txtShippingAddress.Text = r["Address"].ToString();
                txtShippingCity.Text = r["City"].ToString();
                txtShippingPincode.Text = r["Pincode"].ToString();
            }
        }

        private void LoadOrderSummary()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            string sql = @"
                SELECT 
                    c.Id AS CartItemId, c.Quantity, c.ProductId, c.VariantId,
                    p.Name AS ProductName, p.Price AS BasePrice, p.DiscountPercent, p.Stock,
                    v.VariantValue, ISNULL(v.AdditionalPrice, 0) AS AdditionalPrice
                FROM CartItems c
                INNER JOIN Products p ON c.ProductId = p.Id
                LEFT JOIN ProductVariants v ON c.VariantId = v.Id
                WHERE c.UserId = @UserId";

            DataTable dt = DB.GetDataTable(sql, DB.Param("@UserId", userId));

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("~/Cart.aspx");
                return;
            }

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

            decimal shippingFee = subTotal >= 5000m ? 0m : 499m;
            decimal grandTotal = subTotal + shippingFee;

            litSubTotal.Text = string.Format("{0:N0}", subTotal);
            litShippingFee.Text = shippingFee == 0 ? "<span class='text-success'>FREE</span>" : "\u20B9" + string.Format("{0:N0}", shippingFee);
            litGrandTotal.Text = string.Format("{0:N0}", grandTotal);

            rptSummaryItems.DataSource = dt;
            rptSummaryItems.DataBind();
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userId = Convert.ToInt32(Session["UserId"]);
            string shippingName = txtShippingName.Text.Trim();
            string shippingPhone = txtShippingPhone.Text.Trim();
            string shippingAddress = txtShippingAddress.Text.Trim();
            string shippingCity = txtShippingCity.Text.Trim();
            string shippingPincode = txtShippingPincode.Text.Trim();

            string paymentMethod = rbCOD.Checked ? "Cash on Delivery" : "Online Payment (Demo)";
            string paymentStatus = rbOnline.Checked ? "Paid" : "Pending";
            string orderNumber = "KID-" + DateTime.Now.ToString("yyyyMMdd") + "-" + new Random().Next(1000, 9999);

            using (SqlConnection conn = DB.GetConnection())
            {
                conn.Open();
                using (SqlTransaction trans = conn.BeginTransaction())
                {
                    try
                    {
                        // 1. Fetch Cart Items
                        string cartSql = @"
                            SELECT 
                                c.Id AS CartItemId, c.Quantity, c.ProductId, c.VariantId,
                                p.Name AS ProductName, p.Price AS BasePrice, p.DiscountPercent, p.Stock,
                                ISNULL(v.AdditionalPrice, 0) AS AdditionalPrice
                            FROM CartItems c
                            INNER JOIN Products p ON c.ProductId = p.Id
                            LEFT JOIN ProductVariants v ON c.VariantId = v.Id
                            WHERE c.UserId = @UserId";

                        DataTable cartDt = new DataTable();
                        using (SqlCommand cmdCart = new SqlCommand(cartSql, conn, trans))
                        {
                            cmdCart.Parameters.AddWithValue("@UserId", userId);
                            using (SqlDataAdapter da = new SqlDataAdapter(cmdCart))
                            {
                                da.Fill(cartDt);
                            }
                        }

                        if (cartDt.Rows.Count == 0)
                        {
                            throw new Exception("Your shopping bag is empty.");
                        }

                        // 2. Validate Stock & Calculate Totals
                        decimal subTotal = 0;
                        foreach (DataRow row in cartDt.Rows)
                        {
                            int availableStock = Convert.ToInt32(row["Stock"]);
                            int requestedQty = Convert.ToInt32(row["Quantity"]);
                            string prodName = row["ProductName"].ToString();

                            if (availableStock < requestedQty)
                            {
                                throw new Exception("Insufficient stock for '" + prodName + "'. Available: " + availableStock);
                            }

                            decimal basePrice = Convert.ToDecimal(row["BasePrice"]);
                            decimal extra = Convert.ToDecimal(row["AdditionalPrice"]);
                            int discount = Convert.ToInt32(row["DiscountPercent"]);
                            decimal unitPrice = (basePrice + extra) * (100 - discount) / 100m;

                            subTotal += unitPrice * requestedQty;
                        }

                        decimal shippingFee = subTotal >= 5000m ? 0m : 499m;
                        decimal totalAmount = subTotal + shippingFee;

                        // 3. Insert Order Record
                        string orderInsertSql = @"
                            INSERT INTO Orders 
                            (UserId, OrderNumber, OrderDate, SubTotal, ShippingFee, TotalAmount, PaymentMethod, PaymentStatus, OrderStatus, ShippingName, ShippingPhone, ShippingAddress, ShippingCity, ShippingPincode)
                            VALUES 
                            (@UserId, @OrderNumber, GETDATE(), @SubTotal, @ShippingFee, @TotalAmount, @PaymentMethod, @PaymentStatus, 'Placed', @ShippingName, @ShippingPhone, @ShippingAddress, @ShippingCity, @ShippingPincode);
                            SELECT SCOPE_IDENTITY();";

                        int orderId;
                        using (SqlCommand cmdOrder = new SqlCommand(orderInsertSql, conn, trans))
                        {
                            cmdOrder.Parameters.AddWithValue("@UserId", userId);
                            cmdOrder.Parameters.AddWithValue("@OrderNumber", orderNumber);
                            cmdOrder.Parameters.AddWithValue("@SubTotal", subTotal);
                            cmdOrder.Parameters.AddWithValue("@ShippingFee", shippingFee);
                            cmdOrder.Parameters.AddWithValue("@TotalAmount", totalAmount);
                            cmdOrder.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                            cmdOrder.Parameters.AddWithValue("@PaymentStatus", paymentStatus);
                            cmdOrder.Parameters.AddWithValue("@ShippingName", shippingName);
                            cmdOrder.Parameters.AddWithValue("@ShippingPhone", shippingPhone);
                            cmdOrder.Parameters.AddWithValue("@ShippingAddress", shippingAddress);
                            cmdOrder.Parameters.AddWithValue("@ShippingCity", shippingCity);
                            cmdOrder.Parameters.AddWithValue("@ShippingPincode", shippingPincode);

                            orderId = Convert.ToInt32(cmdOrder.ExecuteScalar());
                        }

                        // 4. Insert OrderItems and Reduce Product Stock
                        foreach (DataRow row in cartDt.Rows)
                        {
                            int prodId = Convert.ToInt32(row["ProductId"]);
                            object variantIdObj = row["VariantId"] != DBNull.Value ? row["VariantId"] : (object)DBNull.Value;
                            int qty = Convert.ToInt32(row["Quantity"]);

                            decimal basePrice = Convert.ToDecimal(row["BasePrice"]);
                            decimal extra = Convert.ToDecimal(row["AdditionalPrice"]);
                            int discount = Convert.ToInt32(row["DiscountPercent"]);
                            decimal unitPrice = (basePrice + extra) * (100 - discount) / 100m;
                            decimal itemTotal = unitPrice * qty;

                            // Insert item
                            string itemInsertSql = @"
                                INSERT INTO OrderItems (OrderId, ProductId, VariantId, Quantity, UnitPrice, TotalPrice)
                                VALUES (@OrderId, @ProductId, @VariantId, @Quantity, @UnitPrice, @TotalPrice)";

                            using (SqlCommand cmdItem = new SqlCommand(itemInsertSql, conn, trans))
                            {
                                cmdItem.Parameters.AddWithValue("@OrderId", orderId);
                                cmdItem.Parameters.AddWithValue("@ProductId", prodId);
                                cmdItem.Parameters.AddWithValue("@VariantId", variantIdObj);
                                cmdItem.Parameters.AddWithValue("@Quantity", qty);
                                cmdItem.Parameters.AddWithValue("@UnitPrice", unitPrice);
                                cmdItem.Parameters.AddWithValue("@TotalPrice", itemTotal);
                                cmdItem.ExecuteNonQuery();
                            }

                            // Reduce stock in Products
                            string reduceStockSql = "UPDATE Products SET Stock = Stock - @Qty WHERE Id = @Id";
                            using (SqlCommand cmdStock = new SqlCommand(reduceStockSql, conn, trans))
                            {
                                cmdStock.Parameters.AddWithValue("@Qty", qty);
                                cmdStock.Parameters.AddWithValue("@Id", prodId);
                                cmdStock.ExecuteNonQuery();
                            }

                            // If variant, also reduce in ProductVariants if applicable
                            if (variantIdObj != DBNull.Value)
                            {
                                string reduceVariantStock = "UPDATE ProductVariants SET Stock = Stock - @Qty WHERE Id = @Id";
                                using (SqlCommand cmdVarStock = new SqlCommand(reduceVariantStock, conn, trans))
                                {
                                    cmdVarStock.Parameters.AddWithValue("@Qty", qty);
                                    cmdVarStock.Parameters.AddWithValue("@Id", Convert.ToInt32(variantIdObj));
                                    cmdVarStock.ExecuteNonQuery();
                                }
                            }
                        }

                        // 5. Clear Cart Items
                        string clearCartSql = "DELETE FROM CartItems WHERE UserId = @UserId";
                        using (SqlCommand cmdClear = new SqlCommand(clearCartSql, conn, trans))
                        {
                            cmdClear.Parameters.AddWithValue("@UserId", userId);
                            cmdClear.ExecuteNonQuery();
                        }

                        // Commit entire transaction
                        trans.Commit();
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        pnlError.Visible = true;
                        litError.Text = "Checkout Error: " + Server.HtmlEncode(ex.Message);
                        return;
                    }
                }
            }

            // Update user's profile with latest address if previously empty
            try
            {
                DB.ExecuteNonQuery(@"
                    UPDATE Users 
                    SET Address = ISNULL(NULLIF(Address, ''), @Address),
                        City = ISNULL(NULLIF(City, ''), @City),
                        Pincode = ISNULL(NULLIF(Pincode, ''), @Pincode)
                    WHERE Id = @UserId",
                    DB.Param("@Address", shippingAddress),
                    DB.Param("@City", shippingCity),
                    DB.Param("@Pincode", shippingPincode),
                    DB.Param("@UserId", userId));
            }
            catch { }

            // Order placed successfully!
            Response.Redirect("~/OrderSuccess.aspx?orderNo=" + Server.UrlEncode(orderNumber));
        }
    }
}
