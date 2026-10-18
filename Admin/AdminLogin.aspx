<%@ Page Title="Atelier Staff & Administrator Sign In" Language="C#" MasterPageFile="~/Plain.master" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="KriyaID.AdminLogin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .admin-login-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: radial-gradient(circle at center, #1C233B 0%, #0F1424 100%);
            padding: 2rem 1rem;
        }
        .admin-login-card {
            background-color: var(--color-deep-ocean);
            border: 1px solid rgba(196, 188, 176, 0.25);
            border-radius: var(--radius-lg);
            padding: 3rem 2.5rem;
            max-width: 460px;
            width: 100%;
            box-shadow: 0 16px 40px rgba(0, 0, 0, 0.5);
            color: var(--color-cream);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-login-wrapper">
        <div class="admin-login-card">
            <div class="text-center mb-4">
                <div class="splash-logo-mark mx-auto mb-3" style="background-color: rgba(238,232,223,0.1); border-color: var(--color-beige);">
                    <i class="bi bi-shield-lock text-warning"></i>
                </div>
                <h1 class="brand-font fs-3 text-white mb-1">Kriya ID Studio</h1>
                <span class="badge" style="background-color: var(--color-beige); color: var(--color-deep-ocean-dark); font-size: 0.75rem; letter-spacing: 0.1em;">
                    EXECUTIVE MANAGEMENT PORTAL
                </span>
            </div>

            <!-- Error Alert -->
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger py-2 small" role="alert">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </asp:Panel>

            <div class="mb-3">
                <label class="form-label small fw-semibold" style="color: var(--color-beige);">Administrator Email</label>
                <div class="input-group">
                    <span class="input-group-text border-0" style="background-color: rgba(255,255,255,0.08); color: var(--color-beige);"><i class="bi bi-envelope"></i></span>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" style="background-color: rgba(255,255,255,0.08); border-color: rgba(196,188,176,0.3); color: white;" placeholder="admin@kriyaid.com" TextMode="Email"></asp:TextBox>
                </div>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" Display="Dynamic" ForeColor="#FF8B8B" ErrorMessage="Admin email required." CssClass="small" />
            </div>

            <div class="mb-4">
                <label class="form-label small fw-semibold" style="color: var(--color-beige);">Master Security Password</label>
                <div class="input-group">
                    <span class="input-group-text border-0" style="background-color: rgba(255,255,255,0.08); color: var(--color-beige);"><i class="bi bi-key"></i></span>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" style="background-color: rgba(255,255,255,0.08); border-color: rgba(196,188,176,0.3); color: white;" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                </div>
                <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword" Display="Dynamic" ForeColor="#FF8B8B" ErrorMessage="Password required." CssClass="small" />
            </div>

            <asp:Button ID="btnAdminLogin" runat="server" CssClass="btn w-100 py-2 fw-semibold" style="background-color: var(--color-cream); color: var(--color-deep-ocean-dark);" Text="Access Atelier Console" OnClick="btnAdminLogin_Click" />

            <div class="mt-4 pt-3 text-center border-top" style="border-color: rgba(196,188,176,0.15) !important;">
                <a href='<%= ResolveUrl("~/Home.aspx") %>' class="small text-decoration-none" style="color: var(--color-beige);">
                    <i class="bi bi-arrow-left me-1"></i>Return to Client Storefront
                </a>
            </div>

            <div class="mt-3 p-2 rounded small text-center" style="background: rgba(0,0,0,0.25); border: 1px dashed rgba(196,188,176,0.3); font-size: 0.78rem;">
                <span class="text-white">Admin (kriyaid): <code>admin@kriyaid.com</code> / <code>Admin@123</code></span>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
