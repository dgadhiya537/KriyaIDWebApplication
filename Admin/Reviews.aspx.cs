using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KriyaID
{
    public partial class AdminReviews : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadReviews();
            }
        }

        private void LoadReviews()
        {
            string sql = @"
                SELECT r.Id, r.ProductId, r.Rating, r.Comment, r.CreatedOn,
                       p.Name AS ProductName, u.FullName
                FROM Reviews r
                INNER JOIN Products p ON r.ProductId = p.Id
                INNER JOIN Users u ON r.UserId = u.Id
                ORDER BY r.Id DESC";

            DataTable dt = DB.GetDataTable(sql);
            litTotalReviews.Text = dt.Rows.Count.ToString();
            gvReviews.DataSource = dt;
            gvReviews.DataBind();
        }

        protected void gvReviews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteReview")
            {
                int reviewId = Convert.ToInt32(e.CommandArgument);
                DB.ExecuteNonQuery("DELETE FROM Reviews WHERE Id = @Id", DB.Param("@Id", reviewId));

                pnlAlert.Visible = true;
                litAlert.Text = "Review removed from storefront.";
                LoadReviews();
            }
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
