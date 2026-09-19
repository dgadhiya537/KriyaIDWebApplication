using System;
using System.Web.UI;

namespace KriyaID
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null && Session["Role"] != null && Session["Role"].ToString() == "Admin")
            {
                Response.Redirect("~/Admin/Dashboard.aspx");
            }
            else
            {
                Response.Redirect("~/Home.aspx");
            }
        }
    }
}
