using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KriyaID
{
    public partial class Products : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategoryDropdown();
                LoadSubCategoryDropdown();

                // Check query strings
                if (!string.IsNullOrEmpty(Request.QueryString["cat"]))
                {
                    string catParam = Request.QueryString["cat"].Trim();
                    if (ddlCategory.Items.FindByValue(catParam) != null)
                    {
                        ddlCategory.SelectedValue = catParam;
                        LoadSubCategoryDropdown();
                    }
                    else
                    {
                        foreach (ListItem item in ddlCategory.Items)
                        {
                            if (string.Equals(item.Text, catParam, StringComparison.OrdinalIgnoreCase) ||
                                item.Text.IndexOf(catParam, StringComparison.OrdinalIgnoreCase) >= 0)
                            {
                                ddlCategory.SelectedValue = item.Value;
                                LoadSubCategoryDropdown();
                                break;
                            }
                        }
                    }
                }

                if (!string.IsNullOrEmpty(Request.QueryString["subcat"]))
                {
                    string subCatParam = Request.QueryString["subcat"].Trim();
                    if (ddlSubCategory.Items.FindByValue(subCatParam) != null)
                    {
                        ddlSubCategory.SelectedValue = subCatParam;
                    }
                    else
                    {
                        bool matched = false;
                        foreach (ListItem item in ddlSubCategory.Items)
                        {
                            if (string.Equals(item.Text, subCatParam, StringComparison.OrdinalIgnoreCase) ||
                                item.Text.IndexOf(subCatParam, StringComparison.OrdinalIgnoreCase) >= 0)
                            {
                                ddlSubCategory.SelectedValue = item.Value;
                                matched = true;
                                break;
                            }
                        }
                        if (!matched && string.IsNullOrEmpty(Request.QueryString["q"]))
                        {
                            txtSearchKeyword.Text = subCatParam;
                        }
                    }
                }

                if (!string.IsNullOrEmpty(Request.QueryString["q"]))
                {
                    txtSearchKeyword.Text = Request.QueryString["q"];
                }

                if (!string.IsNullOrEmpty(Request.QueryString["sort"]))
                {
                    if (ddlSortBy.Items.FindByValue(Request.QueryString["sort"]) != null)
                    {
                        ddlSortBy.SelectedValue = Request.QueryString["sort"];
                    }
                }

                if (!string.IsNullOrEmpty(Request.QueryString["filter"]))
                {
                    string f = Request.QueryString["filter"].ToLower();
                    if (f == "new")
                    {
                        if (ddlSortBy.Items.FindByValue("newest") != null)
                        {
                            ddlSortBy.SelectedValue = "newest";
                        }
                    }
                }

                BindTopSubCategories();
                BindProducts();
            }
        }

        private void LoadCategoryDropdown()
        {
            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(new ListItem("All Living Spaces", "0"));

            DataTable dt = DB.GetDataTable("SELECT Id, Name FROM Categories WHERE IsActive = 1 ORDER BY Name ASC");
            foreach (DataRow row in dt.Rows)
            {
                ddlCategory.Items.Add(new ListItem(row["Name"].ToString(), row["Id"].ToString()));
            }
        }

        private void LoadSubCategoryDropdown()
        {
            ddlSubCategory.Items.Clear();
            ddlSubCategory.Items.Add(new ListItem("All Sub-Categories", "0"));

            int catId = Convert.ToInt32(ddlCategory.SelectedValue);
            string query = "SELECT Id, Name FROM SubCategories WHERE IsActive = 1";
            if (catId > 0)
            {
                query += " AND CategoryId = @CategoryId";
            }
            query += " ORDER BY Name ASC";

            DataTable dt = catId > 0
                ? DB.GetDataTable(query, DB.Param("@CategoryId", catId))
                : DB.GetDataTable(query);

            foreach (DataRow row in dt.Rows)
            {
                ddlSubCategory.Items.Add(new ListItem(row["Name"].ToString(), row["Id"].ToString()));
            }
        }

        private void BindProducts()
        {
            List<SqlParameter> paramList = new List<SqlParameter>();
            string whereClause = " WHERE 1=1 ";

            int catId = Convert.ToInt32(ddlCategory.SelectedValue);
            if (catId > 0)
            {
                whereClause += " AND c.Id = @CatId ";
                paramList.Add(DB.Param("@CatId", catId));
            }

            int subCatId = Convert.ToInt32(ddlSubCategory.SelectedValue);
            if (subCatId > 0)
            {
                whereClause += " AND sc.Id = @SubCatId ";
                paramList.Add(DB.Param("@SubCatId", subCatId));
            }

            string keyword = txtSearchKeyword.Text.Trim();
            if (!string.IsNullOrEmpty(keyword))
            {
                whereClause += " AND (p.Name LIKE @Keyword OR p.Description LIKE @Keyword OR sc.Name LIKE @Keyword OR c.Name LIKE @Keyword) ";
                paramList.Add(DB.Param("@Keyword", "%" + keyword + "%"));
            }

            if (!string.IsNullOrEmpty(Request.QueryString["filter"]))
            {
                string f = Request.QueryString["filter"].ToLower();
                if (f == "sale" || f == "discount" || f == "offers" || f == "clearance" || f == "deals")
                {
                    whereClause += " AND p.DiscountPercent > 0 ";
                }
                else if (f == "bestseller" || f == "trending")
                {
                    whereClause += " AND p.IsFeatured = 1 ";
                }
            }

            decimal minPrice;
            if (decimal.TryParse(txtMinPrice.Text.Trim(), out minPrice) && minPrice > 0)
            {
                whereClause += " AND p.Price >= @MinPrice ";
                paramList.Add(DB.Param("@MinPrice", minPrice));
            }

            decimal maxPrice;
            if (decimal.TryParse(txtMaxPrice.Text.Trim(), out maxPrice) && maxPrice > 0)
            {
                whereClause += " AND p.Price <= @MaxPrice ";
                paramList.Add(DB.Param("@MaxPrice", maxPrice));
            }

            int minRating = Convert.ToInt32(ddlRating.SelectedValue);
            string havingClause = "";
            if (minRating > 0)
            {
                havingClause = " HAVING ISNULL(AVG(CAST(r.Rating AS FLOAT)), 5.0) >= @MinRating ";
                paramList.Add(DB.Param("@MinRating", minRating));
            }

            string orderBy = " ORDER BY p.Id DESC ";
            switch (ddlSortBy.SelectedValue)
            {
                case "price_low":
                    orderBy = " ORDER BY p.Price ASC ";
                    break;
                case "price_high":
                    orderBy = " ORDER BY p.Price DESC ";
                    break;
                case "name_asc":
                    orderBy = " ORDER BY p.Name ASC ";
                    break;
                case "newest":
                default:
                    orderBy = " ORDER BY p.Id DESC ";
                    break;
            }

            string sql = @"
                SELECT 
                    p.Id, p.Name, p.Description, p.Price, p.DiscountPercent, p.Stock, p.IsFeatured,
                    sc.Name AS SubCategoryName,
                    c.Name AS CategoryName,
                    ISNULL((SELECT TOP 1 ImageUrl FROM ProductImages WHERE ProductId = p.Id ORDER BY IsPrimary DESC, Id ASC), 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80') AS PrimaryImage,
                    ISNULL(AVG(CAST(r.Rating AS FLOAT)), 5.0) AS AvgRating,
                    COUNT(r.Id) AS ReviewCount
                FROM Products p
                INNER JOIN SubCategories sc ON p.SubCategoryId = sc.Id
                INNER JOIN Categories c ON sc.CategoryId = c.Id
                LEFT JOIN Reviews r ON p.Id = r.ProductId
                " + whereClause + @"
                GROUP BY p.Id, p.Name, p.Description, p.Price, p.DiscountPercent, p.Stock, p.IsFeatured, sc.Name, c.Name
                " + havingClause + orderBy;

            DataTable dt = DB.GetDataTable(sql, paramList.ToArray());

            litResultCount.Text = dt.Rows.Count.ToString();
            pnlNoProducts.Visible = dt.Rows.Count == 0;

            lvProducts.DataSource = dt;
            lvProducts.DataBind();
        }

        protected void lvProducts_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            dpProducts.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            BindProducts();
        }

        protected void lvProducts_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            if (e.CommandName == "AddWishlist")
            {
                if (Session["UserId"] == null)
                {
                    Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
                    return;
                }

                int userId = Convert.ToInt32(Session["UserId"]);
                int productId = Convert.ToInt32(e.CommandArgument);

                // Add to wishlist if not exists
                object count = DB.ExecuteScalar("SELECT COUNT(*) FROM Wishlist WHERE UserId = @UserId AND ProductId = @ProductId",
                    DB.Param("@UserId", userId), DB.Param("@ProductId", productId));

                if (Convert.ToInt32(count) == 0)
                {
                    DB.ExecuteNonQuery("INSERT INTO Wishlist (UserId, ProductId) VALUES (@UserId, @ProductId)",
                        DB.Param("@UserId", userId), DB.Param("@ProductId", productId));
                }

                // Update master page badges
                var master = Master as Site;
                if (master != null) master.RefreshUserBar();

                BindProducts();
            }
        }

        private void BindTopSubCategories()
        {
            int catId = 0;
            int.TryParse(ddlCategory.SelectedValue, out catId);

            if (litActiveCategoryName != null)
            {
                litActiveCategoryName.Text = (ddlCategory.SelectedItem != null && catId > 0)
                    ? ddlCategory.SelectedItem.Text
                    : "All Collections";
            }

            string query = "SELECT Id, Name FROM SubCategories WHERE IsActive = 1";
            if (catId > 0)
            {
                query += " AND CategoryId = @CategoryId";
            }
            query += " ORDER BY Name ASC";

            DataTable dt = catId > 0
                ? DB.GetDataTable(query, DB.Param("@CategoryId", catId))
                : DB.GetDataTable(query);

            DataTable pillTable = new DataTable();
            pillTable.Columns.Add("Id", typeof(int));
            pillTable.Columns.Add("Name", typeof(string));
            pillTable.Columns.Add("IsActive", typeof(bool));

            int currentSubCatId = 0;
            int.TryParse(ddlSubCategory.SelectedValue, out currentSubCatId);

            // Add "All" option as first pill
            DataRow allRow = pillTable.NewRow();
            allRow["Id"] = 0;
            allRow["Name"] = "All " + (catId > 0 && ddlCategory.SelectedItem != null ? ddlCategory.SelectedItem.Text : "Pieces");
            allRow["IsActive"] = currentSubCatId == 0;
            pillTable.Rows.Add(allRow);

            foreach (DataRow row in dt.Rows)
            {
                DataRow r = pillTable.NewRow();
                int subId = Convert.ToInt32(row["Id"]);
                r["Id"] = subId;
                r["Name"] = row["Name"].ToString();
                r["IsActive"] = subId == currentSubCatId;
                pillTable.Rows.Add(r);
            }

            if (rptTopSubCategories != null)
            {
                rptTopSubCategories.DataSource = pillTable;
                rptTopSubCategories.DataBind();
            }
        }

        protected void rptTopSubCategories_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectSubCat")
            {
                string subCatId = e.CommandArgument != null ? e.CommandArgument.ToString() : "0";
                if (ddlSubCategory.Items.FindByValue(subCatId) != null)
                {
                    ddlSubCategory.SelectedValue = subCatId;
                }
                else
                {
                    ddlSubCategory.SelectedValue = "0";
                }

                dpProducts.SetPageProperties(0, dpProducts.PageSize, false);
                BindTopSubCategories();
                BindProducts();
            }
        }

        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadSubCategoryDropdown();
            ddlSubCategory.SelectedValue = "0";
            BindTopSubCategories();
            dpProducts.SetPageProperties(0, dpProducts.PageSize, false);
            BindProducts();
        }

        protected void ddlSubCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindTopSubCategories();
            dpProducts.SetPageProperties(0, dpProducts.PageSize, false);
            BindProducts();
        }

        protected void ddlSortBy_SelectedIndexChanged(object sender, EventArgs e)
        {
            dpProducts.SetPageProperties(0, dpProducts.PageSize, false);
            BindProducts();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            dpProducts.SetPageProperties(0, dpProducts.PageSize, false);
            BindProducts();
        }

        protected void btnResetFilters_Click(object sender, EventArgs e)
        {
            ddlCategory.SelectedValue = "0";
            LoadSubCategoryDropdown();
            ddlSubCategory.SelectedValue = "0";
            txtSearchKeyword.Text = string.Empty;
            txtMinPrice.Text = string.Empty;
            txtMaxPrice.Text = string.Empty;
            ddlRating.SelectedValue = "0";
            ddlSortBy.SelectedValue = "newest";

            BindTopSubCategories();
            dpProducts.SetPageProperties(0, dpProducts.PageSize, false);
            BindProducts();
        }
    }
}
