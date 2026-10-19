using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;

namespace KriyaID
{
    public partial class Dashboard : Page
    {
        public string SalesDaysJson = "[]";
        public string SalesAmountsJson = "[]";
        public string StatusLabelsJson = "[]";
        public string StatusCountsJson = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadKPIs();
                LoadChartData();
                LoadRecentOrders();
                LoadLowStockAlerts();
            }
        }

        private void LoadKPIs()
        {
            // Total Revenue (excluding cancelled)
            object salesObj = DB.ExecuteScalar("SELECT ISNULL(SUM(TotalAmount), 0) FROM Orders WHERE OrderStatus <> 'Cancelled'");
            decimal totalSales = salesObj != null ? Convert.ToDecimal(salesObj) : 0m;
            litTotalSales.Text = string.Format("{0:N0}", totalSales);

            // Total Orders
            object ordersObj = DB.ExecuteScalar("SELECT COUNT(*) FROM Orders");
            litTotalOrders.Text = ordersObj != null ? ordersObj.ToString() : "0";

            // Pending Orders
            object pendingObj = DB.ExecuteScalar("SELECT COUNT(*) FROM Orders WHERE OrderStatus IN ('Placed', 'Confirmed')");
            litPendingOrders.Text = pendingObj != null ? pendingObj.ToString() : "0";

            // Users
            object usersObj = DB.ExecuteScalar("SELECT COUNT(*) FROM Users WHERE Role = 'User'");
            litTotalUsers.Text = usersObj != null ? usersObj.ToString() : "0";

            // Products
            object prodsObj = DB.ExecuteScalar("SELECT COUNT(*) FROM Products");
            litTotalProducts.Text = prodsObj != null ? prodsObj.ToString() : "0";

            // Low Stock (< 5)
            object lowStockObj = DB.ExecuteScalar("SELECT COUNT(*) FROM Products WHERE Stock < 5");
            litLowStockCount.Text = lowStockObj != null ? lowStockObj.ToString() : "0";
        }

        private void LoadChartData()
        {
            // 1. Sales Trend in Past 7 Days
            List<string> days = new List<string>();
            List<string> amounts = new List<string>();

            for (int i = 6; i >= 0; i--)
            {
                DateTime day = DateTime.Today.AddDays(-i);
                days.Add("\"" + day.ToString("dd MMM") + "\"");

                string sql = @"
                    SELECT ISNULL(SUM(TotalAmount), 0) 
                    FROM Orders 
                    WHERE OrderStatus <> 'Cancelled' 
                    AND CAST(OrderDate AS DATE) = @DayDate";

                object daySum = DB.ExecuteScalar(sql, DB.Param("@DayDate", day.Date));
                decimal amt = daySum != null ? Convert.ToDecimal(daySum) : 0m;
                amounts.Add(amt.ToString("F0"));
            }

            SalesDaysJson = "[" + string.Join(",", days) + "]";
            SalesAmountsJson = "[" + string.Join(",", amounts) + "]";

            // 2. Orders by Status
            string[] statuses = new string[] { "Placed", "Confirmed", "Shipped", "Delivered", "Cancelled" };
            List<string> labels = new List<string>();
            List<string> counts = new List<string>();

            foreach (string st in statuses)
            {
                labels.Add("\"" + st + "\"");
                object stCount = DB.ExecuteScalar("SELECT COUNT(*) FROM Orders WHERE OrderStatus = @Status",
                    DB.Param("@Status", st));
                int c = stCount != null ? Convert.ToInt32(stCount) : 0;
                counts.Add(c.ToString());
            }

            StatusLabelsJson = "[" + string.Join(",", labels) + "]";
            StatusCountsJson = "[" + string.Join(",", counts) + "]";
        }

        private void LoadRecentOrders()
        {
            string sql = "SELECT TOP 6 OrderNumber, ShippingName, TotalAmount, OrderStatus FROM Orders ORDER BY Id DESC";
            DataTable dt = DB.GetDataTable(sql);
            gvRecentOrders.DataSource = dt;
            gvRecentOrders.DataBind();
        }

        private void LoadLowStockAlerts()
        {
            string sql = "SELECT TOP 5 Id, Name, Stock FROM Products WHERE Stock < 5 ORDER BY Stock ASC";
            DataTable dt = DB.GetDataTable(sql);
            gvLowStock.DataSource = dt;
            gvLowStock.DataBind();
        }

        public string GetStatusPill(string status)
        {
            switch (status)
            {
                case "Placed":
                    return "<span class='badge bg-info-subtle text-info border border-info-subtle small'>Placed</span>";
                case "Confirmed":
                    return "<span class='badge bg-primary-subtle text-primary border border-primary-subtle small'>Confirmed</span>";
                case "Shipped":
                    return "<span class='badge bg-warning-subtle text-warning border border-warning-subtle small'>Shipped</span>";
                case "Delivered":
                    return "<span class='badge bg-success-subtle text-success border border-success-subtle small'>Delivered</span>";
                case "Cancelled":
                    return "<span class='badge bg-danger-subtle text-danger border border-danger-subtle small'>Cancelled</span>";
                default:
                    return "<span class='badge bg-secondary small'>" + status + "</span>";
            }
        }
    }
}
