using System;
using System.Data;
using System.Web.UI;

namespace KriyaID
{
    public partial class MyOrders : Page
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
                LoadUserOrders();
            }
        }

        private void LoadUserOrders()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string sql = "SELECT * FROM Orders WHERE UserId = @UserId ORDER BY Id DESC";
            DataTable dt = DB.GetDataTable(sql, DB.Param("@UserId", userId));

            if (dt.Rows.Count == 0)
            {
                pnlNoOrders.Visible = true;
                rptOrders.Visible = false;
            }
            else
            {
                pnlNoOrders.Visible = false;
                rptOrders.Visible = true;
                rptOrders.DataSource = dt;
                rptOrders.DataBind();
            }
        }

        public string GetStatusBadge(string status)
        {
            switch (status)
            {
                case "Placed":
                    return "<span class='badge bg-info-subtle text-info border border-info-subtle px-3 py-2'><i class='bi bi-clock me-1'></i>Order Placed</span>";
                case "Confirmed":
                    return "<span class='badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2'><i class='bi bi-check2-circle me-1'></i>Confirmed</span>";
                case "Shipped":
                    return "<span class='badge bg-warning-subtle text-warning border border-warning-subtle px-3 py-2'><i class='bi bi-truck me-1'></i>Dispatched / Shipped</span>";
                case "Delivered":
                    return "<span class='badge bg-success-subtle text-success border border-success-subtle px-3 py-2'><i class='bi bi-box2-heart me-1'></i>Delivered</span>";
                case "Cancelled":
                    return "<span class='badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-2'><i class='bi bi-x-circle me-1'></i>Cancelled</span>";
                default:
                    return "<span class='badge bg-secondary px-3 py-2'>" + status + "</span>";
            }
        }
    }
}
