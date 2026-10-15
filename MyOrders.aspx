<%@ Page Title="My Atelier Orders" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="MyOrders.aspx.cs" Inherits="KriyaID.MyOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .order-card {
            background-color: var(--color-white);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-md);
            padding: 1.5rem;
            margin-bottom: 1.25rem;
            box-shadow: var(--shadow-soft);
            transition: var(--transition);
        }
        .order-card:hover {
            box-shadow: var(--shadow-elevated);
            border-color: var(--color-beige-dark);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <h1 class="brand-font fs-2 mb-4">My Orders & Acquisitions</h1>

        <!-- Empty State -->
        <asp:Panel ID="pnlNoOrders" runat="server" Visible="false" CssClass="text-center py-5 bg-white rounded border" style="border-color: var(--color-beige) !important;">
            <i class="bi bi-box-seam fs-1 text-muted mb-3 d-block"></i>
            <h3 class="brand-font">No Orders Placed Yet</h3>
            <p class="text-muted small">Begin curating your living space with our handcrafted collections.</p>
            <a href='<%= ResolveUrl("~/Products.aspx") %>' class="btn btn-luxury-primary mt-3 px-4 py-2">
                Browse Collections <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </asp:Panel>

        <!-- Orders List Repeater -->
        <asp:Repeater ID="rptOrders" runat="server">
            <ItemTemplate>
                <div class="order-card">
                    <div class="d-flex flex-wrap justify-content-between align-items-center pb-3 mb-3 border-bottom" style="border-color: var(--color-beige-light) !important;">
                        <div>
                            <span class="text-muted small">Order Reference:</span>
                            <span class="fw-bold fs-6 ms-1" style="color: var(--color-deep-ocean);"><%# Eval("OrderNumber") %></span>
                            <span class="text-muted small ms-3"><i class="bi bi-clock me-1"></i><%# Convert.ToDateTime(Eval("OrderDate")).ToString("dd MMM yyyy, hh:mm tt") %></span>
                        </div>
                        <div class="mt-2 mt-md-0">
                            <%# GetStatusBadge(Eval("OrderStatus").ToString()) %>
                        </div>
                    </div>

                    <div class="row align-items-center g-3">
                        <div class="col-md-4">
                            <span class="text-muted small d-block">Delivery Address</span>
                            <strong style="color: var(--color-deep-ocean);"><%# Eval("ShippingName") %></strong>
                            <div class="text-muted small text-truncate"><%# Eval("ShippingAddress") %>, <%# Eval("ShippingCity") %> - <%# Eval("ShippingPincode") %></div>
                        </div>

                        <div class="col-md-3">
                            <span class="text-muted small d-block">Payment Method</span>
                            <span class="small fw-semibold"><%# Eval("PaymentMethod") %></span>
                            <span class='<%# Eval("PaymentStatus").ToString() == "Paid" ? "badge bg-success-subtle text-success border border-success-subtle small ms-1" : "badge bg-warning-subtle text-warning border border-warning-subtle small ms-1" %>'>
                                <%# Eval("PaymentStatus") %>
                            </span>
                        </div>

                        <div class="col-md-2">
                            <span class="text-muted small d-block">Total Amount</span>
                            <span class="fs-5 fw-bold" style="color: var(--color-deep-ocean);">
                                &#8377;<%# string.Format("{0:N0}", Eval("TotalAmount")) %>
                            </span>
                        </div>

                        <div class="col-md-3 text-md-end">
                            <a href='<%# ResolveUrl("~/OrderDetails.aspx?orderNo=" + Eval("OrderNumber")) %>' class="btn btn-luxury-primary py-2 px-3 small">
                                View Details & Track <i class="bi bi-arrow-right ms-1"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
