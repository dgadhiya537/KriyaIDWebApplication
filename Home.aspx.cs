using System;
using System.Data;
using System.Web.UI;

namespace KriyaID
{
    public partial class Home : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBanners();
                LoadCategories();
                LoadNewArrivals();
                LoadBestSellers();
            }
        }

        private void LoadBanners()
        {
            string query = "SELECT Id, Title, Subtitle, ImageUrl, LinkUrl FROM Banners WHERE IsActive = 1 ORDER BY DisplayOrder ASC";
            DataTable dt = DB.GetDataTable(query);
            rptBanners.DataSource = dt;
            rptBanners.DataBind();
        }

        private void LoadCategories()
        {
            string query = "SELECT Id, Name, Description, ImageUrl FROM Categories WHERE IsActive = 1 ORDER BY Id ASC";
            DataTable dt = DB.GetDataTable(query);
            rptCategories.DataSource = dt;
            rptCategories.DataBind();
        }

        private void LoadNewArrivals()
        {
            string query = @"
                SELECT TOP 4 
                    p.Id, p.Name, p.Price, p.DiscountPercent, p.Stock, 
                    c.Name AS CategoryName,
                    ISNULL((SELECT TOP 1 ImageUrl FROM ProductImages WHERE ProductId = p.Id ORDER BY IsPrimary DESC, Id ASC), 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80') AS PrimaryImage
                FROM Products p
                INNER JOIN SubCategories sc ON p.SubCategoryId = sc.Id
                INNER JOIN Categories c ON sc.CategoryId = c.Id
                ORDER BY p.Id DESC";

            DataTable dt = DB.GetDataTable(query);
            rptNewArrivals.DataSource = dt;
            rptNewArrivals.DataBind();
        }

        private void LoadBestSellers()
        {
            string query = @"
                SELECT TOP 4 
                    p.Id, p.Name, p.Price, p.DiscountPercent, p.Stock, 
                    c.Name AS CategoryName,
                    ISNULL((SELECT TOP 1 ImageUrl FROM ProductImages WHERE ProductId = p.Id ORDER BY IsPrimary DESC, Id ASC), 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80') AS PrimaryImage
                FROM Products p
                INNER JOIN SubCategories sc ON p.SubCategoryId = sc.Id
                INNER JOIN Categories c ON sc.CategoryId = c.Id
                WHERE p.IsFeatured = 1
                ORDER BY p.Id ASC";

            DataTable dt = DB.GetDataTable(query);
            rptBestSellers.DataSource = dt;
            rptBestSellers.DataBind();
        }
    }
}
