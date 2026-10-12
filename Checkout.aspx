<%@ Page Title="Secure Atelier Checkout" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="KriyaID.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .checkout-box {
            background-color: var(--color-white);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-md);
            padding: 1.75rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow-soft);
        }
        .checkout-header {
            font-family: var(--font-heading);
            font-size: 1.25rem;
            color: var(--color-deep-ocean);
            padding-bottom: 0.75rem;
            border-bottom: 1px solid var(--color-beige-light);
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .payment-option-card {
            border: 1.5px solid var(--color-beige);
            border-radius: var(--radius-sm);
            padding: 1rem;
            margin-bottom: 0.75rem;
            cursor: pointer;
            transition: var(--transition);
        }
        .payment-option-card:hover {
            border-color: var(--color-deep-ocean);
            background-color: var(--color-cream-subtle);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <h1 class="brand-font fs-2 mb-4">Complete Your Atelier Acquisition</h1>

        <!-- Error Alert -->
        <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger py-2 small" role="alert">
            <asp:Literal ID="litError" runat="server"></asp:Literal>
        </asp:Panel>

        <div class="row g-4">
            <!-- Left Column: Shipping Address & Payment Selection -->
            <div class="col-lg-7">
                <!-- Section 1: Shipping Address -->
                <div class="checkout-box">
                    <h3 class="checkout-header">
                        <i class="bi bi-geo-alt"></i> 1. Delivery & White-Glove Installation Address
                    </h3>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-luxury">Recipient Full Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtShippingName" runat="server" CssClass="form-control form-control-luxury" placeholder="Full Name"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtShippingName" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Recipient name is required." CssClass="small" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-luxury">Contact Phone <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtShippingPhone" runat="server" CssClass="form-control form-control-luxury" placeholder="+91 98765 43210"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtShippingPhone" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Phone number is required." CssClass="small" />
                        </div>
                        <div class="col-12">
                            <label class="form-label-luxury">Complete Street Address / Apartment / Villa <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtShippingAddress" runat="server" CssClass="form-control form-control-luxury" TextMode="MultiLine" Rows="2" placeholder="Suite, Street, Landmark"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtShippingAddress" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Address is required." CssClass="small" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-luxury">City <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtShippingCity" runat="server" CssClass="form-control form-control-luxury" placeholder="e.g. Ahmedabad"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtShippingCity" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="City is required." CssClass="small" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-luxury">Postal Pincode <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtShippingPincode" runat="server" CssClass="form-control form-control-luxury" placeholder="380015"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPincode" runat="server" ControlToValidate="txtShippingPincode" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Pincode is required." CssClass="small" />
                        </div>
                    </div>
                </div>

                <!-- Section 2: Payment Method -->
                <div class="checkout-box">
                    <h3 class="checkout-header">
                        <i class="bi bi-credit-card"></i> 2. Select Payment Method
                    </h3>

                    <div class="payment-options">
                        <div class="payment-option-card">
                            <div class="form-check">
                                <asp:RadioButton ID="rbCOD" runat="server" GroupName="PaymentMethod" Checked="true" CssClass="form-check-input" />
                                <label class="form-check-label fw-semibold" for='<%= rbCOD.ClientID %>'>
                                    <i class="bi bi-cash-stack text-success me-2"></i>Cash on Delivery (COD)
                                </label>
                                <small class="text-muted d-block mt-1 ps-4">Pay securely upon in-home white-glove inspection & delivery.</small>
                            </div>
                        </div>

                        <div class="payment-option-card">
                            <div class="form-check">
                                <asp:RadioButton ID="rbOnline" runat="server" GroupName="PaymentMethod" CssClass="form-check-input" />
                                <label class="form-check-label fw-semibold" for='<%= rbOnline.ClientID %>'>
                                    <i class="bi bi-shield-check text-primary me-2"></i>Online Payment (Demo Gateway)
                                </label>
                                <small class="text-muted d-block mt-1 ps-4">Simulates immediate successful verification for UPI, Net Banking, and Cards.</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Order Summary & Place Order Button -->
            <div class="col-lg-5">
                <div class="checkout-box">
                    <h3 class="checkout-header">
                        <i class="bi bi-receipt"></i> Order Summary
                    </h3>

                    <!-- Mini Cart Items List -->
                    <div class="mb-3 max-h-300 overflow-auto">
                        <asp:Repeater ID="rptSummaryItems" runat="server">
                            <ItemTemplate>
                                <div class="d-flex justify-content-between align-items-center py-2 border-bottom small" style="border-color: rgba(196,188,176,0.3) !important;">
                                    <div class="me-2">
                                        <strong style="color: var(--color-deep-ocean);"><%# Eval("ProductName") %></strong>
                                        <%# !string.IsNullOrEmpty(Eval("VariantValue").ToString()) ? "<span class='d-block text-muted small'>" + Eval("VariantValue") + "</span>" : "" %>
                                        <span class="text-muted">Qty: <%# Eval("Quantity") %> × &#8377;<%# string.Format("{0:N0}", Eval("CalculatedUnitPrice")) %></span>
                                    </div>
                                    <span class="fw-semibold">
                                        &#8377;<%# string.Format("{0:N0}", Convert.ToDecimal(Eval("CalculatedUnitPrice")) * Convert.ToInt32(Eval("Quantity"))) %>
                                    </span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <!-- Totals Breakdown -->
                    <div class="d-flex justify-content-between mb-2 small">
                        <span class="text-muted">Subtotal</span>
                        <span class="fw-semibold">&#8377;<asp:Literal ID="litSubTotal" runat="server">0</asp:Literal></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2 small">
                        <span class="text-muted">White-Glove Delivery</span>
                        <span class="fw-semibold"><asp:Literal ID="litShippingFee" runat="server">&#8377;0</asp:Literal></span>
                    </div>
                    <div class="d-flex justify-content-between mb-3 small">
                        <span class="text-muted">GST Included</span>
                        <span class="text-success fw-semibold">18% (Included)</span>
                    </div>

                    <hr style="border-color: var(--color-beige) !important;" />

                    <div class="d-flex justify-content-between align-items-baseline mb-4">
                        <span class="fs-5 fw-bold" style="color: var(--color-deep-ocean);">Amount Payable</span>
                        <span class="fs-3 fw-bold" style="color: var(--color-deep-ocean);">
                            &#8377;<asp:Literal ID="litGrandTotal" runat="server">0</asp:Literal>
                        </span>
                    </div>

                    <asp:Button ID="btnPlaceOrder" runat="server" CssClass="btn btn-luxury-primary w-100 py-3 fs-6" Text="Place Order & Confirm Acquisition" OnClick="btnPlaceOrder_Click" />

                    <div class="p-3 rounded mt-3 text-center small" style="background-color: var(--color-cream); border: 1px solid var(--color-beige);">
                        <i class="bi bi-patch-check-fill text-success me-1"></i>
                        Includes 10-Year Kriya ID Structural Guarantee & Insurance
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
