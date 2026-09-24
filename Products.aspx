<%@ Page Title="Curated Collections" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="KriyaID.Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .filter-card {
            background-color: var(--color-white);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-md);
            padding: 1.5rem;
            box-shadow: var(--shadow-soft);
        }
        .filter-title {
            font-family: var(--font-heading);
            font-size: 1.05rem;
            font-weight: 600;
            color: var(--color-deep-ocean);
            border-bottom: 1px solid var(--color-beige-light);
            padding-bottom: 0.65rem;
            margin-bottom: 1rem;
        }
        .datapager-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 3rem;
        }

        /* Reset the wrapper span generated automatically by ASP.NET DataPager */
        .datapager-container > span {
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 0.5rem !important;
            border: none !important;
            background: transparent !important;
            padding: 0 !important;
            border-radius: 0 !important;
            box-shadow: none !important;
            min-width: unset !important;
            height: auto !important;
        }

        /* Style individual pagination buttons (links and inner spans) */
        .datapager-container a,
        .datapager-container > span > a,
        .datapager-container > span > span {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 42px;
            height: 42px;
            padding: 0 0.9rem;
            border-radius: 8px;
            font-size: 0.88rem;
            font-weight: 500;
            text-decoration: none;
            border: 1px solid var(--color-beige);
            background-color: var(--color-white);
            color: var(--color-deep-ocean);
            transition: var(--transition);
            box-shadow: 0 1px 3px rgba(44, 54, 90, 0.04);
        }

        /* Hover effect on clickable pages */
        .datapager-container a:hover,
        .datapager-container > span > a:hover {
            background-color: var(--color-cream);
            border-color: var(--color-deep-ocean);
            color: var(--color-deep-ocean-dark);
            transform: translateY(-1px);
        }

        /* Active / Current Page */
        .datapager-container span.current-page,
        .datapager-container > span > span.current-page {
            background-color: var(--color-deep-ocean) !important;
            color: #ffffff !important;
            border-color: var(--color-deep-ocean) !important;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(44, 54, 90, 0.22);
            cursor: default;
        }

        /* Disabled Prev / Next button state */
        .datapager-container > span > span:not(.current-page) {
            color: var(--color-beige-dark);
            background-color: #faf9f6;
            border-color: var(--color-beige-light);
            cursor: not-allowed;
            opacity: 0.65;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb & Page Banner -->
    <section class="py-4" style="background-color: var(--color-cream); border-bottom: 1px solid var(--color-beige);">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1 small">
                    <li class="breadcrumb-item"><a href="Home.aspx" style="color: var(--color-deep-ocean);">Home</a></li>
                    <li class="breadcrumb-item active text-muted" aria-current="page">Collections</li>
                </ol>
            </nav>
            <h1 class="brand-font fs-2 mb-0">Atelier Furniture & Design Objects</h1>
        </div>
    </section>

    <!-- Main Content Grid with Sidebar Filters -->
    <div class="container py-5">
        <!-- Sub-Categories Quick Navigation (Top Horizontal Bar - "Savthi Pela") -->
        <div class="subcat-top-bar mb-4">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2 pb-2 border-bottom" style="border-color: var(--color-beige-light) !important;">
                <div class="d-flex align-items-center gap-2">
                    <span class="fw-bold small text-uppercase" style="letter-spacing: 0.08em; color: var(--color-deep-ocean);">
                        <i class="bi bi-grid-3x3-gap-fill me-1"></i> Sub-Categories
                    </span>
                    <span class="badge" style="background-color: var(--color-cream); color: var(--color-deep-ocean); border: 1px solid var(--color-beige); font-size: 0.72rem;">
                        <asp:Literal ID="litActiveCategoryName" runat="server">All Collections</asp:Literal>
                    </span>
                </div>
                <span class="text-muted small">
                    Select a sub-category to refine products
                </span>
            </div>
            <div class="d-flex flex-wrap gap-2 align-items-center pt-1">
                <asp:Repeater ID="rptTopSubCategories" runat="server" OnItemCommand="rptTopSubCategories_ItemCommand">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnSubCatPill" runat="server" 
                            CommandName="SelectSubCat" 
                            CommandArgument='<%# Eval("Id") %>' 
                            CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "subcat-pill active" : "subcat-pill" %>'
                            CausesValidation="false">
                            <%# Eval("Name") %>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <div class="row g-4">
            <!-- Filter Sidebar -->
            <div class="col-lg-3 col-md-4">
                <div class="filter-card mb-4">
                    <!-- Hidden Sub-Category Dropdown (Moved to top horizontal bar) -->
                    <asp:DropDownList ID="ddlSubCategory" runat="server" style="display:none;" AutoPostBack="true" OnSelectedIndexChanged="ddlSubCategory_SelectedIndexChanged">
                    </asp:DropDownList>

                    <!-- Search within results -->
                    <div class="mb-4">
                        <label class="form-label-luxury">Keyword Search</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtSearchKeyword" runat="server" CssClass="form-control form-control-luxury" placeholder="Search furniture..."></asp:TextBox>
                            <asp:LinkButton ID="btnApplySearch" runat="server" CssClass="btn btn-luxury-primary" OnClick="btnFilter_Click" CausesValidation="false">
                                <i class="bi bi-search"></i>
                            </asp:LinkButton>
                        </div>
                    </div>

                    <!-- Category Filter -->
                    <div class="mb-4">
                        <h6 class="filter-title">Category</h6>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select form-control-luxury" AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>

                    <!-- Price Range Filter -->
                    <div class="mb-4">
                        <h6 class="filter-title">Price Range (&#8377;)</h6>
                        <div class="row g-2 mb-2">
                            <div class="col-6">
                                <asp:TextBox ID="txtMinPrice" runat="server" CssClass="form-control form-control-luxury" placeholder="Min &#8377;" TextMode="Number"></asp:TextBox>
                            </div>
                            <div class="col-6">
                                <asp:TextBox ID="txtMaxPrice" runat="server" CssClass="form-control form-control-luxury" placeholder="Max &#8377;" TextMode="Number"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <!-- Minimum Rating Filter -->
                    <div class="mb-4">
                        <h6 class="filter-title">Customer Rating</h6>
                        <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-select form-control-luxury">
                            <asp:ListItem Value="0" Text="All Ratings"></asp:ListItem>
                            <asp:ListItem Value="4" Text="4★ & above"></asp:ListItem>
                            <asp:ListItem Value="3" Text="3★ & above"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-grid gap-2">
                        <asp:Button ID="btnApplyFilters" runat="server" CssClass="btn btn-luxury-primary py-2" Text="Apply Filters" OnClick="btnFilter_Click" CausesValidation="false" />
                        <asp:Button ID="btnResetFilters" runat="server" CssClass="btn btn-luxury-outline py-2" Text="Reset Filters" OnClick="btnResetFilters_Click" CausesValidation="false" />
                    </div>
                </div>
            </div>

            <!-- Products Listing Main Area -->
            <div class="col-lg-9 col-md-8">
                <!-- Sorting & Count Bar -->
                <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 p-3 bg-white rounded border" style="border-color: var(--color-beige) !important;">
                    <div>
                        <span class="text-muted small">Showing <strong class="text-dark"><asp:Literal ID="litResultCount" runat="server">0</asp:Literal></strong> pieces</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <label class="form-label-luxury mb-0 small text-nowrap">Sort By:</label>
                        <asp:DropDownList ID="ddlSortBy" runat="server" CssClass="form-select form-control-luxury py-1 small" AutoPostBack="true" OnSelectedIndexChanged="ddlSortBy_SelectedIndexChanged" style="width: auto;">
                            <asp:ListItem Value="newest" Text="Newest Arrivals"></asp:ListItem>
                            <asp:ListItem Value="price_low" Text="Price: Low to High"></asp:ListItem>
                            <asp:ListItem Value="price_high" Text="Price: High to Low"></asp:ListItem>
                            <asp:ListItem Value="name_asc" Text="Name: A to Z"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <!-- Empty State Message -->
                <asp:Panel ID="pnlNoProducts" runat="server" Visible="false" CssClass="text-center py-5 bg-white rounded border" style="border-color: var(--color-beige) !important;">
                    <i class="bi bi-search fs-1 text-muted mb-3 d-block"></i>
                    <h4 class="brand-font">No matching furniture pieces found</h4>
                    <p class="text-muted small">Try refining your filter criteria or explore all collections.</p>
                    <asp:LinkButton ID="btnResetEmpty" runat="server" CssClass="btn btn-luxury-primary mt-2" OnClick="btnResetFilters_Click" CausesValidation="false">
                        Browse Full Catalog
                    </asp:LinkButton>
                </asp:Panel>

                <!-- Products Grid ListView with DataPager -->
                <asp:ListView ID="lvProducts" runat="server" OnPagePropertiesChanging="lvProducts_PagePropertiesChanging" OnItemCommand="lvProducts_ItemCommand">
                    <LayoutTemplate>
                        <div class="row g-4">
                            <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                        </div>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <div class="col-lg-4 col-md-6 col-6">
                            <div class="product-card">
                                <div class="product-thumb-container">
                                    <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("Id")) %>'>
                                        <img src='<%# Eval("PrimaryImage") %>' alt='<%# Eval("Name") %>' class="product-thumb" />
                                    </a>
                                    <%# Convert.ToInt32(Eval("DiscountPercent")) > 0 ? "<span class='product-discount-badge'>-" + Eval("DiscountPercent") + "%</span>" : "" %>
                                    
                                    <!-- Wishlist Heart Button -->
                                    <asp:LinkButton ID="btnWishlist" runat="server" CommandName="AddWishlist" CommandArgument='<%# Eval("Id") %>' CssClass="product-wish-btn" ToolTip="Save to Wishlist" CausesValidation="false">
                                        <i class="bi bi-heart"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="product-card-body">
                                    <span class="product-category-meta"><%# Eval("CategoryName") %> • <%# Eval("SubCategoryName") %></span>
                                    <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("Id")) %>' class="product-title text-decoration-none">
                                        <%# Eval("Name") %>
                                    </a>

                                    <div class="d-flex align-items-center gap-1 mb-2">
                                        <span class="badge" style="background-color: var(--color-cream); color: var(--color-deep-ocean); border: 1px solid var(--color-beige); font-size: 0.72rem;">
                                            <i class="bi bi-star-fill text-warning me-1"></i><%# string.Format("{0:0.0}", Eval("AvgRating")) %> (<%# Eval("ReviewCount") %>)
                                        </span>
                                        <%# Convert.ToInt32(Eval("Stock")) > 0 ? "<span class='stock-pill stock-in ms-auto'>In Stock</span>" : "<span class='stock-pill stock-out ms-auto'>Out of Stock</span>" %>
                                    </div>

                                    <div class="product-price-row">
                                        <span class="price-current">&#8377;<%# string.Format("{0:N0}", (Convert.ToDecimal(Eval("Price")) * (100 - Convert.ToInt32(Eval("DiscountPercent")))) / 100) %></span>
                                        <%# Convert.ToInt32(Eval("DiscountPercent")) > 0 ? "<span class='price-original'>&#8377;" + string.Format("{0:N0}", Eval("Price")) + "</span>" : "" %>
                                    </div>

                                    <div class="mt-3">
                                        <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("Id")) %>' class="btn btn-luxury-primary w-100 py-2 small">
                                            View Piece <i class="bi bi-arrow-right ms-1"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:ListView>

                <!-- DataPager for Pagination -->
                <div class="datapager-container">
                    <asp:DataPager ID="dpProducts" runat="server" PagedControlID="lvProducts" PageSize="9">
                        <Fields>
                            <asp:NextPreviousPagerField ButtonType="Link" ShowFirstPageButton="false" ShowPreviousPageButton="true" ShowNextPageButton="false" PreviousPageText="<i class='bi bi-chevron-left'></i> Prev" RenderDisabledButtonsAsLabels="true" />
                            <asp:NumericPagerField ButtonType="Link" CurrentPageLabelCssClass="current-page" NumericButtonCssClass="page-num" />
                            <asp:NextPreviousPagerField ButtonType="Link" ShowLastPageButton="false" ShowNextPageButton="true" ShowPreviousPageButton="false" NextPageText="Next <i class='bi bi-chevron-right'></i>" RenderDisabledButtonsAsLabels="true" />
                        </Fields>
                    </asp:DataPager>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
