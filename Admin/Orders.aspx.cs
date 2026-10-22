using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KriyaID
{
    public partial class AdminOrders : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["status"]))
                {
                    if (ddlStatusFilter.Items.FindByValue(Request.QueryString["status"]) != null)
                    {
                        ddlStatusFilter.SelectedValue = Request.QueryString["status"];
                    }
                }

                LoadOrders();
            }
        }

        private void LoadOrders()
        {
            List<SqlParameter> paramList = new List<SqlParameter>();
            string where = " WHERE 1=1 ";

            string status = ddlStatusFilter.SelectedValue;
            if (!string.IsNullOrEmpty(status))
            {
                where += " AND OrderStatus = @OrderStatus ";
                paramList.Add(DB.Param("@OrderStatus", status));
            }

            string keyword = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(keyword))
            {
                where += " AND (OrderNumber LIKE @Keyword OR ShippingName LIKE @Keyword OR ShippingPhone LIKE @Keyword) ";
                paramList.Add(DB.Param("@Keyword", "%" + keyword + "%"));
            }

            string sql = "SELECT * FROM Orders " + where + " ORDER BY Id DESC";
            DataTable dt = DB.GetDataTable(sql, paramList.ToArray());

            litCount.Text = dt.Rows.Count.ToString();
            gvOrders.DataSource = dt;
            gvOrders.DataBind();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadOrders();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadOrders();
        }

        public string GetStatusBadge(string status)
        {
            switch (status)
            {
                case "Placed":
                    return "<span class='badge bg-info-subtle text-info border border-info-subtle px-2 py-1'>Placed</span>";
                case "Confirmed":
                    return "<span class='badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1'>Confirmed</span>";
                case "Shipped":
                    return "<span class='badge bg-warning-subtle text-warning border border-warning-subtle px-2 py-1'>Shipped</span>";
                case "Delivered":
                    return "<span class='badge bg-success-subtle text-success border border-success-subtle px-2 py-1'>Delivered</span>";
                case "Cancelled":
                    return "<span class='badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1'>Cancelled</span>";
                default:
                    return "<span class='badge bg-secondary px-2 py-1'>" + status + "</span>";
            }
        }
    }
}
