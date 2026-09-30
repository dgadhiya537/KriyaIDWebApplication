<%@ Page Title="Create Account" Language="C#" MasterPageFile="~/Plain.master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="KriyaID.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-wrapper">
        <div class="auth-card">
            <!-- Header with Kriya ID Branding -->
            <div class="auth-header">
                <a href="Default.aspx" class="brand-logo text-decoration-none">
                    <span>Kriya ID</span>
                    <span class="brand-badge">STUDIO</span>
                </a>
                <h2 class="mt-3 mb-1 fs-3">Create Your Account</h2>
                <p class="text-muted small">Join our private clientele to curate bespoke living spaces</p>
            </div>

            <!-- Error / Alert Message -->
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger py-2 small" role="alert">
                <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
            </asp:Panel>

            <div class="row g-3">
                <!-- Full Name -->
                <div class="col-12">
                    <label class="form-label-luxury">Full Name <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control form-control-luxury" placeholder="e.g. Aarav Patel"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtFullName" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Full name is required." CssClass="small" />
                </div>

                <!-- Email Address -->
                <div class="col-md-6">
                    <label class="form-label-luxury">Email Address <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-luxury" placeholder="name@domain.com" TextMode="Email"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Email is required." CssClass="small" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Invalid email address." ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" CssClass="small" />
                </div>

                <!-- Phone -->
                <div class="col-md-6">
                    <label class="form-label-luxury">Contact Phone <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control form-control-luxury" placeholder="+91 98765 43210"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Phone number is required." CssClass="small" />
                </div>

                <!-- Password -->
                <div class="col-md-6">
                    <label class="form-label-luxury">Password <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control form-control-luxury" TextMode="Password" placeholder="Minimum 6 characters"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Password is required." CssClass="small" />
                </div>

                <!-- Confirm Password -->
                <div class="col-md-6">
                    <label class="form-label-luxury">Confirm Password <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control form-control-luxury" TextMode="Password" placeholder="Re-enter password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvConfirmPass" runat="server" ControlToValidate="txtConfirmPassword" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Please confirm password." CssClass="small" />
                    <asp:CompareValidator ID="cvPass" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Passwords do not match." CssClass="small" />
                </div>

                <!-- Delivery Address -->
                <div class="col-12">
                    <label class="form-label-luxury">Delivery Street Address</label>
                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control form-control-luxury" placeholder="Apartment / Villa, Street, Landmark" TextMode="MultiLine" Rows="2"></asp:TextBox>
                </div>

                <!-- City & Pincode -->
                <div class="col-md-6">
                    <label class="form-label-luxury">City</label>
                    <asp:TextBox ID="txtCity" runat="server" CssClass="form-control form-control-luxury" placeholder="e.g. Ahmedabad"></asp:TextBox>
                </div>
                <div class="col-md-6">
                    <label class="form-label-luxury">Pincode</label>
                    <asp:TextBox ID="txtPincode" runat="server" CssClass="form-control form-control-luxury" placeholder="380015"></asp:TextBox>
                </div>

                <!-- Submit Button -->
                <div class="col-12 mt-4">
                    <asp:Button ID="btnRegister" runat="server" CssClass="btn btn-luxury-primary w-100 py-2 fs-6" Text="Create My Account" OnClick="btnRegister_Click" />
                </div>

                <!-- Login Link -->
                <div class="col-12 text-center mt-3">
                    <span class="text-muted small">Already have an account? </span>
                    <a href="Login.aspx" class="fw-semibold small" style="color: var(--color-deep-ocean);">Login</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
