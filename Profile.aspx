<%@ Page Title="Client Profile" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="KriyaID.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .profile-card {
            background-color: var(--color-white);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-md);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-soft);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <h1 class="brand-font fs-2 mb-4">My Client Profile & Atelier Settings</h1>

        <div class="row g-4">
            <!-- Left Column: Personal & Delivery Details -->
            <div class="col-lg-7">
                <div class="profile-card">
                    <h3 class="brand-font fs-4 mb-3" style="color: var(--color-deep-ocean);">
                        <i class="bi bi-person-lines-fill me-2"></i>Personal & Shipping Information
                    </h3>

                    <asp:Panel ID="pnlProfileMsg" runat="server" Visible="false" CssClass="alert alert-success py-2 small" role="alert">
                        <asp:Literal ID="litProfileMsg" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label-luxury">Full Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control form-control-luxury"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtFullName" ValidationGroup="ProfileGroup" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Full name is required." CssClass="small" />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-luxury">Email Address (Registered)</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-luxury bg-light" ReadOnly="true"></asp:TextBox>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-luxury">Contact Phone <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control form-control-luxury"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" ValidationGroup="ProfileGroup" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Phone is required." CssClass="small" />
                        </div>

                        <div class="col-12">
                            <label class="form-label-luxury">Default Delivery Address</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control form-control-luxury" TextMode="MultiLine" Rows="2"></asp:TextBox>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-luxury">City</label>
                            <asp:TextBox ID="txtCity" runat="server" CssClass="form-control form-control-luxury"></asp:TextBox>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-luxury">Postal Pincode</label>
                            <asp:TextBox ID="txtPincode" runat="server" CssClass="form-control form-control-luxury"></asp:TextBox>
                        </div>

                        <div class="col-12 mt-4">
                            <asp:Button ID="btnSaveProfile" runat="server" CssClass="btn btn-luxury-primary px-4 py-2" Text="Save Profile Changes" ValidationGroup="ProfileGroup" OnClick="btnSaveProfile_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Change Password -->
            <div class="col-lg-5">
                <div class="profile-card">
                    <h3 class="brand-font fs-4 mb-3" style="color: var(--color-deep-ocean);">
                        <i class="bi bi-shield-lock me-2"></i>Security & Password
                    </h3>

                    <asp:Panel ID="pnlPassMsg" runat="server" Visible="false" CssClass="alert alert-info py-2 small" role="alert">
                        <asp:Literal ID="litPassMsg" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label-luxury">Current Password <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control form-control-luxury" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvCurrentPass" runat="server" ControlToValidate="txtCurrentPassword" ValidationGroup="PassGroup" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Current password is required." CssClass="small" />
                        </div>

                        <div class="col-12">
                            <label class="form-label-luxury">New Password <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control form-control-luxury" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvNewPass" runat="server" ControlToValidate="txtNewPassword" ValidationGroup="PassGroup" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="New password is required." CssClass="small" />
                        </div>

                        <div class="col-12">
                            <label class="form-label-luxury">Confirm New Password <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtConfirmNewPassword" runat="server" CssClass="form-control form-control-luxury" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvConfNewPass" runat="server" ControlToValidate="txtConfirmNewPassword" ValidationGroup="PassGroup" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Confirm password is required." CssClass="small" />
                            <asp:CompareValidator ID="cvNewPass" runat="server" ControlToValidate="txtConfirmNewPassword" ControlToCompare="txtNewPassword" ValidationGroup="PassGroup" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Passwords do not match." CssClass="small" />
                        </div>

                        <div class="col-12 mt-4">
                            <asp:Button ID="btnChangePassword" runat="server" CssClass="btn btn-luxury-outline w-100 py-2" Text="Update Password" ValidationGroup="PassGroup" OnClick="btnChangePassword_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
