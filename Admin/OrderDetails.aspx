<%@ Page Title="Fulfillment Console" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="OrderDetails.aspx.cs" Inherits="KriyaID.AdminOrderDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .admin-card-section {
            background-color: var(--color-white);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-md);
            padding: 1.75rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow-soft);
        }
        .item-thumb-admin {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: var(--radius-sm);
            border: 1px solid var(--color-beige);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header with Back Link -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="brand-font fs-3 mb-0">
                Order Reference: <asp:Literal ID="litOrderNumber" runat="server"></asp:Literal>
            </h1>
            <small class="text-muted"><i class="bi bi-clock me-1"></i>Placed on <asp:Literal ID="litOrderDate" runat="server"></asp:Literal></small>
        </div>
        <a href='<%= ResolveUrl("~/Admin/Orders.aspx") %>' class="btn btn-luxury-outline py-2 px-3">
            <i class="bi bi-arrow-left me-1"></i>Back to All Orders
        </a>
    </div>

    <!-- Status Change Alert -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success py-2 small" role="alert">
        <asp:Literal ID="litAlert" runat="server"></asp:Literal>
    </asp:Panel>

    <!-- Fulfill Status Management Panel -->
    <div class="admin-card-section mb-4" style="border-left: 4px solid var(--color-deep-ocean);">
        <h5 class="brand-font fs-5 mb-3" style="color: var(--color-deep-ocean);">
            <i class="bi bi-toggles me-1"></i>Fulfillment & Lifecycle Actions
        </h5>

        <div class="row align-items-center g-3">
            <div class="col-md-4">
                <span class="text-muted small d-block">Current Lifecycle Stage</span>
                <div class="mt-1"><asp:Literal ID="litCurrentStatusBadge" runat="server"></asp:Literal></div>
            </div>

            <div class="col-md-8">
                <div class="d-flex flex-wrap gap-2 justify-content-md-end">
                    <asp:Button ID="btnConfirm" runat="server" CssClass="btn btn-primary py-2 px-3 small" Text="Confirm Order" OnClick="btnConfirm_Click" />
                    <asp:Button ID="btnShip" runat="server" CssClass="btn btn-warning py-2 px-3 small" Text="Mark as Shipped" OnClick="btnShip_Click" />
                    <asp:Button ID="btnDeliver" runat="server" CssClass="btn btn-success py-2 px-3 small" Text="Mark as Delivered" OnClick="btnDeliver_Click" />
                    <asp:Button ID="btnCancelOrder" runat="server" CssClass="btn btn-outline-danger py-2 px-3 small" Text="Cancel & Restore Stock" OnClick="btnCancelOrder_Click" OnClientClick="return confirmAction('Cancel order and return all pieces to active inventory?');" />
                </div>
            </div>
        </div>

        <div class="mt-3 pt-3 border-top small text-muted">
            <i class="bi bi-info-circle me-1"></i>
            Marking an order as <strong>Delivered</strong> automatically sets delivery timestamp and clears Cash on Delivery payments to <strong>Paid</strong>.
        </div>
    </div>

    <div class="row g-4">
        <!-- Left Column: Ordered Items -->
        <div class="col-lg-8">
            <div class="admin-card-section">
                <h5 class="brand-font fs-5 mb-3" style="color: var(--color-deep-ocean);">Ordered Atelier Pieces</h5>

                <div class="table-responsive">
                    <asp:GridView ID="gvItems" runat="server" AutoGenerateColumns="false" CssClass="table-luxury" GridLines="None">
                        <Columns>
                            <asp:TemplateField HeaderText="Piece">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center gap-2">
                                        <img src='<%# Eval("PrimaryImage") %>' alt='<%# Eval("ProductName") %>' class="item-thumb-admin" />
                                        <div>
                                            <strong style="color: var(--color-deep-ocean);"><%# Eval("ProductName") %></strong>
                                            <%# !string.IsNullOrEmpty(Eval("VariantValue").ToString()) ? "<div class='text-muted small'>" + Eval("VariantValue") + "</div>" : "" %>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Unit Price">
                                <ItemTemplate>
                                    &#8377;<%# string.Format("{0:N0}", Eval("UnitPrice")) %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="Quantity" HeaderText="Quantity" />

                            <asp:TemplateField HeaderText="Total">
                                <ItemTemplate>
                                    <strong>&#8377;<%# string.Format("{0:N0}", Eval("TotalPrice")) %></strong>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Right Column: Shipping & Payment Summary -->
        <div class="col-lg-4">
            <!-- Client & Delivery Card -->
            <div class="admin-card-section mb-4">
                <h6 class="brand-font fs-6 mb-3" style="color: var(--color-deep-ocean);">Client Delivery Information</h6>
                <div class="mb-2">
                    <span class="text-muted small d-block">Client Name</span>
                    <strong><asp:Literal ID="litShippingName" runat="server"></asp:Literal></strong>
                </div>
                <div class="mb-2">
                    <span class="text-muted small d-block">Contact Number</span>
                    <asp:Literal ID="litShippingPhone" runat="server"></asp:Literal>
                </div>
                <div class="mb-2">
                    <span class="text-muted small d-block">Destination</span>
                    <asp:Literal ID="litShippingAddress" runat="server"></asp:Literal><br />
                    <asp:Literal ID="litShippingCity" runat="server"></asp:Literal> - <asp:Literal ID="litShippingPincode" runat="server"></asp:Literal>
                </div>
            </div>

            <!-- Financial Summary Card -->
            <div class="admin-card-section">
                <h6 class="brand-font fs-6 mb-3" style="color: var(--color-deep-ocean);">Financial Breakdown</h6>

                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-muted">Payment Mode</span>
                    <strong><asp:Literal ID="litPaymentMethod" runat="server"></asp:Literal></strong>
                </div>
                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-muted">Payment Status</span>
                    <span><asp:Literal ID="litPaymentStatus" runat="server"></asp:Literal></span>
                </div>

                <hr style="border-color: var(--color-beige-light) !important;" />

                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-muted">Subtotal</span>
                    <span>&#8377;<asp:Literal ID="litSubTotal" runat="server"></asp:Literal></span>
                </div>
                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-muted">Delivery Fee</span>
                    <span>&#8377;<asp:Literal ID="litShippingFee" runat="server"></asp:Literal></span>
                </div>

                <hr style="border-color: var(--color-beige-light) !important;" />

                <div class="d-flex justify-content-between align-items-baseline">
                    <span class="fw-bold" style="color: var(--color-deep-ocean);">Grand Total</span>
                    <span class="fs-4 fw-bold" style="color: var(--color-deep-ocean);">
                        &#8377;<asp:Literal ID="litGrandTotal" runat="server"></asp:Literal>
                    </span>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
