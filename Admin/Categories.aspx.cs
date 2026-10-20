using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KriyaID
{
    public partial class AdminCategories : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
            }
        }

        private void LoadCategories()
        {
            string sql = @"
                SELECT c.Id, c.Name, c.Description, c.ImageUrl, c.IsActive,
                       (SELECT COUNT(*) FROM SubCategories WHERE CategoryId = c.Id) AS SubCategoryCount
                FROM Categories c
                ORDER BY c.Id ASC";

            DataTable dt = DB.GetDataTable(sql);
            gvCategories.DataSource = dt;
            gvCategories.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int editId = Convert.ToInt32(hfEditId.Value);
            string name = txtName.Text.Trim();
            string desc = txtDescription.Text.Trim();
            string img = txtImageUrl.Text.Trim();
            bool isActive = chkIsActive.Checked;

            if (editId == 0)
            {
                // Insert
                string sql = "INSERT INTO Categories (Name, Description, ImageUrl, IsActive) VALUES (@Name, @Description, @ImageUrl, @IsActive)";
                DB.ExecuteNonQuery(sql,
                    DB.Param("@Name", name),
                    DB.Param("@Description", desc),
                    DB.Param("@ImageUrl", img),
                    DB.Param("@IsActive", isActive));

                pnlAlert.Visible = true;
                litAlert.Text = "Category created successfully!";
            }
            else
            {
                // Update
                string sql = "UPDATE Categories SET Name = @Name, Description = @Description, ImageUrl = @ImageUrl, IsActive = @IsActive WHERE Id = @Id";
                DB.ExecuteNonQuery(sql,
                    DB.Param("@Name", name),
                    DB.Param("@Description", desc),
                    DB.Param("@ImageUrl", img),
                    DB.Param("@IsActive", isActive),
                    DB.Param("@Id", editId));

                pnlAlert.Visible = true;
                litAlert.Text = "Category updated successfully!";
            }

            ResetForm();
            LoadCategories();
        }

        protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int catId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCategory")
            {
                string sql = "SELECT Id, Name, Description, ImageUrl, IsActive FROM Categories WHERE Id = @Id";
                DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", catId));

                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    hfEditId.Value = r["Id"].ToString();
                    txtName.Text = r["Name"].ToString();
                    txtDescription.Text = r["Description"].ToString();
                    txtImageUrl.Text = r["ImageUrl"].ToString();
                    chkIsActive.Checked = Convert.ToBoolean(r["IsActive"]);

                    litFormTitle.Text = "Edit Living Space Category";
                    btnSave.Text = "Update Category";
                    btnCancel.Visible = true;
                }
            }
            else if (e.CommandName == "DeleteCategory")
            {
                DB.ExecuteNonQuery("DELETE FROM Categories WHERE Id = @Id", DB.Param("@Id", catId));
                pnlAlert.Visible = true;
                litAlert.Text = "Category deleted successfully.";
                LoadCategories();
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            hfEditId.Value = "0";
            txtName.Text = string.Empty;
            txtDescription.Text = string.Empty;
            txtImageUrl.Text = string.Empty;
            chkIsActive.Checked = true;
            litFormTitle.Text = "Add New Living Space";
            btnSave.Text = "Save Category";
            btnCancel.Visible = false;
        }
    }
}
