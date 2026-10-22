using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KriyaID
{
    public partial class AdminProductEdit : Page
    {
        private int ProductId
        {
            get
            {
                int id;
                int.TryParse(Request.QueryString["id"], out id);
                return id;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSubCategories();

                if (ProductId > 0)
                {
                    litPageTitle.Text = "Edit Atelier Piece #" + ProductId;
                    LoadProduct();
                    LoadImages();
                    LoadVariants();
                    phImageUpload.Visible = true;
                    phVariantsSection.Visible = true;
                    phSaveProductFirstMsg.Visible = false;
                }
                else
                {
                    litPageTitle.Text = "Create New Atelier Piece";
                    phImageUpload.Visible = false;
                    phVariantsSection.Visible = false;
                    phSaveProductFirstMsg.Visible = true;
                }
            }
        }

        private void LoadSubCategories()
        {
            string sql = @"
                SELECT sc.Id, c.Name + ' > ' + sc.Name AS DisplayName 
                FROM SubCategories sc 
                INNER JOIN Categories c ON sc.CategoryId = c.Id 
                ORDER BY c.Name, sc.Name";

            DataTable dt = DB.GetDataTable(sql);
            ddlSubCategory.DataSource = dt;
            ddlSubCategory.DataTextField = "DisplayName";
            ddlSubCategory.DataValueField = "Id";
            ddlSubCategory.DataBind();
        }

        private void LoadProduct()
        {
            string sql = "SELECT * FROM Products WHERE Id = @Id";
            DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", ProductId));

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                ddlSubCategory.SelectedValue = r["SubCategoryId"].ToString();
                txtName.Text = r["Name"].ToString();
                txtDescription.Text = r["Description"].ToString();
                txtPrice.Text = Convert.ToDecimal(r["Price"]).ToString("0.00");
                txtDiscountPercent.Text = r["DiscountPercent"].ToString();
                txtStock.Text = r["Stock"].ToString();
                chkIsFeatured.Checked = Convert.ToBoolean(r["IsFeatured"]);
            }
        }

        private void LoadImages()
        {
            string sql = "SELECT Id, ImageUrl, IsPrimary FROM ProductImages WHERE ProductId = @Id ORDER BY IsPrimary DESC, Id ASC";
            DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", ProductId));
            rptImages.DataSource = dt;
            rptImages.DataBind();
        }

        private void LoadVariants()
        {
            string sql = "SELECT Id, VariantName, VariantValue, AdditionalPrice, Stock FROM ProductVariants WHERE ProductId = @Id";
            DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", ProductId));
            rptVariants.DataSource = dt;
            rptVariants.DataBind();
        }

        protected void btnSaveProduct_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int subCatId = Convert.ToInt32(ddlSubCategory.SelectedValue);
            string name = txtName.Text.Trim();
            string desc = txtDescription.Text.Trim();
            decimal price = Convert.ToDecimal(txtPrice.Text.Trim());
            int discount = 0;
            int.TryParse(txtDiscountPercent.Text.Trim(), out discount);
            int stock = Convert.ToInt32(txtStock.Text.Trim());
            bool isFeatured = chkIsFeatured.Checked;

            if (ProductId == 0)
            {
                // Insert new product
                string sql = @"
                    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured, CreatedOn)
                    VALUES (@SubCategoryId, @Name, @Description, @Price, @DiscountPercent, @Stock, @IsFeatured, GETDATE());
                    SELECT SCOPE_IDENTITY();";

                object newId = DB.ExecuteScalar(sql,
                    DB.Param("@SubCategoryId", subCatId),
                    DB.Param("@Name", name),
                    DB.Param("@Description", desc),
                    DB.Param("@Price", price),
                    DB.Param("@DiscountPercent", discount),
                    DB.Param("@Stock", stock),
                    DB.Param("@IsFeatured", isFeatured));

                int createdId = Convert.ToInt32(newId);

                // Handle uploaded files immediately if any
                HandleUploadedFiles(createdId);

                Response.Redirect("~/Admin/ProductEdit.aspx?id=" + createdId);
            }
            else
            {
                // Update product
                string sql = @"
                    UPDATE Products 
                    SET SubCategoryId = @SubCategoryId, Name = @Name, Description = @Description,
                        Price = @Price, DiscountPercent = @DiscountPercent, Stock = @Stock, IsFeatured = @IsFeatured
                    WHERE Id = @Id";

                DB.ExecuteNonQuery(sql,
                    DB.Param("@SubCategoryId", subCatId),
                    DB.Param("@Name", name),
                    DB.Param("@Description", desc),
                    DB.Param("@Price", price),
                    DB.Param("@DiscountPercent", discount),
                    DB.Param("@Stock", stock),
                    DB.Param("@IsFeatured", isFeatured),
                    DB.Param("@Id", ProductId));

                // Handle uploaded files
                HandleUploadedFiles(ProductId);

                pnlAlert.Visible = true;
                litAlert.Text = "Piece details saved successfully.";
                LoadImages();
            }
        }

        private void HandleUploadedFiles(int prodId)
        {
            if (fuImages.HasFiles)
            {
                string uploadDir = Server.MapPath("~/images/products/");
                if (!Directory.Exists(uploadDir))
                {
                    Directory.CreateDirectory(uploadDir);
                }

                foreach (HttpPostedFile uploadedFile in fuImages.PostedFiles)
                {
                    if (uploadedFile.ContentLength > 0)
                    {
                        string ext = Path.GetExtension(uploadedFile.FileName).ToLower();
                        if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".webp")
                        {
                            string fileName = "prod_" + prodId + "_" + Guid.NewGuid().ToString("N").Substring(0, 8) + ext;
                            string savePath = Path.Combine(uploadDir, fileName);
                            uploadedFile.SaveAs(savePath);

                            string webPath = "images/products/" + fileName;

                            // Check if first image for product
                            object imgCount = DB.ExecuteScalar("SELECT COUNT(*) FROM ProductImages WHERE ProductId = @ProductId", DB.Param("@ProductId", prodId));
                            bool isPrimary = (Convert.ToInt32(imgCount) == 0);

                            DB.ExecuteNonQuery("INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES (@ProductId, @ImageUrl, @IsPrimary)",
                                DB.Param("@ProductId", prodId),
                                DB.Param("@ImageUrl", webPath),
                                DB.Param("@IsPrimary", isPrimary));
                        }
                    }
                }
            }
        }

        protected void btnAddImageUrl_Click(object sender, EventArgs e)
        {
            if (ProductId <= 0) return;

            string url = txtImageUrl.Text.Trim();
            if (!string.IsNullOrEmpty(url))
            {
                object imgCount = DB.ExecuteScalar("SELECT COUNT(*) FROM ProductImages WHERE ProductId = @ProductId", DB.Param("@ProductId", ProductId));
                bool isPrimary = (Convert.ToInt32(imgCount) == 0);

                DB.ExecuteNonQuery("INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES (@ProductId, @ImageUrl, @IsPrimary)",
                    DB.Param("@ProductId", ProductId),
                    DB.Param("@ImageUrl", url),
                    DB.Param("@IsPrimary", isPrimary));

                txtImageUrl.Text = string.Empty;
                LoadImages();
            }
        }

        protected void rptImages_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int imgId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "SetPrimary")
            {
                DB.ExecuteNonQuery("UPDATE ProductImages SET IsPrimary = 0 WHERE ProductId = @ProductId", DB.Param("@ProductId", ProductId));
                DB.ExecuteNonQuery("UPDATE ProductImages SET IsPrimary = 1 WHERE Id = @Id", DB.Param("@Id", imgId));
                LoadImages();
            }
            else if (e.CommandName == "DeleteImage")
            {
                DB.ExecuteNonQuery("DELETE FROM ProductImages WHERE Id = @Id", DB.Param("@Id", imgId));
                LoadImages();
            }
        }

        protected void btnAddVariant_Click(object sender, EventArgs e)
        {
            if (ProductId <= 0) return;

            string varName = txtVarName.Text.Trim();
            string varValue = txtVarValue.Text.Trim();
            decimal extra = 0;
            decimal.TryParse(txtVarExtraPrice.Text.Trim(), out extra);
            int stock = 10;
            int.TryParse(txtVarStock.Text.Trim(), out stock);

            if (!string.IsNullOrEmpty(varName) && !string.IsNullOrEmpty(varValue))
            {
                string sql = "INSERT INTO ProductVariants (ProductId, VariantName, VariantValue, AdditionalPrice, Stock) VALUES (@ProductId, @VariantName, @VariantValue, @AdditionalPrice, @Stock)";
                DB.ExecuteNonQuery(sql,
                    DB.Param("@ProductId", ProductId),
                    DB.Param("@VariantName", varName),
                    DB.Param("@VariantValue", varValue),
                    DB.Param("@AdditionalPrice", extra),
                    DB.Param("@Stock", stock));

                txtVarName.Text = string.Empty;
                txtVarValue.Text = string.Empty;
                txtVarExtraPrice.Text = string.Empty;
                txtVarStock.Text = string.Empty;

                LoadVariants();
            }
        }

        protected void rptVariants_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteVariant")
            {
                int varId = Convert.ToInt32(e.CommandArgument);
                DB.ExecuteNonQuery("DELETE FROM ProductVariants WHERE Id = @Id", DB.Param("@Id", varId));
                LoadVariants();
            }
        }
    }
}
