using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KriyaID
{
    public partial class OrderDetails : Page
    {
        public string CurrentOrderStatus = "";

        private string OrderNumber
        {
            get { return Request.QueryString["orderNo"] ?? string.Empty; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            if (string.IsNullOrEmpty(OrderNumber))
            {
                Response.Redirect("~/MyOrders.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadOrder();
            }
        }

        private void LoadOrder()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            string sql = "SELECT * FROM Orders WHERE OrderNumber = @OrderNo AND UserId = @UserId";
            DataTable dt = DB.GetDataTable(sql, DB.Param("@OrderNo", OrderNumber), DB.Param("@UserId", userId));

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("~/MyOrders.aspx");
                return;
            }

            DataRow row = dt.Rows[0];
            int orderId = Convert.ToInt32(row["Id"]);
            CurrentOrderStatus = row["OrderStatus"].ToString();

            litBreadcrumbOrderNo.Text = OrderNumber;
            litOrderNoHeading.Text = OrderNumber;
            litOrderDate.Text = Convert.ToDateTime(row["OrderDate"]).ToString("dd MMMM yyyy, hh:mm tt");

            litShippingName.Text = Server.HtmlEncode(row["ShippingName"].ToString());
            litShippingPhone.Text = Server.HtmlEncode(row["ShippingPhone"].ToString());
            litShippingAddress.Text = Server.HtmlEncode(row["ShippingAddress"].ToString());
            litShippingCity.Text = Server.HtmlEncode(row["ShippingCity"].ToString());
            litShippingPincode.Text = Server.HtmlEncode(row["ShippingPincode"].ToString());

            litPaymentMethod.Text = row["PaymentMethod"].ToString();
            litPaymentStatus.Text = row["PaymentStatus"].ToString() == "Paid"
                ? "<span class='badge bg-success-subtle text-success border border-success-subtle'>Paid</span>"
                : "<span class='badge bg-warning-subtle text-warning border border-warning-subtle'>Pending</span>";

            litSubTotal.Text = string.Format("{0:N0}", row["SubTotal"]);
            litShippingFee.Text = string.Format("{0:N0}", row["ShippingFee"]);
            litGrandTotal.Text = string.Format("{0:N0}", row["TotalAmount"]);

            if (CurrentOrderStatus == "Cancelled")
            {
                phCancelledNotice.Visible = true;
                phActiveTracker.Visible = false;
                btnCancelOrder.Visible = false;
            }
            else
            {
                phCancelledNotice.Visible = false;
                phActiveTracker.Visible = true;

                // User can cancel only when Placed or Confirmed
                btnCancelOrder.Visible = (CurrentOrderStatus == "Placed" || CurrentOrderStatus == "Confirmed");

                if (CurrentOrderStatus == "Delivered" && row["DeliveredDate"] != DBNull.Value)
                {
                    phDeliveredDate.Visible = true;
                    litDeliveredDateText.Text = Convert.ToDateTime(row["DeliveredDate"]).ToString("dd MMM yyyy");
                }
                else
                {
                    phDeliveredDate.Visible = false;
                }
            }

            // Load Ordered Items
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
            rptItems.DataSource = itemsDt;
            rptItems.DataBind();
        }

        public string GetStepClass(int stepNumber)
        {
            // Steps: 1: Placed, 2: Confirmed, 3: Shipped, 4: Delivered
            int currentStep = 1;
            switch (CurrentOrderStatus)
            {
                case "Placed":
                    currentStep = 1;
                    break;
                case "Confirmed":
                    currentStep = 2;
                    break;
                case "Shipped":
                    currentStep = 3;
                    break;
                case "Delivered":
                    currentStep = 4;
                    break;
                case "Cancelled":
                    return "tracker-step";
            }

            if (stepNumber < currentStep)
            {
                return "tracker-step completed";
            }
            else if (stepNumber == currentStep)
            {
                return "tracker-step active";
            }
            else
            {
                return "tracker-step";
            }
        }

        protected void btnCancelOrder_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = DB.GetConnection())
            {
                conn.Open();
                using (SqlTransaction trans = conn.BeginTransaction())
                {
                    try
                    {
                        // Check status again
                        string checkSql = "SELECT Id, OrderStatus FROM Orders WHERE OrderNumber = @OrderNo AND UserId = @UserId";
                        DataTable dt = new DataTable();
                        using (SqlCommand cmdCheck = new SqlCommand(checkSql, conn, trans))
                        {
                            cmdCheck.Parameters.AddWithValue("@OrderNo", OrderNumber);
                            cmdCheck.Parameters.AddWithValue("@UserId", userId);
                            using (SqlDataAdapter da = new SqlDataAdapter(cmdCheck))
                            {
                                da.Fill(dt);
                            }
                        }

                        if (dt.Rows.Count == 0)
                        {
                            throw new Exception("Order not found.");
                        }

                        string currentStatus = dt.Rows[0]["OrderStatus"].ToString();
                        int orderId = Convert.ToInt32(dt.Rows[0]["Id"]);

                        if (currentStatus != "Placed" && currentStatus != "Confirmed")
                        {
                            throw new Exception("Orders in '" + currentStatus + "' state cannot be cancelled.");
                        }

                        // Update Order Status to Cancelled
                        string cancelSql = "UPDATE Orders SET OrderStatus = 'Cancelled' WHERE Id = @Id";
                        using (SqlCommand cmdCancel = new SqlCommand(cancelSql, conn, trans))
                        {
                            cmdCancel.Parameters.AddWithValue("@Id", orderId);
                            cmdCancel.ExecuteNonQuery();
                        }

                        // Restore stock for all items
                        string itemsSql = "SELECT ProductId, VariantId, Quantity FROM OrderItems WHERE OrderId = @OrderId";
                        DataTable itemsDt = new DataTable();
                        using (SqlCommand cmdItems = new SqlCommand(itemsSql, conn, trans))
                        {
                            cmdItems.Parameters.AddWithValue("@OrderId", orderId);
                            using (SqlDataAdapter da = new SqlDataAdapter(cmdItems))
                            {
                                da.Fill(itemsDt);
                            }
                        }

                        foreach (DataRow r in itemsDt.Rows)
                        {
                            int prodId = Convert.ToInt32(r["ProductId"]);
                            int qty = Convert.ToInt32(r["Quantity"]);
                            object varIdObj = r["VariantId"];

                            string restoreProdSql = "UPDATE Products SET Stock = Stock + @Qty WHERE Id = @Id";
                            using (SqlCommand cmdRestore = new SqlCommand(restoreProdSql, conn, trans))
                            {
                                cmdRestore.Parameters.AddWithValue("@Qty", qty);
                                cmdRestore.Parameters.AddWithValue("@Id", prodId);
                                cmdRestore.ExecuteNonQuery();
                            }

                            if (varIdObj != DBNull.Value)
                            {
                                string restoreVarSql = "UPDATE ProductVariants SET Stock = Stock + @Qty WHERE Id = @Id";
                                using (SqlCommand cmdVarRestore = new SqlCommand(restoreVarSql, conn, trans))
                                {
                                    cmdVarRestore.Parameters.AddWithValue("@Qty", qty);
                                    cmdVarRestore.Parameters.AddWithValue("@Id", Convert.ToInt32(varIdObj));
                                    cmdVarRestore.ExecuteNonQuery();
                                }
                            }
                        }

                        trans.Commit();

                        pnlActionMsg.Visible = true;
                        pnlActionMsg.CssClass = "alert alert-success py-2 small";
                        litActionMsg.Text = "Order has been cancelled successfully. Reserved inventory has been restored.";
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        pnlActionMsg.Visible = true;
                        pnlActionMsg.CssClass = "alert alert-danger py-2 small";
                        litActionMsg.Text = "Cancellation failed: " + Server.HtmlEncode(ex.Message);
                    }
                }
            }

            LoadOrder();
        }
    }
}
