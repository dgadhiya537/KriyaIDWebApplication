<%@ Page Title="Order Progress" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="OrderDetails.aspx.cs" Inherits="KriyaID.OrderDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .order-detail-box {
            background-color: var(--color-white);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-md);
            padding: 1.75rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow-soft);
        }
        .item-thumb-sm {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: var(--radius-sm);
            border: 1px solid var(--color-beige);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <!-- Breadcrumb & Header -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb small mb-1">
                        <li class="breadcrumb-item"><a href="Home.aspx" style="color: var(--color-deep-ocean);">Home</a></li>
                        <li class="breadcrumb-item"><a href="MyOrders.aspx" style="color: var(--color-deep-ocean);">My Orders</a></li>
                        <li class="breadcrumb-item active text-muted" aria-current="page"><asp:Literal ID="litBreadcrumbOrderNo" runat="server"></asp:Literal></li>
                    </ol>
                </nav>
                <h1 class="brand-font fs-2 mb-0">
                    Order Reference: <asp:Literal ID="litOrderNoHeading" runat="server"></asp:Literal>
                </h1>
                <small class="text-muted"><i class="bi bi-clock me-1"></i>Placed on <asp:Literal ID="litOrderDate" runat="server"></asp:Literal></small>
            </div>

            <!-- Cancel Button (Active when Placed or Confirmed) -->
            <div>
                <asp:Button ID="btnCancelOrder" runat="server" CssClass="btn btn-outline-danger py-2 px-3 small" Text="Cancel Order" OnClick="btnCancelOrder_Click" OnClientClick="return confirmAction('Are you sure you want to cancel this order? Item quantities will be restocked.');" Visible="false" />
            </div>
        </div>

        <!-- Alert Panel -->
        <asp:Panel ID="pnlActionMsg" runat="server" Visible="false" CssClass="alert alert-info py-2 small" role="alert">
            <asp:Literal ID="litActionMsg" runat="server"></asp:Literal>
        </asp:Panel>

        <!-- Visual Status Stepper Tracker -->
        <div class="order-detail-box">
            <h4 class="brand-font fs-5 mb-3">Shipment Progress & Logistics</h4>

            <asp:PlaceHolder ID="phCancelledNotice" runat="server" Visible="false">
                <div class="alert alert-danger py-3 text-center mb-0">
                    <i class="bi bi-x-octagon-fill fs-3 d-block mb-1"></i>
                    <strong>This order was cancelled.</strong>
                    <div class="small">The reserved furniture pieces have been returned to studio inventory.</div>
                </div>
            </asp:PlaceHolder>

            <asp:PlaceHolder ID="phActiveTracker" runat="server">
                <div class="order-tracker">
                    <!-- Step 1: Placed -->
                    <div class='<%= GetStepClass(1) %>'>
                        <div class="tracker-node"><i class="bi bi-file-earmark-check"></i></div>
                        <div class="tracker-label">Order Placed</div>
                    </div>
                    <!-- Step 2: Confirmed -->
                    <div class='<%= GetStepClass(2) %>'>
                        <div class="tracker-node"><i class="bi bi-clipboard-check"></i></div>
                        <div class="tracker-label">Confirmed</div>
                    </div>
                    <!-- Step 3: Shipped -->
                    <div class='<%= GetStepClass(3) %>'>
                        <div class="tracker-node"><i class="bi bi-truck"></i></div>
                        <div class="tracker-label">Dispatched</div>
                    </div>
                    <!-- Step 4: Delivered -->
                    <div class='<%= GetStepClass(4) %>'>
                        <div class="tracker-node"><i class="bi bi-box2-heart"></i></div>
                        <div class="tracker-label">Delivered & Assembled</div>
                    </div>
                </div>

                <asp:PlaceHolder ID="phDeliveredDate" runat="server" Visible="false">
                    <div class="text-center text-success small fw-semibold mt-2">
                        <i class="bi bi-check-circle-fill me-1"></i>Delivered on <asp:Literal ID="litDeliveredDateText" runat="server"></asp:Literal>
                    </div>
                </asp:PlaceHolder>
            </asp:PlaceHolder>
        </div>

        <div class="row g-4">
            <!-- Left Column: Ordered Items -->
            <div class="col-lg-8">
                <div class="order-detail-box">
                    <h4 class="brand-font fs-5 mb-3">Curated Items in this Order</h4>

                    <div class="border rounded overflow-hidden" style="border-color: var(--color-beige-light) !important;">
                        <asp:Repeater ID="rptItems" runat="server">
                            <HeaderTemplate>
                                <div class="d-none d-md-flex p-3 fw-semibold small border-bottom" style="background-color: var(--color-cream); color: var(--color-deep-ocean);">
                                    <div class="col-6">Item</div>
                                    <div class="col-2 text-center">Unit Price</div>
                                    <div class="col-2 text-center">Qty</div>
                                    <div class="col-2 text-end">Total</div>
                                </div>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <div class="p-3 border-bottom d-flex flex-wrap align-items-center gap-3">
                                    <div class="col-12 col-md-5 d-flex align-items-center gap-3">
                                        <img src='<%# Eval("PrimaryImage") %>' alt='<%# Eval("ProductName") %>' class="item-thumb-sm" />
                                        <div>
                                            <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("ProductId")) %>' class="fw-semibold text-decoration-none" style="color: var(--color-deep-ocean);">
                                                <%# Eval("ProductName") %>
                                            </a>
                                            <%# !string.IsNullOrEmpty(Eval("VariantValue").ToString()) ? "<span class='d-block badge bg-light text-secondary border small mt-1'>" + Eval("VariantValue") + "</span>" : "" %>
                                            
                                            <!-- Write a review link if delivered -->
                                            <asp:PlaceHolder ID="phReviewLink" runat="server" Visible='<%# CurrentOrderStatus == "Delivered" %>'>
                                                <div class="mt-1">
                                                    <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("ProductId")) %>' class="text-primary small fw-semibold">
                                                        <i class="bi bi-star me-1"></i>Leave an Appraisal / Review
                                                    </a>
                                                </div>
                                            </asp:PlaceHolder>
                                        </div>
                                    </div>
                                    <div class="col-5 col-md-2 text-md-center">
                                        &#8377;<%# string.Format("{0:N0}", Eval("UnitPrice")) %>
                                    </div>
                                    <div class="col-6 col-md-2 text-md-center">
                                        <%# Eval("Quantity") %>
                                    </div>
                                    <div class="col-12 col-md-2 text-md-end text-end ms-auto fw-bold" style="color: var(--color-deep-ocean);">
                                        &#8377;<%# string.Format("{0:N0}", Eval("TotalPrice")) %>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>

            <!-- Right Column: Shipping & Payment Summary -->
            <div class="col-lg-4">
                <!-- Shipping Address Card -->
                <div class="order-detail-box mb-4">
                    <h5 class="brand-font fs-6 mb-2">Delivery Details</h5>
                    <p class="mb-1 fw-bold" style="color: var(--color-deep-ocean);">
                        <asp:Literal ID="litShippingName" runat="server"></asp:Literal>
                    </p>
                    <p class="mb-1 text-muted small">
                        <i class="bi bi-telephone me-1"></i><asp:Literal ID="litShippingPhone" runat="server"></asp:Literal>
                    </p>
                    <p class="mb-0 text-muted small" style="line-height: 1.6;">
                        <i class="bi bi-geo-alt me-1"></i><asp:Literal ID="litShippingAddress" runat="server"></asp:Literal><br />
                        <asp:Literal ID="litShippingCity" runat="server"></asp:Literal> - <asp:Literal ID="litShippingPincode" runat="server"></asp:Literal>
                    </p>
                </div>

                <!-- Payment Details Card -->
                <div class="order-detail-box">
                    <h5 class="brand-font fs-6 mb-3">Payment Summary</h5>

                    <div class="d-flex justify-content-between mb-2 small">
                        <span class="text-muted">Payment Mode</span>
                        <span class="fw-semibold"><asp:Literal ID="litPaymentMethod" runat="server"></asp:Literal></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2 small">
                        <span class="text-muted">Payment Status</span>
                        <span><asp:Literal ID="litPaymentStatus" runat="server"></asp:Literal></span>
                    </div>

                    <hr style="border-color: var(--color-beige-light) !important;" />

                    <div class="d-flex justify-content-between mb-2 small">
                        <span class="text-muted">Subtotal</span>
                        <span class="fw-semibold">&#8377;<asp:Literal ID="litSubTotal" runat="server"></asp:Literal></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2 small">
                        <span class="text-muted">White-Glove Delivery</span>
                        <span class="fw-semibold">&#8377;<asp:Literal ID="litShippingFee" runat="server"></asp:Literal></span>
                    </div>

                    <hr style="border-color: var(--color-beige) !important;" />

                    <div class="d-flex justify-content-between align-items-baseline">
                        <span class="fw-bold" style="color: var(--color-deep-ocean);">Grand Total</span>
                        <span class="fs-4 fw-bold" style="color: var(--color-deep-ocean);">
                            &#8377;<asp:Literal ID="litGrandTotal" runat="server"></asp:Literal>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
