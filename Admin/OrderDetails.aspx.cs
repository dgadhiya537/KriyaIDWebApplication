using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KriyaID
{
    public partial class AdminOrderDetails : Page
    {
        private string OrderNumber
        {
            get { return Request.QueryString["orderNo"] ?? string.Empty; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(OrderNumber))
            {
                Response.Redirect("~/Admin/Orders.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadOrderDetails();
            }
        }

        private void LoadOrderDetails()
        {
            string sql = "SELECT * FROM Orders WHERE OrderNumber = @OrderNo";
            DataTable dt = DB.GetDataTable(sql, DB.Param("@OrderNo", OrderNumber));

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("~/Admin/Orders.aspx");
                return;
            }

            DataRow r = dt.Rows[0];
            int orderId = Convert.ToInt32(r["Id"]);
            string status = r["OrderStatus"].ToString();

            litOrderNumber.Text = OrderNumber;
            litOrderDate.Text = Convert.ToDateTime(r["OrderDate"]).ToString("dd MMMM yyyy, hh:mm tt");

            litCurrentStatusBadge.Text = GetStatusBadge(status);

            litShippingName.Text = Server.HtmlEncode(r["ShippingName"].ToString());
            litShippingPhone.Text = Server.HtmlEncode(r["ShippingPhone"].ToString());
            litShippingAddress.Text = Server.HtmlEncode(r["ShippingAddress"].ToString());
            litShippingCity.Text = Server.HtmlEncode(r["ShippingCity"].ToString());
            litShippingPincode.Text = Server.HtmlEncode(r["ShippingPincode"].ToString());

            litPaymentMethod.Text = r["PaymentMethod"].ToString();
            litPaymentStatus.Text = r["PaymentStatus"].ToString() == "Paid"
                ? "<span class='badge bg-success-subtle text-success border border-success-subtle'>Paid</span>"
                : "<span class='badge bg-warning-subtle text-warning border border-warning-subtle'>Pending</span>";

            litSubTotal.Text = string.Format("{0:N0}", r["SubTotal"]);
            litShippingFee.Text = string.Format("{0:N0}", r["ShippingFee"]);
            litGrandTotal.Text = string.Format("{0:N0}", r["TotalAmount"]);

            // Configure button visibilities based on status
            if (status == "Placed")
            {
                btnConfirm.Visible = true;
                btnShip.Visible = false;
                btnDeliver.Visible = false;
                btnCancelOrder.Visible = true;
            }
            else if (status == "Confirmed")
            {
                btnConfirm.Visible = false;
                btnShip.Visible = true;
                btnDeliver.Visible = false;
                btnCancelOrder.Visible = true;
            }
            else if (status == "Shipped")
            {
                btnConfirm.Visible = false;
                btnShip.Visible = false;
                btnDeliver.Visible = true;
                btnCancelOrder.Visible = false;
            }
            else
            {
                // Delivered or Cancelled
                btnConfirm.Visible = false;
                btnShip.Visible = false;
                btnDeliver.Visible = false;
                btnCancelOrder.Visible = false;
            }

            // Load Items
            string itemsSql = @"
                SELECT 
                    oi.ProductId, oi.Quantity, oi.UnitPrice, oi.TotalPrice,
                    p.Name AS ProductName,
                    v.VariantValue,
                    ISNULL((SELECT TOP 1 ImageUrl FROM ProductImages WHERE ProductId = p.Id ORDER BY IsPrimary DESC, Id ASC), 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80') AS PrimaryImage
                FROM OrderItems oi
                INNER JOIN Products p ON oi.ProductId = p.Id
                LEFT JOIN ProductVariants v ON oi.VariantId = v.Id
                WHERE oi.OrderId = @OrderId";

            DataTable itemsDt = DB.GetDataTable(itemsSql, DB.Param("@OrderId", orderId));
            gvItems.DataSource = itemsDt;
            gvItems.DataBind();
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            DB.ExecuteNonQuery("UPDATE Orders SET OrderStatus = 'Confirmed' WHERE OrderNumber = @OrderNo",
                DB.Param("@OrderNo", OrderNumber));

            pnlAlert.Visible = true;
            litAlert.Text = "Order status updated to 'Confirmed'.";
            LoadOrderDetails();
        }

        protected void btnShip_Click(object sender, EventArgs e)
        {
            DB.ExecuteNonQuery("UPDATE Orders SET OrderStatus = 'Shipped' WHERE OrderNumber = @OrderNo",
                DB.Param("@OrderNo", OrderNumber));

            pnlAlert.Visible = true;
            litAlert.Text = "Order status updated to 'Shipped'.";
            LoadOrderDetails();
        }

        protected void btnDeliver_Click(object sender, EventArgs e)
        {
            // When delivered, set DeliveredDate = GETDATE() and mark COD as Paid
            string sql = @"
                UPDATE Orders 
                SET OrderStatus = 'Delivered', 
                    DeliveredDate = GETDATE(),
                    PaymentStatus = 'Paid' 
                WHERE OrderNumber = @OrderNo";

            DB.ExecuteNonQuery(sql, DB.Param("@OrderNo", OrderNumber));

            pnlAlert.Visible = true;
            litAlert.Text = "Order marked as Delivered! Delivered timestamp registered and payment marked as Paid.";
            LoadOrderDetails();
        }

        protected void btnCancelOrder_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = DB.GetConnection())
            {
                conn.Open();
                using (SqlTransaction trans = conn.BeginTransaction())
                {
                    try
                    {
                        string checkSql = "SELECT Id FROM Orders WHERE OrderNumber = @OrderNo";
                        int orderId;
                        using (SqlCommand cmdCheck = new SqlCommand(checkSql, conn, trans))
                        {
                            cmdCheck.Parameters.AddWithValue("@OrderNo", OrderNumber);
                            orderId = Convert.ToInt32(cmdCheck.ExecuteScalar());
                        }

                        // Update Status
                        string cancelSql = "UPDATE Orders SET OrderStatus = 'Cancelled' WHERE Id = @Id";
                        using (SqlCommand cmdCancel = new SqlCommand(cancelSql, conn, trans))
                        {
                            cmdCancel.Parameters.AddWithValue("@Id", orderId);
                            cmdCancel.ExecuteNonQuery();
                        }

                        // Restore Stock
                        string itemsSql = "SELECT ProductId, VariantId, Quantity FROM OrderItems WHERE OrderId = @OrderId";
                        DataTable dt = new DataTable();
                        using (SqlCommand cmdItems = new SqlCommand(itemsSql, conn, trans))
                        {
                            cmdItems.Parameters.AddWithValue("@OrderId", orderId);
                            using (SqlDataAdapter da = new SqlDataAdapter(cmdItems))
                            {
                                da.Fill(dt);
                            }
                        }

                        foreach (DataRow r in dt.Rows)
                        {
                            int prodId = Convert.ToInt32(r["ProductId"]);
                            int qty = Convert.ToInt32(r["Quantity"]);
                            object varIdObj = r["VariantId"];

                            string restoreProd = "UPDATE Products SET Stock = Stock + @Qty WHERE Id = @Id";
                            using (SqlCommand cmdRest = new SqlCommand(restoreProd, conn, trans))
                            {
                                cmdRest.Parameters.AddWithValue("@Qty", qty);
                                cmdRest.Parameters.AddWithValue("@Id", prodId);
                                cmdRest.ExecuteNonQuery();
                            }

                            if (varIdObj != DBNull.Value)
                            {
                                string restoreVar = "UPDATE ProductVariants SET Stock = Stock + @Qty WHERE Id = @Id";
                                using (SqlCommand cmdVarRest = new SqlCommand(restoreVar, conn, trans))
                                {
                                    cmdVarRest.Parameters.AddWithValue("@Qty", qty);
                                    cmdVarRest.Parameters.AddWithValue("@Id", Convert.ToInt32(varIdObj));
                                    cmdVarRest.ExecuteNonQuery();
                                }
                            }
                        }

                        trans.Commit();
                        pnlAlert.Visible = true;
                        litAlert.Text = "Order cancelled and items returned to active inventory.";
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        pnlAlert.Visible = true;
                        litAlert.Text = "Error cancelling order: " + Server.HtmlEncode(ex.Message);
                    }
                }
            }

            LoadOrderDetails();
        }

        private string GetStatusBadge(string status)
        {
            switch (status)
            {
                case "Placed":
                    return "<span class='badge bg-info-subtle text-info border border-info-subtle px-3 py-2 fs-6'>Placed</span>";
                case "Confirmed":
                    return "<span class='badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 fs-6'>Confirmed</span>";
                case "Shipped":
                    return "<span class='badge bg-warning-subtle text-warning border border-warning-subtle px-3 py-2 fs-6'>Shipped</span>";
                case "Delivered":
                    return "<span class='badge bg-success-subtle text-success border border-success-subtle px-3 py-2 fs-6'>Delivered</span>";
                case "Cancelled":
                    return "<span class='badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-2 fs-6'>Cancelled</span>";
                default:
                    return "<span class='badge bg-secondary px-3 py-2 fs-6'>" + status + "</span>";
            }
        }
    }
}
