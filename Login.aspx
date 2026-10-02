<%@ Page Title="Client Login" Language="C#" MasterPageFile="~/Plain.master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="KriyaID.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-wrapper">
        <div class="auth-card">
            <!-- Brand Header -->
            <div class="auth-header">
                <a href="Default.aspx" class="brand-logo text-decoration-none">
                    <span>Kriya ID</span>
                    <span class="brand-badge">STUDIO</span>
                </a>
                <h2 class="mt-3 mb-1 fs-3">Welcome Back</h2>
                <p class="text-muted small">Sign in to manage your interior projects and orders</p>
            </div>

            <!-- Error / Alert Message -->
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger py-2 small" role="alert">
                <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
            </asp:Panel>

            <div class="row g-3">
                <!-- Email Address -->
                <div class="col-12">
                    <label class="form-label-luxury">Email Address <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-luxury" placeholder="name@domain.com" TextMode="Email"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Email is required." CssClass="small" />
                </div>

                <!-- Password -->
                <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center">
                        <label class="form-label-luxury">Password <span class="text-danger">*</span></label>
                    </div>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control form-control-luxury" TextMode="Password" placeholder="Enter password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Password is required." CssClass="small" />
                </div>

                <!-- Submit Button -->
                <div class="col-12 mt-4">
                    <asp:Button ID="btnLogin" runat="server" CssClass="btn btn-luxury-primary w-100 py-2 fs-6" Text="Sign In to Studio" OnClick="btnLogin_Click" />
                </div>

                <!-- Links -->
                <div class="col-12 text-center mt-3">
                    <span class="text-muted small">Don't have an account? </span>
                    <a href="Register.aspx" class="fw-semibold small" style="color: var(--color-deep-ocean);">Register Now</a>
                </div>

                <div class="col-12 text-center border-top pt-3 mt-3" style="border-color: var(--color-beige-light) !important;">
                    <a href="Admin/AdminLogin.aspx" class="text-muted small text-decoration-none">
                        <i class="bi bi-shield-lock me-1"></i>Staff & Administrator Access
                    </a>
                </div>

                <!-- Demo Credentials Helper -->
                <div class="col-12 mt-2">
                    <div class="p-2 rounded small" style="background-color: var(--color-cream); border: 1px dashed var(--color-beige); font-size: 0.78rem;">
                        <strong>Demo Accounts:</strong><br />
                        <span class="d-inline-block me-3"><i class="bi bi-person me-1"></i>Tanvee: <code>tanvee@kriyaid.com</code> / <code>User@123</code></span><br />
                        <span class="d-inline-block me-3"><i class="bi bi-person me-1"></i>Diya: <code>diyagadhiya06@gmail.com</code></span><br />
                        <span><i class="bi bi-shield me-1"></i>Admin (kriyaid): <code>admin@kriyaid.com</code> / <code>Admin@123</code></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
