using System;
using System.Data;
using System.Web.UI;

namespace KriyaID
{
    public partial class AdminLogin : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["msg"] == "unauthorized")
                {
                    pnlAlert.Visible = true;
                    litAlert.Text = "Administrator authorization required to access this portal.";
                }
            }
        }

        protected void btnAdminLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim().ToLowerInvariant();
            string password = txtPassword.Text;

            try
            {
                string sql = "SELECT Id, FullName, Email, PasswordHash, Salt, Role, IsBlocked FROM Users WHERE Email = @Email";
                DataTable dt = DB.GetDataTable(sql, DB.Param("@Email", email));

                if (dt.Rows.Count == 0)
                {
                    pnlAlert.Visible = true;
                    litAlert.Text = "Invalid administrator credentials.";
                    return;
                }

                DataRow row = dt.Rows[0];
                string role = row["Role"].ToString();

                if (role != "Admin")
                {
                    pnlAlert.Visible = true;
                    litAlert.Text = "Access restricted: This account does not possess administrator clearance.";
                    return;
                }

                if (Convert.ToBoolean(row["IsBlocked"]))
                {
                    pnlAlert.Visible = true;
                    litAlert.Text = "This administrator profile is currently locked.";
                    return;
                }

                string storedHash = row["PasswordHash"].ToString();
                string storedSalt = row["Salt"].ToString();

                if (!DB.VerifyPassword(password, storedHash, storedSalt))
                {
                    pnlAlert.Visible = true;
                    litAlert.Text = "Invalid administrator credentials.";
                    return;
                }

                // Authentication succeeded
                Session["UserId"] = Convert.ToInt32(row["Id"]);
                Session["FullName"] = row["FullName"].ToString();
                Session["Email"] = row["Email"].ToString();
                Session["Role"] = "Admin";

                Response.Redirect("~/Admin/Dashboard.aspx");
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                litAlert.Text = "Portal Error: " + Server.HtmlEncode(ex.Message);
            }
        }
    }
}
