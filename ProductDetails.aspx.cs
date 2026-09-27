using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KriyaID
{
    public partial class ProductDetails : Page
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
            if (ProductId <= 0)
            {
                Response.Redirect("~/Products.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProduct();
                LoadGallery();
                LoadVariants();
                CalculatePrice();
                LoadReviews();
                LoadRelatedProducts();

                if (Session["UserId"] == null)
                {
                    phAddReview.Visible = false;
                    phLoginToReview.Visible = true;
                }
                else
                {
                    phAddReview.Visible = true;
                    phLoginToReview.Visible = false;
                }
            }
        }

        private void LoadProduct()
        {
            string sql = @"
                SELECT 
                    p.Id, p.Name, p.Description, p.Price, p.DiscountPercent, p.Stock, p.SubCategoryId,
                    c.Name AS CategoryName, sc.Name AS SubCategoryName,
                    ISNULL(AVG(CAST(r.Rating AS FLOAT)), 5.0) AS AvgRating,
                    COUNT(r.Id) AS ReviewCount
                FROM Products p
                INNER JOIN SubCategories sc ON p.SubCategoryId = sc.Id
                INNER JOIN Categories c ON sc.CategoryId = c.Id
                LEFT JOIN Reviews r ON p.Id = r.ProductId
                WHERE p.Id = @Id
                GROUP BY p.Id, p.Name, p.Description, p.Price, p.DiscountPercent, p.Stock, p.SubCategoryId, c.Name, sc.Name";

            DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", ProductId));
            if (dt.Rows.Count == 0)
            {
                Response.Redirect("~/Products.aspx");
                return;
            }

            DataRow row = dt.Rows[0];
            litProductName.Text = Server.HtmlEncode(row["Name"].ToString());
            litBreadcrumbName.Text = Server.HtmlEncode(row["Name"].ToString());
            litCategory.Text = Server.HtmlEncode(row["CategoryName"].ToString());
            litSubCategory.Text = Server.HtmlEncode(row["SubCategoryName"].ToString());
            litDescription.Text = Server.HtmlEncode(row["Description"].ToString()).Replace("\n", "<br/>");

            double avgRating = Convert.ToDouble(row["AvgRating"]);
            litAvgRating.Text = string.Format("{0:0.0}", avgRating);
            litReviewCount.Text = row["ReviewCount"].ToString();

            int stock = Convert.ToInt32(row["Stock"]);
            if (stock > 5)
            {
                litStockStatus.Text = "<span class='stock-pill stock-in'><i class='bi bi-check-circle me-1'></i>In Stock (" + stock + " available)</span>";
                btnAddToCart.Enabled = true;
            }
            else if (stock > 0)
            {
                litStockStatus.Text = "<span class='stock-pill stock-low'><i class='bi bi-exclamation-circle me-1'></i>Only " + stock + " left in stock</span>";
                btnAddToCart.Enabled = true;
            }
            else
            {
                litStockStatus.Text = "<span class='stock-pill stock-out'><i class='bi bi-x-circle me-1'></i>Currently Out of Stock</span>";
                btnAddToCart.Enabled = false;
                btnAddToCart.Text = "Out of Stock";
            }

            // Save Base Price & Discount to ViewState for dynamic variant calculations
            ViewState["BasePrice"] = Convert.ToDecimal(row["Price"]);
            ViewState["DiscountPercent"] = Convert.ToInt32(row["DiscountPercent"]);
            ViewState["SubCategoryId"] = Convert.ToInt32(row["SubCategoryId"]);
        }

        private void LoadGallery()
        {
            string sql = "SELECT ImageUrl, IsPrimary FROM ProductImages WHERE ProductId = @Id ORDER BY IsPrimary DESC, Id ASC";
            DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", ProductId));

            if (dt.Rows.Count > 0)
            {
                imgMain.ImageUrl = dt.Rows[0]["ImageUrl"].ToString();
                rptThumbnails.DataSource = dt;
                rptThumbnails.DataBind();
            }
            else
            {
                imgMain.ImageUrl = "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80";
            }
        }

        private void LoadVariants()
        {
            string sql = "SELECT Id, VariantName, VariantValue, AdditionalPrice, Stock FROM ProductVariants WHERE ProductId = @Id";
            DataTable dt = DB.GetDataTable(sql, DB.Param("@Id", ProductId));

            if (dt.Rows.Count > 0)
            {
                phVariants.Visible = true;
                ddlVariants.Items.Clear();
                ddlVariants.Items.Add(new ListItem("Standard Base Edition (+\u20B90)", "0"));

                foreach (DataRow row in dt.Rows)
                {
                    decimal extra = Convert.ToDecimal(row["AdditionalPrice"]);
                    string text = row["VariantName"] + ": " + row["VariantValue"];
                    if (extra > 0)
                    {
                        text += " (+\u20B9" + string.Format("{0:N0}", extra) + ")";
                    }
                    ddlVariants.Items.Add(new ListItem(text, row["Id"].ToString()));
                }
            }
            else
            {
                phVariants.Visible = false;
            }
        }

        private void CalculatePrice()
        {
            if (ViewState["BasePrice"] == null) return;

            decimal basePrice = Convert.ToDecimal(ViewState["BasePrice"]);
            int discount = Convert.ToInt32(ViewState["DiscountPercent"]);
            decimal additionalPrice = 0;

            if (phVariants.Visible && ddlVariants.SelectedIndex > 0)
            {
                int variantId = Convert.ToInt32(ddlVariants.SelectedValue);
                object extra = DB.ExecuteScalar("SELECT AdditionalPrice FROM ProductVariants WHERE Id = @Id",
                    DB.Param("@Id", variantId));
                if (extra != null && extra != DBNull.Value)
                {
                    additionalPrice = Convert.ToDecimal(extra);
                }
            }

            decimal totalOriginal = basePrice + additionalPrice;
            decimal totalFinal = totalOriginal * (100 - discount) / 100m;

            litFinalPrice.Text = string.Format("{0:N0}", totalFinal);

            if (discount > 0)
            {
                phDiscount.Visible = true;
                litOriginalPrice.Text = string.Format("{0:N0}", totalOriginal);
                litDiscountPercent.Text = discount.ToString();
            }
            else
            {
                phDiscount.Visible = false;
            }
        }

        protected void ddlVariants_SelectedIndexChanged(object sender, EventArgs e)
        {
            CalculatePrice();
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);
            int qty = Convert.ToInt32(ddlQuantity.SelectedValue);
            int? variantId = null;

            if (phVariants.Visible && ddlVariants.SelectedIndex > 0)
            {
                variantId = Convert.ToInt32(ddlVariants.SelectedValue);
            }

            // Check if already in cart
            string checkSql = @"
                SELECT Id, Quantity FROM CartItems 
                WHERE UserId = @UserId AND ProductId = @ProductId 
                AND ((@VariantId IS NULL AND VariantId IS NULL) OR VariantId = @VariantId)";

            DataTable dt = DB.GetDataTable(checkSql,
                DB.Param("@UserId", userId),
                DB.Param("@ProductId", ProductId),
                DB.Param("@VariantId", (object)variantId ?? DBNull.Value));

            if (dt.Rows.Count > 0)
            {
                // Update quantity
                int cartItemId = Convert.ToInt32(dt.Rows[0]["Id"]);
                int currentQty = Convert.ToInt32(dt.Rows[0]["Quantity"]);
                DB.ExecuteNonQuery("UPDATE CartItems SET Quantity = Quantity + @Qty WHERE Id = @Id",
                    DB.Param("@Qty", qty), DB.Param("@Id", cartItemId));
            }
            else
            {
                // Insert new cart item
                string insertSql = @"
                    INSERT INTO CartItems (UserId, ProductId, VariantId, Quantity, AddedOn)
                    VALUES (@UserId, @ProductId, @VariantId, @Qty, GETDATE())";

                DB.ExecuteNonQuery(insertSql,
                    DB.Param("@UserId", userId),
                    DB.Param("@ProductId", ProductId),
                    DB.Param("@VariantId", (object)variantId ?? DBNull.Value),
                    DB.Param("@Qty", qty));
            }

            pnlActionAlert.Visible = true;
            litActionAlert.Text = "<strong>Success!</strong> Added to your atelier shopping cart.";

            var master = Master as Site;
            if (master != null) master.RefreshUserBar();
        }

        protected void btnAddToWishlist_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);

            object count = DB.ExecuteScalar("SELECT COUNT(*) FROM Wishlist WHERE UserId = @UserId AND ProductId = @ProductId",
                DB.Param("@UserId", userId), DB.Param("@ProductId", ProductId));

            if (Convert.ToInt32(count) == 0)
            {
                DB.ExecuteNonQuery("INSERT INTO Wishlist (UserId, ProductId) VALUES (@UserId, @ProductId)",
                    DB.Param("@UserId", userId), DB.Param("@ProductId", ProductId));
            }

            pnlActionAlert.Visible = true;
            litActionAlert.Text = "<strong>Saved!</strong> Item added to your personal Wishlist.";

            var master = Master as Site;
            if (master != null) master.RefreshUserBar();
        }

        private void LoadReviews()
        {
            string sql = @"
                SELECT r.Rating, r.Comment, r.CreatedOn, u.FullName 
                FROM Reviews r
                INNER JOIN Users u ON r.UserId = u.Id
                WHERE r.ProductId = @ProductId
                ORDER BY r.Id DESC";

            DataTable dt = DB.GetDataTable(sql, DB.Param("@ProductId", ProductId));
            pnlNoReviews.Visible = dt.Rows.Count == 0;
            rptReviews.DataSource = dt;
            rptReviews.DataBind();
        }

        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);
            int rating = Convert.ToInt32(ddlReviewRating.SelectedValue);
            string comment = txtReviewComment.Text.Trim();

            if (!string.IsNullOrEmpty(comment))
            {
                DB.ExecuteNonQuery("INSERT INTO Reviews (UserId, ProductId, Rating, Comment, CreatedOn) VALUES (@UserId, @ProductId, @Rating, @Comment, GETDATE())",
                    DB.Param("@UserId", userId),
                    DB.Param("@ProductId", ProductId),
                    DB.Param("@Rating", rating),
                    DB.Param("@Comment", comment));

                txtReviewComment.Text = string.Empty;
                LoadReviews();
                LoadProduct();
            }
        }

        private void LoadRelatedProducts()
        {
            if (ViewState["SubCategoryId"] == null) return;
            int subCatId = Convert.ToInt32(ViewState["SubCategoryId"]);

            string sql = @"
                SELECT TOP 4 
                    p.Id, p.Name, p.Price, p.DiscountPercent,
                    ISNULL((SELECT TOP 1 ImageUrl FROM ProductImages WHERE ProductId = p.Id ORDER BY IsPrimary DESC, Id ASC), 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80') AS PrimaryImage
                FROM Products p
                WHERE p.SubCategoryId = @SubCatId AND p.Id <> @Id
                ORDER BY p.Id DESC";

            DataTable dt = DB.GetDataTable(sql, DB.Param("@SubCatId", subCatId), DB.Param("@Id", ProductId));
            rptRelatedProducts.DataSource = dt;
            rptRelatedProducts.DataBind();
        }

        public string RenderStars(int rating)
        {
            string html = "";
            for (int i = 1; i <= 5; i++)
            {
                if (i <= rating)
                {
                    html += "<i class='bi bi-star-fill text-warning me-1'></i>";
                }
                else
                {
                    html += "<i class='bi bi-star text-muted me-1'></i>";
                }
            }
            return html;
        }
    }
}
