<%@ Page Title="Luxury Interior Design & Furniture Atelier" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="KriyaID.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .hero-banner-item {
            height: 520px;
            position: relative;
            background-size: cover;
            background-position: center;
        }
        .hero-banner-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, rgba(28, 32, 29, 0.78) 0%, rgba(38, 42, 39, 0.45) 55%, rgba(38, 42, 39, 0.12) 100%);
            display: flex;
            align-items: center;
        }
        .hero-content {
            max-width: 620px;
            color: #FFFFFF;
        }
        .hero-subtitle {
            font-size: 0.82rem;
            letter-spacing: 0.22em;
            text-transform: uppercase;
            color: #E8E4DA;
            font-weight: 500;
            margin-bottom: 0.8rem;
        }
        .hero-title {
            font-size: 3.2rem;
            line-height: 1.15;
            color: #FFFFFF;
            margin-bottom: 1.25rem;
        }
        .btn-hero-pill-primary {
            background-color: #FFFFFF;
            color: #282C29;
            font-weight: 600;
            font-size: 0.92rem;
            padding: 0.75rem 2rem;
            border-radius: 9999px;
            border: none;
            box-shadow: 0 8px 24px rgba(0,0,0,0.18);
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }
        .btn-hero-pill-primary:hover {
            background-color: #F4F2EC;
            color: #A55B3E;
            transform: translateY(-2px);
            box-shadow: 0 12px 28px rgba(0,0,0,0.22);
        }
        .btn-hero-pill-secondary {
            background-color: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(10px);
            color: #FFFFFF;
            font-weight: 500;
            font-size: 0.92rem;
            padding: 0.75rem 1.8rem;
            border-radius: 9999px;
            border: 1.5px solid rgba(255, 255, 255, 0.6);
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }
        .btn-hero-pill-secondary:hover {
            background-color: rgba(255, 255, 255, 0.25);
            color: #FFFFFF;
            border-color: #FFFFFF;
            transform: translateY(-2px);
        }
        .feature-box {
            background-color: var(--color-white);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-md);
            padding: 1.75rem 1.25rem;
            text-align: center;
            transition: var(--transition);
        }
        .feature-box:hover {
            box-shadow: var(--shadow-elevated);
            transform: translateY(-4px);
        }
        .feature-icon {
            width: 52px;
            height: 52px;
            background-color: var(--color-cream);
            color: var(--color-deep-ocean);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        .consultation-cta-card {
            background: linear-gradient(135deg, var(--color-deep-ocean-dark) 0%, var(--color-deep-ocean) 100%);
            border-radius: var(--radius-lg);
            padding: 3.5rem 2.5rem;
            color: var(--color-cream);
            position: relative;
            overflow: hidden;
            border: 1px solid var(--color-beige-dark);
        }
        /* Luxury Welcome Pop-up Modal (3-5 Seconds) */
        .luxury-popup-content {
            background: rgba(255, 255, 255, 0.96);
            backdrop-filter: blur(16px);
            border: 1.5px solid var(--color-beige);
            border-radius: var(--radius-lg);
            box-shadow: 0 20px 60px rgba(44, 54, 90, 0.28);
            position: relative;
            overflow: hidden;
        }
        .luxury-modal-close {
            position: absolute;
            top: 18px;
            right: 18px;
            z-index: 10;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Hero Carousel Loaded from Banners Table -->
    <div id="heroCarousel" class="carousel slide carousel-fade" data-bs-ride="carousel">
        <div class="carousel-inner">
            <asp:Repeater ID="rptBanners" runat="server">
                <ItemTemplate>
                    <div class='<%# Container.ItemIndex == 0 ? "carousel-item active" : "carousel-item" %>'>
                        <div class="hero-banner-item" style='background-image: url("<%# Eval("ImageUrl") %>");'>
                            <div class="hero-banner-overlay">
                                <div class="container">
                                    <div class="hero-content">
                                        <div class="hero-subtitle">
                                            <i class="bi bi-gem me-1"></i> Bespoke Architectural Interiors
                                        </div>
                                        <h1 class="hero-title brand-font">
                                            <%# Eval("Title") %>
                                        </h1>
                                        <p class="fs-6 mb-4" style="color: var(--color-beige); line-height: 1.6;">
                                            <%# Eval("Subtitle") %>
                                        </p>
                                        <div class="d-flex flex-wrap gap-3">
                                            <a href='<%# ResolveUrl(Eval("LinkUrl").ToString()) %>' class="btn-hero-pill-primary">
                                                Explore Collection <i class="bi bi-arrow-right ms-1"></i>
                                            </a>
                                            <a href='<%= ResolveUrl("~/BookDesigner.aspx") %>' class="btn-hero-pill-secondary">
                                                Book Consultation
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
        </button>
    </div>

    <!-- Atelier Pillars / Trust Badges -->
    <section class="py-5">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-3 col-6">
                    <div class="feature-box">
                        <div class="feature-icon"><i class="bi bi-compass"></i></div>
                        <h6 class="fw-semibold mb-1">Architectural Precision</h6>
                        <small class="text-muted">Proportioned by master interior designers</small>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="feature-box">
                        <div class="feature-icon"><i class="bi bi-tree"></i></div>
                        <h6 class="fw-semibold mb-1">Artisan Hardwoods</h6>
                        <small class="text-muted">Sustainable Burmese Teak & White Oak</small>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="feature-box">
                        <div class="feature-icon"><i class="bi bi-shield-check"></i></div>
                        <h6 class="fw-semibold mb-1">10-Year Craft Warranty</h6>
                        <small class="text-muted">Guaranteed durability and heirloom quality</small>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="feature-box">
                        <div class="feature-icon"><i class="bi bi-truck"></i></div>
                        <h6 class="fw-semibold mb-1">White-Glove Delivery</h6>
                        <small class="text-muted">Professional in-home assembly included</small>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Categories Section -->
    <section class="py-4" style="background-color: var(--color-cream);">
        <div class="container">
            <div class="text-center mb-5">
                <span class="text-uppercase fw-semibold" style="letter-spacing: 0.2em; font-size: 0.8rem; color: var(--color-beige-dark);">Curated Sanctuaries</span>
                <h2 class="display-6 brand-font mt-1">Explore by Living Space</h2>
                <div style="width: 60px; height: 2px; background-color: var(--color-deep-ocean); margin: 0.8rem auto;"></div>
            </div>

            <div class="row g-4">
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <div class="col-lg-4 col-md-6">
                            <a href='<%# ResolveUrl("~/Products.aspx?cat=" + Eval("Id")) %>' class="category-card text-decoration-none">
                                <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Name") %>' />
                                <div class="category-card-overlay">
                                    <h3 class="category-card-title"><%# Eval("Name") %></h3>
                                    <p class="category-card-desc mb-2"><%# Eval("Description") %></p>
                                    <span class="fw-semibold small" style="color: var(--color-beige);"><i class="bi bi-arrow-right-circle me-1"></i>Discover Collection</span>
                                </div>
                            </a>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- New Arrivals Section -->
    <section class="py-5">
        <div class="container">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <span class="text-uppercase fw-semibold" style="letter-spacing: 0.2em; font-size: 0.8rem; color: var(--color-beige-dark);">Autumn / Winter 2026</span>
                    <h2 class="brand-font mb-0">New Arrivals</h2>
                </div>
                <a href='<%= ResolveUrl("~/Products.aspx?sort=newest") %>' class="btn btn-luxury-outline py-2 px-3 small">
                    View All <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>

            <div class="row g-4">
                <asp:Repeater ID="rptNewArrivals" runat="server">
                    <ItemTemplate>
                        <div class="col-lg-3 col-md-6 col-6">
                            <div class="product-card">
                                <div class="product-thumb-container">
                                    <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("Id")) %>'>
                                        <img src='<%# Eval("PrimaryImage") %>' alt='<%# Eval("Name") %>' class="product-thumb" />
                                    </a>
                                    <%# Convert.ToInt32(Eval("DiscountPercent")) > 0 ? "<span class='product-discount-badge'>-" + Eval("DiscountPercent") + "%</span>" : "" %>
                                </div>
                                <div class="product-card-body">
                                    <span class="product-category-meta"><%# Eval("CategoryName") %></span>
                                    <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("Id")) %>' class="product-title text-decoration-none">
                                        <%# Eval("Name") %>
                                    </a>
                                    <div class="product-price-row">
                                        <span class="price-current">&#8377;<%# string.Format("{0:N0}", (Convert.ToDecimal(Eval("Price")) * (100 - Convert.ToInt32(Eval("DiscountPercent")))) / 100) %></span>
                                        <%# Convert.ToInt32(Eval("DiscountPercent")) > 0 ? "<span class='price-original'>&#8377;" + string.Format("{0:N0}", Eval("Price")) + "</span>" : "" %>
                                    </div>
                                    <div class="mt-3">
                                        <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("Id")) %>' class="btn btn-luxury-primary w-100 py-2 small">
                                            View Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- Bespoke Interior Design Consultation CTA Section -->
    <section class="py-5" style="background-color: var(--color-cream-light);">
        <div class="container">
            <div class="consultation-cta-card">
                <div class="row align-items-center g-4">
                    <div class="col-lg-8">
                        <span class="text-uppercase fw-semibold" style="letter-spacing: 0.2em; font-size: 0.8rem; color: var(--color-beige);">Custom Interior Architecture</span>
                        <h2 class="display-6 brand-font mt-2 mb-3" style="color: var(--color-cream);">
                            Designing Your Sanctuary from Blueprint to Reality
                        </h2>
                        <p class="mb-0" style="color: var(--color-beige-light); font-size: 1rem; line-height: 1.7; max-width: 650px;">
                            Collaborate directly with Kriya ID's principal interior architects. 
                            From full home spatial planning, custom cabinetry, material selection, 
                            to turnkey interior styling tailored to your lifestyle.
                        </p>
                    </div>
                    <div class="col-lg-4 text-lg-end">
                        <a href='<%= ResolveUrl("~/BookDesigner.aspx") %>' class="btn btn-luxury-beige px-4 py-3 fs-6">
                            <i class="bi bi-calendar-event me-2"></i>Schedule Consultation
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Best Sellers / Featured Section -->
    <section class="py-5">
        <div class="container">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <span class="text-uppercase fw-semibold" style="letter-spacing: 0.2em; font-size: 0.8rem; color: var(--color-beige-dark);">Curated Signature Pieces</span>
                    <h2 class="brand-font mb-0">Signature Bestsellers</h2>
                </div>
                <a href='<%= ResolveUrl("~/Products.aspx") %>' class="btn btn-luxury-outline py-2 px-3 small">
                    Explore All <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>

            <div class="row g-4">
                <asp:Repeater ID="rptBestSellers" runat="server">
                    <ItemTemplate>
                        <div class="col-lg-3 col-md-6 col-6">
                            <div class="product-card">
                                <div class="product-thumb-container">
                                    <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("Id")) %>'>
                                        <img src='<%# Eval("PrimaryImage") %>' alt='<%# Eval("Name") %>' class="product-thumb" />
                                    </a>
                                    <%# Convert.ToInt32(Eval("DiscountPercent")) > 0 ? "<span class='product-discount-badge'>-" + Eval("DiscountPercent") + "%</span>" : "" %>
                                </div>
                                <div class="product-card-body">
                                    <span class="product-category-meta"><%# Eval("CategoryName") %></span>
                                    <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("Id")) %>' class="product-title text-decoration-none">
                                        <%# Eval("Name") %>
                                    </a>
                                    <div class="product-price-row">
                                        <span class="price-current">&#8377;<%# string.Format("{0:N0}", (Convert.ToDecimal(Eval("Price")) * (100 - Convert.ToInt32(Eval("DiscountPercent")))) / 100) %></span>
                                        <%# Convert.ToInt32(Eval("DiscountPercent")) > 0 ? "<span class='price-original'>&#8377;" + string.Format("{0:N0}", Eval("Price")) + "</span>" : "" %>
                                    </div>
                                    <div class="mt-3">
                                        <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("Id")) %>' class="btn btn-luxury-primary w-100 py-2 small">
                                            View Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- Luxury Welcome Pop-up Modal (Opens 5 Seconds After Page Load) -->
    <div class="modal fade" id="kriyaWelcomeModal" tabindex="-1" aria-labelledby="welcomeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content luxury-popup-content">
                <button type="button" class="btn-close luxury-modal-close" data-bs-dismiss="modal" aria-label="Close"></button>
                <div class="modal-body text-center p-4 p-md-5">
                    <!-- Brand Icon -->
                    <div class="splash-logo-mark mx-auto mb-3" style="width: 72px; height: 72px; font-size: 2rem;">
                        <i class="bi bi-gem"></i>
                    </div>

                    <!-- Brand Header & Slogan -->
                    <span class="text-uppercase fw-semibold" style="letter-spacing: 0.25em; font-size: 0.72rem; color: var(--color-beige-dark);">Bespoke Interior Atelier</span>
                    <h2 class="brand-font fs-2 mt-1 mb-2" style="color: var(--color-deep-ocean);">Kriya ID Design Studio</h2>
                    <p class="fst-italic small mb-3" style="color: var(--color-deep-ocean-light); font-size: 0.92rem;">
                        "Curating spaces of timeless harmony, bespoke luxury and living art."
                    </p>

                    <!-- Exclusive Welcome Offer -->
                    <div class="p-3 rounded mb-4" style="background-color: var(--color-cream); border: 1px solid var(--color-beige);">
                        <div class="small fw-semibold" style="color: var(--color-deep-ocean);">
                            <i class="bi bi-stars text-warning me-1"></i> Complimentary 3D Interior Consultation &amp; Free White-Glove Installation
                        </div>
                    </div>

                    <!-- Quick Navigation Actions -->
                    <div class="d-flex justify-content-center">
                        <button type="button" class="btn btn-luxury-primary px-4 py-2 small" data-bs-dismiss="modal">
                            Explore Collections <i class="bi bi-arrow-right ms-1"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script type="text/javascript">
        // Automatic popup disabled so user can view and interact with the header immediately
        // Modal can still be triggered if needed via data-bs-toggle="modal" data-bs-target="#kriyaWelcomeModal"
    </script>
</asp:Content>
