using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KriyaID
{
    public partial class AdminBanners : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBanners();
            }
        }

        private void LoadBanners()
        {
            string sql = "SELECT * FROM Banners ORDER BY DisplayOrder ASC, Id ASC";
            DataTable dt = DB.GetDataTable(sql);
            gvBanners.DataSource = dt;
            gvBanners.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int editId = Convert.ToInt32(hfEditId.Value);
            string title = txtTitle.Text.Trim();
            string subtitle = txtSubtitle.Text.Trim();
            string img = txtImageUrl.Text.Trim();
            string link = txtLinkUrl.Text.Trim();
            int order = 1;
            int.TryParse(txtDisplayOrder.Text.Trim(), out order);
            bool isActive = chkIsActive.Checked;

            if (editId == 0)
            {
                // Insert
                string sql = "INSERT INTO Banners (Title, Subtitle, ImageUrl, LinkUrl, IsActive, DisplayOrder) VALUES (@Title, @Subtitle, @ImageUrl, @LinkUrl, @IsActive, @DisplayOrder)";
                DB.ExecuteNonQuery(sql,
                    DB.Param("@Title", title),
                    DB.Param("@Subtitle", subtitle),
                    DB.Param("@ImageUrl", img),
                    DB.Param("@LinkUrl", link),
                    DB.Param("@IsActive", isActive),
                    DB.Param("@DisplayOrder", order));

                pnlAlert.Visible = true;
                litAlert.Text = "Banner added successfully!";
            }
            else
            {
                // Update
                string sql = "UPDATE Banners SET Title = @Title, Subtitle = @Subtitle, ImageUrl = @ImageUrl, LinkUrl = @LinkUrl, IsActive = @IsActive, DisplayOrder = @DisplayOrder WHERE Id = @Id";
                DB.ExecuteNonQuery(sql,
                    DB.Param("@Title", title),
                    DB.Param("@Subtitle", subtitle),
                    DB.Param("@ImageUrl", img),
                    DB.Param("@LinkUrl", link),
                    DB.Param("@IsActive", isActive),
                    DB.Param("@DisplayOrder", order),
                    DB.Param("@Id", editId));

                pnlAlert.Visible = true;
                litAlert.Text = "Banner updated successfully!";
            }

            ResetForm();
            LoadBanners();
        }

        protected void gvBanners_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int bannerId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditBanner")
            {
                string sql = "SELECT * FROM Banners WHERE Id = @Id";
                DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", bannerId));

                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    hfEditId.Value = r["Id"].ToString();
                    txtTitle.Text = r["Title"].ToString();
                    txtSubtitle.Text = r["Subtitle"].ToString();
                    txtImageUrl.Text = r["ImageUrl"].ToString();
                    txtLinkUrl.Text = r["LinkUrl"].ToString();
                    txtDisplayOrder.Text = r["DisplayOrder"].ToString();
                    chkIsActive.Checked = Convert.ToBoolean(r["IsActive"]);

                    litFormTitle.Text = "Edit Carousel Banner";
                    btnSave.Text = "Update Banner";
                    btnCancel.Visible = true;
                }
            }
            else if (e.CommandName == "DeleteBanner")
            {
                DB.ExecuteNonQuery("DELETE FROM Banners WHERE Id = @Id", DB.Param("@Id", bannerId));
                pnlAlert.Visible = true;
                litAlert.Text = "Banner deleted successfully.";
                LoadBanners();
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            hfEditId.Value = "0";
            txtTitle.Text = string.Empty;
            txtSubtitle.Text = string.Empty;
            txtImageUrl.Text = string.Empty;
            txtLinkUrl.Text = string.Empty;
            txtDisplayOrder.Text = "1";
            chkIsActive.Checked = true;
            litFormTitle.Text = "Add Hero Carousel Banner";
            btnSave.Text = "Save Banner";
            btnCancel.Visible = false;
        }
    }
}
