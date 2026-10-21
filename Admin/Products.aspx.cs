using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KriyaID
{
    public partial class AdminProducts : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategoryDropdown();
                LoadProducts();
            }
        }

        private void LoadCategoryDropdown()
        {
            DataTable dt = DB.GetDataTable("SELECT Id, Name FROM Categories WHERE IsActive = 1 ORDER BY Name ASC");
            ddlFilterCategory.Items.Clear();
            ddlFilterCategory.Items.Add(new ListItem("All Categories", "0"));
            foreach (DataRow r in dt.Rows)
            {
                ddlFilterCategory.Items.Add(new ListItem(r["Name"].ToString(), r["Id"].ToString()));
            }
        }

        private void LoadProducts()
        {
            List<SqlParameter> paramList = new List<SqlParameter>();
            string where = " WHERE 1=1 ";

            int catId = Convert.ToInt32(ddlFilterCategory.SelectedValue);
            if (catId > 0)
            {
                where += " AND c.Id = @CatId ";
                paramList.Add(DB.Param("@CatId", catId));
            }

            string keyword = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(keyword))
            {
                where += " AND (p.Name LIKE @Keyword OR p.Description LIKE @Keyword) ";
                paramList.Add(DB.Param("@Keyword", "%" + keyword + "%"));
            }

            string sql = @"
                SELECT 
                    p.Id, p.Name, p.Price, p.DiscountPercent, p.Stock, p.IsFeatured,
                    sc.Name AS SubCategoryName,
                    c.Name AS CategoryName,
                    ISNULL((SELECT TOP 1 ImageUrl FROM ProductImages WHERE ProductId = p.Id ORDER BY IsPrimary DESC, Id ASC), 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80') AS PrimaryImage,
                    (SELECT COUNT(*) FROM ProductVariants WHERE ProductId = p.Id) AS VariantCount
                FROM Products p
                INNER JOIN SubCategories sc ON p.SubCategoryId = sc.Id
                INNER JOIN Categories c ON sc.CategoryId = c.Id
                " + where + @"
                ORDER BY p.Id DESC";

            DataTable dt = DB.GetDataTable(sql, paramList.ToArray());
            gvProducts.DataSource = dt;
            gvProducts.DataBind();
        }

        protected void ddlFilterCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteProduct")
            {
                int prodId = Convert.ToInt32(e.CommandArgument);
                DB.ExecuteNonQuery("DELETE FROM Products WHERE Id = @Id", DB.Param("@Id", prodId));

                pnlAlert.Visible = true;
                litAlert.Text = "Product deleted successfully.";
                LoadProducts();
            }
        }
    }
}
