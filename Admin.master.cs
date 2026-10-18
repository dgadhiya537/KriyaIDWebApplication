using System;
using System.Web.UI;

namespace KriyaID
{
    public partial class AdminMaster : MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            // Security check: only users with Role == "Admin" can access any page using Admin.master
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Admin/AdminLogin.aspx?msg=unauthorized");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Email"] != null)
                {
                    litAdminEmail.Text = Server.HtmlEncode(Session["Email"].ToString());
                }
                else
                {
                    litAdminEmail.Text = "admin@kriyaid.com";
                }

                litPageTitle.Text = Page.Title;
            }
        }
    }
}
