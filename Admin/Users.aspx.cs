using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KriyaID
{
    public partial class AdminUsers : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            string keyword = txtSearchUser.Text.Trim();
            string sql = "SELECT Id, FullName, Email, Phone, City, Role, IsBlocked, CreatedOn FROM Users";

            if (!string.IsNullOrEmpty(keyword))
            {
                sql += " WHERE (FullName LIKE @Keyword OR Email LIKE @Keyword OR Phone LIKE @Keyword)";
            }

            sql += " ORDER BY Id ASC";

            DataTable dt = !string.IsNullOrEmpty(keyword)
                ? DB.GetDataTable(sql, DB.Param("@Keyword", "%" + keyword + "%"))
                : DB.GetDataTable(sql);

            gvUsers.DataSource = dt;
            gvUsers.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadUsers();
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleBlock")
            {
                int targetUserId = Convert.ToInt32(e.CommandArgument);

                // Prevent blocking self or admin
                object roleObj = DB.ExecuteScalar("SELECT Role FROM Users WHERE Id = @Id", DB.Param("@Id", targetUserId));
                if (roleObj != null && roleObj.ToString() == "Admin")
                {
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "alert alert-warning py-2 small";
                    litAlert.Text = "Administrator accounts cannot be locked.";
                    return;
                }

                DB.ExecuteNonQuery("UPDATE Users SET IsBlocked = CASE WHEN IsBlocked = 1 THEN 0 ELSE 1 END WHERE Id = @Id",
                    DB.Param("@Id", targetUserId));

                pnlAlert.Visible = true;
                pnlAlert.CssClass = "alert alert-success py-2 small";
                litAlert.Text = "Client account status toggled successfully.";
                LoadUsers();
            }
        }
    }
}
