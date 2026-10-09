<%@ Page Title="Shopping Bag" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="KriyaID.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .cart-item-img {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: var(--radius-sm);
            border: 1px solid var(--color-beige);
        }
        .summary-card {
            background-color: var(--color-white);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-md);
            padding: 1.75rem;
            box-shadow: var(--shadow-soft);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <h1 class="brand-font fs-2 mb-4">Your Atelier Shopping Bag</h1>

        <!-- Error / Info Alert -->
        <asp:Panel ID="pnlCartAlert" runat="server" Visible="false" CssClass="alert alert-info py-2 small" role="alert">
            <asp:Literal ID="litCartAlert" runat="server"></asp:Literal>
        </asp:Panel>

        <!-- Empty Cart Panel -->
        <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false" CssClass="text-center py-5 bg-white rounded border" style="border-color: var(--color-beige) !important;">
            <i class="bi bi-bag-x fs-1 text-muted mb-3 d-block"></i>
            <h3 class="brand-font">Your Shopping Bag is Currently Empty</h3>
            <p class="text-muted small">Explore our handcrafted furniture and architectural lighting to curate your space.</p>
            <a href='<%= ResolveUrl("~/Products.aspx") %>' class="btn btn-luxury-primary mt-3 px-4 py-2">
                Discover Collections <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </asp:Panel>

        <!-- Cart Items & Summary Layout -->
        <asp:Panel ID="pnlCartContent" runat="server">
            <div class="row g-4">
                <!-- Cart Items List (Repeater) -->
                <div class="col-lg-8">
                    <div class="bg-white rounded border overflow-hidden" style="border-color: var(--color-beige) !important;">
                        <asp:Repeater ID="rptCartItems" runat="server" OnItemCommand="rptCartItems_ItemCommand">
                            <HeaderTemplate>
                                <div class="d-none d-md-flex p-3 fw-semibold small border-bottom" style="background-color: var(--color-cream); color: var(--color-deep-ocean); border-color: var(--color-beige) !important;">
                                    <div class="col-6">Item Description</div>
                                    <div class="col-2 text-center">Unit Price</div>
                                    <div class="col-2 text-center">Quantity</div>
                                    <div class="col-2 text-end">Subtotal</div>
                                </div>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <div class="p-3 border-bottom d-flex flex-wrap align-items-center gap-3" style="border-color: rgba(196, 188, 176, 0.4) !important;">
                                    <!-- Image & Name -->
                                    <div class="col-12 col-md-5 d-flex align-items-center gap-3">
                                        <img src='<%# Eval("PrimaryImage") %>' alt='<%# Eval("ProductName") %>' class="cart-item-img flex-shrink-0" />
                                        <div>
                                            <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("ProductId")) %>' class="fw-semibold text-decoration-none d-block" style="color: var(--color-deep-ocean);">
                                                <%# Eval("ProductName") %>
                                            </a>
                                            <%# !string.IsNullOrEmpty(Eval("VariantValue").ToString()) ? "<span class='badge bg-light text-secondary border small mt-1'>" + Eval("VariantName") + ": " + Eval("VariantValue") + "</span>" : "" %>
                                            <div class="mt-2">
                                                <asp:LinkButton ID="btnRemove" runat="server" CommandName="RemoveItem" CommandArgument='<%# Eval("CartItemId") %>' CssClass="text-danger small text-decoration-none" CausesValidation="false">
                                                    <i class="bi bi-trash me-1"></i>Remove
                                                </asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Unit Price -->
                                    <div class="col-5 col-md-2 text-md-center">
                                        <span class="d-md-none text-muted small">Price: </span>
                                        <strong>&#8377;<%# string.Format("{0:N0}", Eval("CalculatedUnitPrice")) %></strong>
                                    </div>

                                    <!-- Quantity Adjustment -->
                                    <div class="col-6 col-md-2 text-md-center">
                                        <div class="d-inline-flex align-items-center gap-1">
                                            <asp:TextBox ID="txtQty" runat="server" Text='<%# Eval("Quantity") %>' TextMode="Number" CssClass="form-control form-control-luxury text-center p-1" style="width: 55px; height: 35px;"></asp:TextBox>
                                            <asp:LinkButton ID="btnUpdateQty" runat="server" CommandName="UpdateQty" CommandArgument='<%# Eval("CartItemId") %>' CssClass="btn btn-sm btn-luxury-outline py-1 px-2" ToolTip="Update Quantity" CausesValidation="false">
                                                <i class="bi bi-arrow-repeat"></i>
                                            </asp:LinkButton>
                                        </div>
                                    </div>

                                    <!-- Item Total -->
                                    <div class="col-12 col-md-2 text-md-end text-end ms-auto">
                                        <span class="d-md-none text-muted small">Total: </span>
                                        <span class="fs-6 fw-bold" style="color: var(--color-deep-ocean);">
                                            &#8377;<%# string.Format("{0:N0}", Convert.ToDecimal(Eval("CalculatedUnitPrice")) * Convert.ToInt32(Eval("Quantity"))) %>
                                        </span>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <a href='<%= ResolveUrl("~/Products.aspx") %>' class="btn btn-luxury-outline small">
                            <i class="bi bi-arrow-left me-1"></i>Continue Exploring
                        </a>
                        <asp:LinkButton ID="btnClearCart" runat="server" CssClass="btn text-danger small" OnClick="btnClearCart_Click" CausesValidation="false" OnClientClick="return confirmAction('Empty your entire cart?');">
                            <i class="bi bi-trash3 me-1"></i>Clear Bag
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Right Column: Price Summary -->
                <div class="col-lg-4">
                    <div class="summary-card">
                        <h4 class="brand-font mb-3">Order Summary</h4>

                        <!-- Free Shipping Threshold Meter -->
                        <div class="p-3 rounded mb-3" style="background-color: var(--color-cream); border: 1px solid var(--color-beige);">
                            <div class="d-flex justify-content-between small fw-semibold mb-1" style="color: var(--color-deep-ocean);">
                                <span>White-Glove Delivery</span>
                                <span><asp:Literal ID="litShippingNotice" runat="server"></asp:Literal></span>
                            </div>
                            <div class="progress" style="height: 6px; background-color: var(--color-beige-light);">
                                <div class="progress-bar" role="progressbar" style='width: <%= ShippingProgressPercent %>%; background-color: var(--color-deep-ocean);'></div>
                            </div>
                        </div>

                        <!-- Price Breakdown -->
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Bag Subtotal</span>
                            <span class="fw-semibold">&#8377;<asp:Literal ID="litSubTotal" runat="server">0</asp:Literal></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Estimated Delivery & Placement</span>
                            <span class="fw-semibold"><asp:Literal ID="litShippingFee" runat="server">&#8377;0</asp:Literal></span>
                        </div>
                        <div class="d-flex justify-content-between mb-3">
                            <span class="text-muted">GST & Luxury Taxes</span>
                            <span class="fw-semibold text-success">Included</span>
                        </div>

                        <hr style="border-color: var(--color-beige) !important;" />

                        <div class="d-flex justify-content-between align-items-baseline mb-4">
                            <span class="fs-5 fw-bold" style="color: var(--color-deep-ocean);">Grand Total</span>
                            <span class="fs-4 fw-bold" style="color: var(--color-deep-ocean);">
                                &#8377;<asp:Literal ID="litGrandTotal" runat="server">0</asp:Literal>
                            </span>
                        </div>

                        <a href='<%= ResolveUrl("~/Checkout.aspx") %>' class="btn btn-luxury-primary w-100 py-3 fs-6">
                            Proceed to Checkout <i class="bi bi-shield-lock ms-2"></i>
                        </a>

                        <div class="text-center mt-3 text-muted small">
                            <i class="bi bi-lock me-1"></i>Bank-grade 256-bit encrypted checkout
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
