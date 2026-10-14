using System;
using System.Web.UI;

namespace KriyaID
{
    public partial class OrderSuccess : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string orderNo = Request.QueryString["orderNo"];
                if (string.IsNullOrEmpty(orderNo))
                {
                    Response.Redirect("~/MyOrders.aspx");
                    return;
                }

                litOrderNumber.Text = Server.HtmlEncode(orderNo);
                lnkOrderDetails.NavigateUrl = "~/OrderDetails.aspx?orderNo=" + Server.UrlEncode(orderNo);

                var master = Master as Site;
                if (master != null) master.RefreshUserBar();
            }
        }
    }
}
