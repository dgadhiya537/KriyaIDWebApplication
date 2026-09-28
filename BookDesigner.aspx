<%@ Page Title="Book an Interior Designer" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="BookDesigner.aspx.cs" Inherits="KriyaID.BookDesigner" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .consultation-form-card {
            background-color: var(--color-white);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-lg);
            padding: 2.5rem;
            box-shadow: var(--shadow-elevated);
        }
        .designer-perk-box {
            background-color: var(--color-cream);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-md);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header Banner -->
    <section class="py-5" style="background: linear-gradient(135deg, var(--color-deep-ocean-dark) 0%, var(--color-deep-ocean) 100%); color: var(--color-cream);">
        <div class="container text-center">
            <span class="text-uppercase fw-semibold" style="letter-spacing: 0.25em; font-size: 0.8rem; color: var(--color-beige);">Bespoke Interior Architecture</span>
            <h1 class="display-5 brand-font mt-2 mb-3" style="color: var(--color-cream);">Book a Private Design Consultation</h1>
            <p class="mx-auto" style="max-width: 650px; color: var(--color-beige-light); line-height: 1.7;">
                Collaborate 1-on-1 with Kriya ID's principal architects. We transform architectural drawings into lived luxury, custom cabinetry, curated palettes, and tailored spaces.
            </p>
        </div>
    </section>

    <div class="container py-5">
        <div class="row g-5">
            <!-- Left Column: Consultation Perks -->
            <div class="col-lg-5">
                <h3 class="brand-font fs-3 mb-4">What to Expect During Your Session</h3>

                <div class="designer-perk-box">
                    <h6 class="fw-bold mb-1" style="color: var(--color-deep-ocean);">
                        <i class="bi bi-badge-3d-fill text-primary me-2"></i>Photorealistic 3D Spatial Visualization
                    </h6>
                    <small class="text-muted" style="line-height: 1.6; display: block;">
                        Inspect your living room, suite, or full villa in high-resolution raytraced 3D before committing to construction.
                    </small>
                </div>

                <div class="designer-perk-box">
                    <h6 class="fw-bold mb-1" style="color: var(--color-deep-ocean);">
                        <i class="bi bi-palette-fill text-warning me-2"></i>Physical Moodboards & Material Swatches
                    </h6>
                    <small class="text-muted" style="line-height: 1.6; display: block;">
                        Feel Italian travertine, Belgian linen, bouclé, and solid teak timbers curated directly for your lighting conditions.
                    </small>
                </div>

                <div class="designer-perk-box">
                    <h6 class="fw-bold mb-1" style="color: var(--color-deep-ocean);">
                        <i class="bi bi-clock-history text-success me-2"></i>Turnkey Project Delivery
                    </h6>
                    <small class="text-muted" style="line-height: 1.6; display: block;">
                        Guaranteed 45-day execution timeline with dedicated site supervisor and daily WhatsApp progress briefings.
                    </small>
                </div>
            </div>

            <!-- Right Column: Booking Form -->
            <div class="col-lg-7">
                <div class="consultation-form-card">
                    <h3 class="brand-font fs-3 mb-2">Schedule Your Atelier Consultation</h3>
                    <p class="text-muted small mb-4">Fill out your details below and our concierge architect will reach out within 24 hours.</p>

                    <!-- Success Alert -->
                    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success py-3" role="alert">
                        <i class="bi bi-check2-circle fs-4 me-2"></i>
                        <strong>Consultation Requested!</strong>
                        <p class="mb-0 small mt-1">Thank you. Your consultation booking has been lodged with our lead architect. We will call you on the provided number shortly.</p>
                    </asp:Panel>

                    <!-- Error Alert -->
                    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger py-2 small" role="alert">
                        <asp:Literal ID="litError" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-luxury">Full Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control form-control-luxury" placeholder="e.g. Sneha Sharma"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Name is required." CssClass="small" />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-luxury">Contact Phone <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control form-control-luxury" placeholder="+91 98765 43210"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Phone is required." CssClass="small" />
                        </div>

                        <div class="col-12">
                            <label class="form-label-luxury">Email Address <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-luxury" placeholder="name@domain.com" TextMode="Email"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Email is required." CssClass="small" />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-luxury">Room / Space Type <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlRoomType" runat="server" CssClass="form-select form-control-luxury">
                                <asp:ListItem Value="Living Room" Text="Living Room Redesign"></asp:ListItem>
                                <asp:ListItem Value="Master Bedroom" Text="Master Bedroom Sanctuary"></asp:ListItem>
                                <asp:ListItem Value="Modular Kitchen" Text="Modular Kitchen & Dining"></asp:ListItem>
                                <asp:ListItem Value="Full Home Interior" Text="Complete Home Interior (2BHK / 3BHK / 4BHK)"></asp:ListItem>
                                <asp:ListItem Value="Luxury Villa / Penthouse" Text="Luxury Villa / Penthouse Architecture"></asp:ListItem>
                                <asp:ListItem Value="Commercial Studio" Text="Boutique Office / Commercial Studio"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-luxury">Estimated Budget Range <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlBudget" runat="server" CssClass="form-select form-control-luxury">
                                <asp:ListItem Value="₹2 Lakh - ₹5 Lakh" Text="₹2 Lakh - ₹5 Lakh"></asp:ListItem>
                                <asp:ListItem Value="₹5 Lakh - ₹10 Lakh" Text="₹5 Lakh - ₹10 Lakh"></asp:ListItem>
                                <asp:ListItem Value="₹10 Lakh - ₹25 Lakh" Text="₹10 Lakh - ₹25 Lakh"></asp:ListItem>
                                <asp:ListItem Value="₹25 Lakh - ₹50 Lakh" Text="₹25 Lakh - ₹50 Lakh"></asp:ListItem>
                                <asp:ListItem Value="₹50 Lakh+" Text="₹50 Lakh+ (Ultra Luxury)"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="col-12">
                            <label class="form-label-luxury">Project Details & Aesthetic Vision</label>
                            <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control form-control-luxury" TextMode="MultiLine" Rows="4" placeholder="Describe your room dimensions, current flooring, preferred tones (e.g. Deep Ocean blue, warm beige, travertine), or timeline..."></asp:TextBox>
                        </div>

                        <div class="col-12 mt-4">
                            <asp:Button ID="btnSubmitConsultation" runat="server" CssClass="btn btn-luxury-primary w-100 py-3 fs-6" Text="Confirm Consultation Request" OnClick="btnSubmitConsultation_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
