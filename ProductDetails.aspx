<%@ Page Title="Piece Details" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="ProductDetails.aspx.cs" Inherits="KriyaID.ProductDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .gallery-main-img {
            width: 100%;
            height: 480px;
            object-fit: cover;
            border-radius: var(--radius-md);
            border: 1px solid var(--color-beige);
            box-shadow: var(--shadow-soft);
        }
        .gallery-thumb {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: var(--radius-sm);
            border: 2px solid var(--color-beige-light);
            cursor: pointer;
            transition: var(--transition);
        }
        .gallery-thumb:hover, .gallery-thumb.active {
            border-color: var(--color-deep-ocean);
            transform: translateY(-2px);
        }
        .review-box {
            background-color: var(--color-white);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-md);
            padding: 1.5rem;
            margin-bottom: 1.25rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb small">
                <li class="breadcrumb-item"><a href="Home.aspx" style="color: var(--color-deep-ocean);">Home</a></li>
                <li class="breadcrumb-item"><a href="Products.aspx" style="color: var(--color-deep-ocean);">Collections</a></li>
                <li class="breadcrumb-item active text-muted" aria-current="page"><asp:Literal ID="litBreadcrumbName" runat="server"></asp:Literal></li>
            </ol>
        </nav>

        <!-- Product Hero Card -->
        <div class="row g-5">
            <!-- Left Column: Image Gallery -->
            <div class="col-lg-6">
                <div class="mb-3">
                    <asp:Image ID="imgMain" runat="server" CssClass="gallery-main-img" AlternateText="Product Image" />
                </div>
                <!-- Thumbnails Repeater -->
                <div class="d-flex gap-3 flex-wrap">
                    <asp:Repeater ID="rptThumbnails" runat="server">
                        <ItemTemplate>
                            <img src='<%# Eval("ImageUrl") %>' alt="Thumbnail" class="gallery-thumb" onclick="swapMainImage(this.src);" />
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- Right Column: Product Info & Actions -->
            <div class="col-lg-6">
                <!-- Category & Subcategory -->
                <span class="product-category-meta fs-6">
                    <asp:Literal ID="litCategory" runat="server"></asp:Literal> • <asp:Literal ID="litSubCategory" runat="server"></asp:Literal>
                </span>

                <!-- Product Name -->
                <h1 class="brand-font fs-2 mt-2 mb-3">
                    <asp:Literal ID="litProductName" runat="server"></asp:Literal>
                </h1>

                <!-- Rating & Reviews Badge -->
                <div class="d-flex align-items-center gap-2 mb-3">
                    <span class="badge" style="background-color: var(--color-cream); color: var(--color-deep-ocean); border: 1px solid var(--color-beige); font-size: 0.85rem; padding: 6px 12px;">
                        <i class="bi bi-star-fill text-warning me-1"></i><asp:Literal ID="litAvgRating" runat="server">5.0</asp:Literal> (<asp:Literal ID="litReviewCount" runat="server">0</asp:Literal> reviews)
                    </span>
                    <asp:Literal ID="litStockStatus" runat="server"></asp:Literal>
                </div>

                <!-- Price Display -->
                <div class="p-3 rounded mb-4" style="background-color: var(--color-white); border: 1px solid var(--color-beige);">
                    <div class="d-flex align-items-baseline gap-3">
                        <span class="fs-2 fw-bold" style="color: var(--color-deep-ocean);">
                            &#8377;<asp:Literal ID="litFinalPrice" runat="server"></asp:Literal>
                        </span>
                        <asp:PlaceHolder ID="phDiscount" runat="server" Visible="false">
                            <span class="fs-5 text-muted text-decoration-line-through">
                                &#8377;<asp:Literal ID="litOriginalPrice" runat="server"></asp:Literal>
                            </span>
                            <span class="badge" style="background-color: var(--color-deep-ocean); color: var(--color-cream); font-size: 0.85rem;">
                                Save <asp:Literal ID="litDiscountPercent" runat="server"></asp:Literal>%
                            </span>
                        </asp:PlaceHolder>
                    </div>
                    <small class="text-muted d-block mt-1">Inclusive of all taxes • Free White-Glove in-home installation</small>
                </div>

                <!-- Alerts -->
                <asp:Panel ID="pnlActionAlert" runat="server" Visible="false" CssClass="alert alert-success py-2 small" role="alert">
                    <asp:Literal ID="litActionAlert" runat="server"></asp:Literal>
                </asp:Panel>

                <!-- Product Variants Dropdown -->
                <asp:PlaceHolder ID="phVariants" runat="server" Visible="false">
                    <div class="mb-3">
                        <label class="form-label-luxury">Select Customization / Variant</label>
                        <asp:DropDownList ID="ddlVariants" runat="server" CssClass="form-select form-control-luxury" AutoPostBack="true" OnSelectedIndexChanged="ddlVariants_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                </asp:PlaceHolder>

                <!-- Quantity & Actions -->
                <div class="row g-3 align-items-center mb-4">
                    <div class="col-4">
                        <label class="form-label-luxury">Quantity</label>
                        <asp:DropDownList ID="ddlQuantity" runat="server" CssClass="form-select form-control-luxury">
                            <asp:ListItem Value="1" Text="1"></asp:ListItem>
                            <asp:ListItem Value="2" Text="2"></asp:ListItem>
                            <asp:ListItem Value="3" Text="3"></asp:ListItem>
                            <asp:ListItem Value="4" Text="4"></asp:ListItem>
                            <asp:ListItem Value="5" Text="5"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-8 d-flex align-items-end gap-2 pt-4">
                        <asp:Button ID="btnAddToCart" runat="server" CssClass="btn btn-luxury-primary flex-grow-1 py-2" Text="Add to Cart" OnClick="btnAddToCart_Click" />
                        <asp:LinkButton ID="btnAddToWishlist" runat="server" CssClass="btn btn-luxury-outline py-2 px-3" OnClick="btnAddToWishlist_Click" ToolTip="Save to Wishlist" CausesValidation="false">
                            <i class="bi bi-heart"></i>
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Atelier Specifications Box -->
                <div class="p-3 rounded mb-4" style="background-color: var(--color-cream); border: 1px solid var(--color-beige);">
                    <h6 class="fw-semibold mb-2" style="color: var(--color-deep-ocean);"><i class="bi bi-shield-check me-2"></i>Kriya ID Atelier Promise</h6>
                    <ul class="list-unstyled small mb-0" style="line-height: 1.8; color: var(--color-deep-ocean);">
                        <li><i class="bi bi-check2 text-success me-2"></i>Sustainably harvested hardwoods and eco-certified textiles</li>
                        <li><i class="bi bi-check2 text-success me-2"></i>10-Year Structural warranty against warping & defects</li>
                        <li><i class="bi bi-check2 text-success me-2"></i>White-Glove delivery with professional packaging removal</li>
                    </ul>
                </div>

                <!-- Product Description -->
                <div>
                    <h5 class="brand-font mb-2">Architectural Description</h5>
                    <p style="color: var(--color-deep-ocean); line-height: 1.8; font-size: 0.95rem;">
                        <asp:Literal ID="litDescription" runat="server"></asp:Literal>
                    </p>
                </div>
            </div>
        </div>

        <!-- Customer Reviews Section -->
        <div class="mt-5 pt-4 border-top" style="border-color: var(--color-beige) !important;">
            <div class="row g-4">
                <div class="col-lg-7">
                    <h3 class="brand-font mb-4">Client Appraisals & Reviews</h3>

                    <asp:Panel ID="pnlNoReviews" runat="server" Visible="false" CssClass="text-muted py-3">
                        <p>No appraisals yet for this piece. Be the first to share your experience!</p>
                    </asp:Panel>

                    <asp:Repeater ID="rptReviews" runat="server">
                        <ItemTemplate>
                            <div class="review-box">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <div>
                                        <strong style="color: var(--color-deep-ocean);"><%# Eval("FullName") %></strong>
                                        <span class="text-muted small ms-2"><%# Convert.ToDateTime(Eval("CreatedOn")).ToString("dd MMM yyyy") %></span>
                                    </div>
                                    <div>
                                        <%# RenderStars(Convert.ToInt32(Eval("Rating"))) %>
                                    </div>
                                </div>
                                <p class="mb-0 text-muted" style="font-size: 0.92rem; line-height: 1.6;">
                                    <%# Eval("Comment") %>
                                </p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- Add Review Form -->
                <div class="col-lg-5">
                    <div class="filter-card">
                        <h4 class="brand-font mb-3">Leave an Appraisal</h4>

                        <asp:PlaceHolder ID="phAddReview" runat="server">
                            <div class="mb-3">
                                <label class="form-label-luxury">Rating</label>
                                <asp:DropDownList ID="ddlReviewRating" runat="server" CssClass="form-select form-control-luxury">
                                    <asp:ListItem Value="5" Text="★★★★★ (5 Stars - Exceptional)"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="★★★★☆ (4 Stars - Very Good)"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="★★★☆☆ (3 Stars - Average)"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="★★☆☆☆ (2 Stars - Below Expectation)"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="★☆☆☆☆ (1 Star - Poor)"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="mb-3">
                                <label class="form-label-luxury">Your Comments</label>
                                <asp:TextBox ID="txtReviewComment" runat="server" CssClass="form-control form-control-luxury" TextMode="MultiLine" Rows="4" placeholder="Share your experience regarding texture, finish, comfort..."></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvReview" runat="server" ControlToValidate="txtReviewComment" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Please provide a review comment." CssClass="small" />
                            </div>

                            <asp:Button ID="btnSubmitReview" runat="server" CssClass="btn btn-luxury-primary w-100 py-2" Text="Submit Appraisal" OnClick="btnSubmitReview_Click" />
                        </asp:PlaceHolder>

                        <asp:PlaceHolder ID="phLoginToReview" runat="server" Visible="false">
                            <p class="text-muted small mb-3">Please sign in to your Kriya ID client account to leave a verified appraisal.</p>
                            <a href='<%= ResolveUrl("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl)) %>' class="btn btn-luxury-outline w-100 py-2">
                                Sign In to Review
                            </a>
                        </asp:PlaceHolder>
                    </div>
                </div>
            </div>
        </div>

        <!-- Related Products Section -->
        <div class="mt-5 pt-5 border-top" style="border-color: var(--color-beige) !important;">
            <h3 class="brand-font mb-4">Complementary Atelier Pieces</h3>
            <div class="row g-4">
                <asp:Repeater ID="rptRelatedProducts" runat="server">
                    <ItemTemplate>
                        <div class="col-lg-3 col-md-6 col-6">
                            <div class="product-card">
                                <div class="product-thumb-container">
                                    <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("Id")) %>'>
                                        <img src='<%# Eval("PrimaryImage") %>' alt='<%# Eval("Name") %>' class="product-thumb" />
                                    </a>
                                </div>
                                <div class="product-card-body">
                                    <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("Id")) %>' class="product-title text-decoration-none">
                                        <%# Eval("Name") %>
                                    </a>
                                    <div class="product-price-row">
                                        <span class="price-current">&#8377;<%# string.Format("{0:N0}", (Convert.ToDecimal(Eval("Price")) * (100 - Convert.ToInt32(Eval("DiscountPercent")))) / 100) %></span>
                                    </div>
                                    <div class="mt-3">
                                        <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("Id")) %>' class="btn btn-luxury-outline w-100 py-2 small">
                                            View Piece
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script type="text/javascript">
        function swapMainImage(src) {
            var main = document.getElementById('<%= imgMain.ClientID %>');
            if (main) {
                main.src = src;
            }
            // Update active thumbnail border
            var thumbs = document.querySelectorAll('.gallery-thumb');
            thumbs.forEach(function (t) {
                t.classList.remove('active');
                if (t.src === src) {
                    t.classList.add('active');
                }
            });
        }
    </script>
</asp:Content>
