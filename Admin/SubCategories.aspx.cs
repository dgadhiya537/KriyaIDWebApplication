using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KriyaID
{
    public partial class AdminSubCategories : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategoryDropdowns();
                LoadSubCategories();
            }
        }

        private void LoadCategoryDropdowns()
        {
            DataTable dt = DB.GetDataTable("SELECT Id, Name FROM Categories WHERE IsActive = 1 ORDER BY Name ASC");

            ddlFormCategory.DataSource = dt;
            ddlFormCategory.DataTextField = "Name";
            ddlFormCategory.DataValueField = "Id";
            ddlFormCategory.DataBind();

            ddlFilterCategory.Items.Clear();
            ddlFilterCategory.Items.Add(new ListItem("All Categories", "0"));
            foreach (DataRow r in dt.Rows)
            {
                ddlFilterCategory.Items.Add(new ListItem(r["Name"].ToString(), r["Id"].ToString()));
            }
        }

        private void LoadSubCategories()
        {
            int catId = Convert.ToInt32(ddlFilterCategory.SelectedValue);
            string sql = @"
                SELECT sc.Id, sc.CategoryId, sc.Name, sc.Description, sc.ImageUrl, sc.IsActive,
                       c.Name AS CategoryName,
                       (SELECT COUNT(*) FROM Products WHERE SubCategoryId = sc.Id) AS ProductCount
                FROM SubCategories sc
                INNER JOIN Categories c ON sc.CategoryId = c.Id";

            if (catId > 0)
            {
                sql += " WHERE sc.CategoryId = @CategoryId";
            }
            sql += " ORDER BY c.Name ASC, sc.Name ASC";

            DataTable dt = catId > 0
                ? DB.GetDataTable(sql, DB.Param("@CategoryId", catId))
                : DB.GetDataTable(sql);

            gvSubCategories.DataSource = dt;
            gvSubCategories.DataBind();
        }

        protected void ddlFilterCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadSubCategories();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int editId = Convert.ToInt32(hfEditId.Value);
            int catId = Convert.ToInt32(ddlFormCategory.SelectedValue);
            string name = txtName.Text.Trim();
            string desc = txtDescription.Text.Trim();
            string img = txtImageUrl.Text.Trim();
            bool isActive = chkIsActive.Checked;

            if (editId == 0)
            {
                // Insert
                string sql = "INSERT INTO SubCategories (CategoryId, Name, Description, ImageUrl, IsActive) VALUES (@CategoryId, @Name, @Description, @ImageUrl, @IsActive)";
                DB.ExecuteNonQuery(sql,
                    DB.Param("@CategoryId", catId),
                    DB.Param("@Name", name),
                    DB.Param("@Description", desc),
                    DB.Param("@ImageUrl", img),
                    DB.Param("@IsActive", isActive));

                pnlAlert.Visible = true;
                litAlert.Text = "Sub-Category added successfully!";
            }
            else
            {
                // Update
                string sql = "UPDATE SubCategories SET CategoryId = @CategoryId, Name = @Name, Description = @Description, ImageUrl = @ImageUrl, IsActive = @IsActive WHERE Id = @Id";
                DB.ExecuteNonQuery(sql,
                    DB.Param("@CategoryId", catId),
                    DB.Param("@Name", name),
                    DB.Param("@Description", desc),
                    DB.Param("@ImageUrl", img),
                    DB.Param("@IsActive", isActive),
                    DB.Param("@Id", editId));

                pnlAlert.Visible = true;
                litAlert.Text = "Sub-Category updated successfully!";
            }

            ResetForm();
            LoadSubCategories();
        }

        protected void gvSubCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int subCatId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditSubCategory")
            {
                string sql = "SELECT Id, CategoryId, Name, Description, ImageUrl, IsActive FROM SubCategories WHERE Id = @Id";
                DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", subCatId));

                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    hfEditId.Value = r["Id"].ToString();
                    ddlFormCategory.SelectedValue = r["CategoryId"].ToString();
                    txtName.Text = r["Name"].ToString();
                    txtDescription.Text = r["Description"].ToString();
                    txtImageUrl.Text = r["ImageUrl"].ToString();
                    chkIsActive.Checked = Convert.ToBoolean(r["IsActive"]);

                    litFormTitle.Text = "Edit Sub-Category";
                    btnSave.Text = "Update Sub-Category";
                    btnCancel.Visible = true;
                }
            }
            else if (e.CommandName == "DeleteSubCategory")
            {
                DB.ExecuteNonQuery("DELETE FROM SubCategories WHERE Id = @Id", DB.Param("@Id", subCatId));
                pnlAlert.Visible = true;
                litAlert.Text = "Sub-Category deleted successfully.";
                LoadSubCategories();
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
            litFormTitle.Text = "Add New Sub-Category";
            btnSave.Text = "Save Sub-Category";
            btnCancel.Visible = false;
        }
    }
}
