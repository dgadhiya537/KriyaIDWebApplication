using System;
using System.Data;
using System.Web.UI;

namespace KriyaID
{
    public partial class Profile : Page
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
                LoadProfile();
            }
        }

        private void LoadProfile()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string sql = "SELECT FullName, Email, Phone, Address, City, Pincode FROM Users WHERE Id = @Id";
            DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", userId));

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                txtFullName.Text = r["FullName"].ToString();
                txtEmail.Text = r["Email"].ToString();
                txtPhone.Text = r["Phone"].ToString();
                txtAddress.Text = r["Address"].ToString();
                txtCity.Text = r["City"].ToString();
                txtPincode.Text = r["Pincode"].ToString();
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userId = Convert.ToInt32(Session["UserId"]);
            string fullName = txtFullName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string address = txtAddress.Text.Trim();
            string city = txtCity.Text.Trim();
            string pincode = txtPincode.Text.Trim();

            try
            {
                string sql = @"
                    UPDATE Users 
                    SET FullName = @FullName, Phone = @Phone, Address = @Address, City = @City, Pincode = @Pincode 
                    WHERE Id = @Id";

                DB.ExecuteNonQuery(sql,
                    DB.Param("@FullName", fullName),
                    DB.Param("@Phone", phone),
                    DB.Param("@Address", address),
                    DB.Param("@City", city),
                    DB.Param("@Pincode", pincode),
                    DB.Param("@Id", userId));

                Session["FullName"] = fullName;

                pnlProfileMsg.Visible = true;
                pnlProfileMsg.CssClass = "alert alert-success py-2 small";
                litProfileMsg.Text = "Your profile changes have been saved successfully.";

                var master = Master as Site;
                if (master != null) master.RefreshUserBar();
            }
            catch (Exception ex)
            {
                pnlProfileMsg.Visible = true;
                pnlProfileMsg.CssClass = "alert alert-danger py-2 small";
                litProfileMsg.Text = "Update error: " + Server.HtmlEncode(ex.Message);
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userId = Convert.ToInt32(Session["UserId"]);
            string currentPassword = txtCurrentPassword.Text;
            string newPassword = txtNewPassword.Text;

            try
            {
                string sql = "SELECT PasswordHash, Salt FROM Users WHERE Id = @Id";
                DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", userId));

                if (dt.Rows.Count == 0) return;

                string storedHash = dt.Rows[0]["PasswordHash"].ToString();
                string storedSalt = dt.Rows[0]["Salt"].ToString();

                bool verified = DB.VerifyPassword(currentPassword, storedHash, storedSalt);
                if (!verified)
                {
                    pnlPassMsg.Visible = true;
                    pnlPassMsg.CssClass = "alert alert-danger py-2 small";
                    litPassMsg.Text = "Current password does not match our records.";
                    return;
                }

                // Hash new password with fresh salt
                string newSalt = DB.GenerateSalt();
                string newHash = DB.HashPassword(newPassword, newSalt);

                DB.ExecuteNonQuery("UPDATE Users SET PasswordHash = @Hash, Salt = @Salt WHERE Id = @Id",
                    DB.Param("@Hash", newHash),
                    DB.Param("@Salt", newSalt),
                    DB.Param("@Id", userId));

                pnlPassMsg.Visible = true;
                pnlPassMsg.CssClass = "alert alert-success py-2 small";
                litPassMsg.Text = "Password updated successfully!";

                txtCurrentPassword.Text = string.Empty;
                txtNewPassword.Text = string.Empty;
                txtConfirmNewPassword.Text = string.Empty;
            }
            catch (Exception ex)
            {
                pnlPassMsg.Visible = true;
                pnlPassMsg.CssClass = "alert alert-danger py-2 small";
                litPassMsg.Text = "Error updating password: " + Server.HtmlEncode(ex.Message);
            }
        }
    }
}
