using System;
using System.Web.UI;

namespace KriyaID
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] != null)
                {
                    Response.Redirect("~/Home.aspx");
                }
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim().ToLowerInvariant();
            string phone = txtPhone.Text.Trim();
            string password = txtPassword.Text;
            string address = txtAddress.Text.Trim();
            string city = txtCity.Text.Trim();
            string pincode = txtPincode.Text.Trim();

            try
            {
                // Check if email already exists
                object existing = DB.ExecuteScalar("SELECT COUNT(*) FROM Users WHERE Email = @Email",
                    DB.Param("@Email", email));

                if (Convert.ToInt32(existing) > 0)
                {
                    pnlAlert.Visible = true;
                    litAlertMessage.Text = "An account with this email address already exists. Please login instead.";
                    return;
                }

                // Generate random salt and compute SHA256 hash
                string salt = DB.GenerateSalt();
                string hash = DB.HashPassword(password, salt);

                string insertQuery = @"
                    INSERT INTO Users (FullName, Email, Phone, PasswordHash, Salt, Role, IsBlocked, Address, City, Pincode)
                    VALUES (@FullName, @Email, @Phone, @PasswordHash, @Salt, 'User', 0, @Address, @City, @Pincode);
                    SELECT SCOPE_IDENTITY();";

                object newId = DB.ExecuteScalar(insertQuery,
                    DB.Param("@FullName", fullName),
                    DB.Param("@Email", email),
                    DB.Param("@Phone", phone),
                    DB.Param("@PasswordHash", hash),
                    DB.Param("@Salt", salt),
                    DB.Param("@Address", address),
                    DB.Param("@City", city),
                    DB.Param("@Pincode", pincode));

                int userId = Convert.ToInt32(newId);

                // Set user session
                Session["UserId"] = userId;
                Session["FullName"] = fullName;
                Session["Email"] = email;
                Session["Role"] = "User";

                // Redirect to Home page
                Response.Redirect("~/Home.aspx");
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                litAlertMessage.Text = "Registration error: " + Server.HtmlEncode(ex.Message);
            }
        }
    }
}
