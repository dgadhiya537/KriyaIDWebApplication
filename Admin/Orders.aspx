<%@ Page Title="Order Fulfillment Management" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="Orders.aspx.cs" Inherits="KriyaID.AdminOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-luxury p-4">
        <!-- Controls Bar -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div class="d-flex flex-wrap align-items-center gap-2">
                <!-- Search Box -->
                <div class="input-group" style="max-width: 280px;">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control form-control-luxury py-1 small" placeholder="Search order # or client..."></asp:TextBox>
                    <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-luxury-primary py-1 px-3" OnClick="btnSearch_Click">
                        <i class="bi bi-search"></i>
                    </asp:LinkButton>
                </div>

                <!-- Status Filter -->
                <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select form-control-luxury py-1 small" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" style="width: auto;">
                    <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                    <asp:ListItem Value="Placed" Text="Placed"></asp:ListItem>
                    <asp:ListItem Value="Confirmed" Text="Confirmed"></asp:ListItem>
                    <asp:ListItem Value="Shipped" Text="Shipped"></asp:ListItem>
                    <asp:ListItem Value="Delivered" Text="Delivered"></asp:ListItem>
                    <asp:ListItem Value="Cancelled" Text="Cancelled"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div>
                <span class="text-muted small">Total Orders: <strong><asp:Literal ID="litCount" runat="server">0</asp:Literal></strong></span>
            </div>
        </div>

        <!-- Orders GridView -->
        <div class="table-responsive">
            <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="false" CssClass="table-luxury" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="OrderNumber" HeaderText="Order Reference" />
                    
                    <asp:TemplateField HeaderText="Client Details">
                        <ItemTemplate>
                            <strong style="color: var(--color-deep-ocean);"><%# Eval("ShippingName") %></strong>
                            <div class="small text-muted"><i class="bi bi-geo-alt me-1"></i><%# Eval("ShippingCity") %></div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Order Date">
                        <ItemTemplate>
                            <%# Convert.ToDateTime(Eval("OrderDate")).ToString("dd MMM yyyy, hh:mm tt") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Total">
                        <ItemTemplate>
                            <strong>&#8377;<%# string.Format("{0:N0}", Eval("TotalAmount")) %></strong>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Payment">
                        <ItemTemplate>
                            <div class="small"><%# Eval("PaymentMethod") %></div>
                            <span class='<%# Eval("PaymentStatus").ToString() == "Paid" ? "badge bg-success-subtle text-success border border-success-subtle small" : "badge bg-warning-subtle text-warning border border-warning-subtle small" %>'>
                                <%# Eval("PaymentStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Fulfillment Status">
                        <ItemTemplate>
                            <%# GetStatusBadge(Eval("OrderStatus").ToString()) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <a href='<%# ResolveUrl("~/Admin/OrderDetails.aspx?orderNo=" + Eval("OrderNumber")) %>' class="btn btn-sm btn-luxury-primary py-1 px-3">
                                Inspect & Fulfill <i class="bi bi-arrow-right ms-1"></i>
                            </a>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
