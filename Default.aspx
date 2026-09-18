<%@ Page Title="Welcome" Language="C#" MasterPageFile="~/Plain.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="KriyaID.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Immediate redirect to Home.aspx -->
    <meta http-equiv="refresh" content="0;url=Home.aspx" />
    <style>
        .splash-sub {
            letter-spacing: 0.25em;
            text-transform: uppercase;
            font-size: 0.78rem;
            color: var(--color-beige-dark);
            font-weight: 600;
        }
        .splash-quote {
            font-family: var(--font-heading);
            font-style: italic;
            color: var(--color-deep-ocean-light);
            font-size: 1.15rem;
            margin-top: 1rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="splash-container">
        <div class="splash-card">
            <!-- Animated Brand Logo Mark -->
            <div class="splash-logo-mark">
                <i class="bi bi-gem"></i>
            </div>

            <!-- Brand Name & Luxury Subtitle -->
            <h1 class="brand-font mb-1" style="font-size: 2.8rem; font-weight: 700; color: var(--color-deep-ocean);">
                Kriya ID
            </h1>
            <div class="splash-sub">
                Interior Architecture & Atelier
            </div>

            <p class="splash-quote">
                "Curating spaces of timeless harmony and bespoke living."
            </p>

            <!-- 3 Second Loading Bar Animation -->
            <div class="splash-progress-bar">
                <div class="splash-progress-fill"></div>
            </div>
            <small class="text-muted" style="font-size: 0.75rem;">Entering design studio in 3 seconds...</small>

            <div class="mt-4 pt-2">
                <a href="Register.aspx" class="text-decoration-none" style="font-size: 0.85rem; color: var(--color-deep-ocean); font-weight: 500;">
                    Click here if not redirected automatically <i class="bi bi-arrow-right"></i>
                </a>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script type="text/javascript">
        window.location.href = "Home.aspx";
    </script>
</asp:Content>
