using System;
using System.Data;
using System.Web.UI;

namespace KriyaID
{
    public partial class BookDesigner : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] != null)
                {
                    int userId = Convert.ToInt32(Session["UserId"]);
                    string sql = "SELECT FullName, Email, Phone FROM Users WHERE Id = @Id";
                    DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", userId));

                    if (dt.Rows.Count > 0)
                    {
                        txtName.Text = dt.Rows[0]["FullName"].ToString();
                        txtEmail.Text = dt.Rows[0]["Email"].ToString();
                        txtPhone.Text = dt.Rows[0]["Phone"].ToString();
                    }
                }
            }
        }

        protected void btnSubmitConsultation_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string name = txtName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string email = txtEmail.Text.Trim();
            string roomType = ddlRoomType.SelectedValue;
            string budget = ddlBudget.SelectedValue;
            string message = txtMessage.Text.Trim();

            try
            {
                string sql = @"
                    INSERT INTO Consultations (Name, Phone, Email, RoomType, Budget, Message, Status, CreatedOn)
                    VALUES (@Name, @Phone, @Email, @RoomType, @Budget, @Message, 'New', GETDATE())";

                DB.ExecuteNonQuery(sql,
                    DB.Param("@Name", name),
                    DB.Param("@Phone", phone),
                    DB.Param("@Email", email),
                    DB.Param("@RoomType", roomType),
                    DB.Param("@Budget", budget),
                    DB.Param("@Message", message));

                pnlSuccess.Visible = true;
                pnlError.Visible = false;
                txtMessage.Text = string.Empty;
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litError.Text = "Booking Error: " + Server.HtmlEncode(ex.Message);
            }
        }
    }
}
