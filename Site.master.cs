using System;
using System.Web.UI;

namespace KriyaID
{
    public partial class Site : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RefreshUserBar();
            }
        }

        public void RefreshUserBar()
        {
            if (Session["UserId"] != null)
            {
                phLoggedIn.Visible = true;
                phAnonymous.Visible = false;

                string userName = Session["FullName"] != null ? Session["FullName"].ToString() : "Account";
                litUserName.Text = Server.HtmlEncode(userName);

                if (Session["Role"] != null && Session["Role"].ToString() == "Admin")
                {
                    phAdminLink.Visible = true;
                }

                int userId = Convert.ToInt32(Session["UserId"]);

                // Load Cart count
                object cartCountObj = DB.ExecuteScalar("SELECT ISNULL(SUM(Quantity), 0) FROM CartItems WHERE UserId = @UserId",
                    DB.Param("@UserId", userId));
                lblCartCount.Text = cartCountObj != null ? cartCountObj.ToString() : "0";

                // Load Wishlist count
                object wishCountObj = DB.ExecuteScalar("SELECT COUNT(*) FROM Wishlist WHERE UserId = @UserId",
                    DB.Param("@UserId", userId));
                lblWishlistCount.Text = wishCountObj != null ? wishCountObj.ToString() : "0";
            }
            else
            {
                phLoggedIn.Visible = false;
                phAnonymous.Visible = true;
                lblCartCount.Text = "0";
                lblWishlistCount.Text = "0";
            }
        }

        protected void btnNavSearch_Click(object sender, EventArgs e)
        {
            string query = txtNavSearch.Text.Trim();
            if (string.IsNullOrEmpty(query))
            {
                query = txtMobileSearch.Text.Trim();
            }

            if (!string.IsNullOrEmpty(query))
            {
                Response.Redirect("~/Products.aspx?q=" + Server.UrlEncode(query));
            }
            else
            {
                Response.Redirect("~/Products.aspx");
            }
        }
    }
}
