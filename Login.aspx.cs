using System;
using System.Data;
using System.Web.UI;

namespace KriyaID
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["msg"] == "registered")
                {
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "alert alert-success py-2 small";
                    litAlertMessage.Text = "Account created successfully! Please sign in.";
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim().ToLowerInvariant();
            string password = txtPassword.Text;

            try
            {
                string query = "SELECT Id, FullName, Email, PasswordHash, Salt, Role, IsBlocked FROM Users WHERE Email = @Email";
                DataTable dt = DB.GetDataTable(query, DB.Param("@Email", email));

                if (dt.Rows.Count == 0)
                {
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "alert alert-danger py-2 small";
                    litAlertMessage.Text = "Invalid email or password.";
                    return;
                }

                DataRow row = dt.Rows[0];
                bool isBlocked = Convert.ToBoolean(row["IsBlocked"]);
                if (isBlocked)
                {
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "alert alert-danger py-2 small";
                    litAlertMessage.Text = "Your account has been deactivated. Please contact concierge support.";
                    return;
                }

                string storedHash = row["PasswordHash"].ToString();
                string storedSalt = row["Salt"].ToString();

                bool verified = DB.VerifyPassword(password, storedHash, storedSalt);
                if (!verified)
                {
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "alert alert-danger py-2 small";
                    litAlertMessage.Text = "Invalid email or password.";
                    return;
                }

                // Authentication successful
                Session["UserId"] = Convert.ToInt32(row["Id"]);
                Session["FullName"] = row["FullName"].ToString();
                Session["Email"] = row["Email"].ToString();
                string role = row["Role"].ToString();
                Session["Role"] = role;

                string returnUrl = Request.QueryString["ReturnUrl"];

                if (role == "Admin")
                {
                    Response.Redirect(string.IsNullOrEmpty(returnUrl) ? "~/Admin/Dashboard.aspx" : returnUrl);
                }
                else
                {
                    Response.Redirect(string.IsNullOrEmpty(returnUrl) ? "~/Home.aspx" : returnUrl);
                }
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "alert alert-danger py-2 small";
                litAlertMessage.Text = "Authentication error: " + Server.HtmlEncode(ex.Message);
            }
        }
    }
}
