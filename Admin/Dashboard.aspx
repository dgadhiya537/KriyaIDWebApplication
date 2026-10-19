<%@ Page Title="Executive Studio Dashboard" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="KriyaID.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- KPI Metrics Row -->
    <div class="row g-3 mb-4">
        <!-- Total Revenue -->
        <div class="col-xl-4 col-md-6">
            <div class="kpi-card">
                <div class="kpi-icon" style="background-color: rgba(42, 107, 72, 0.12); color: var(--color-success);">
                    <i class="bi bi-currency-rupee"></i>
                </div>
                <div>
                    <div class="kpi-title">Gross Revenue (Excl. Cancelled)</div>
                    <h3 class="kpi-value">&#8377;<asp:Literal ID="litTotalSales" runat="server">0</asp:Literal></h3>
                </div>
            </div>
        </div>

        <!-- Total Orders -->
        <div class="col-xl-4 col-md-6">
            <div class="kpi-card">
                <div class="kpi-icon">
                    <i class="bi bi-cart-check"></i>
                </div>
                <div>
                    <div class="kpi-title">Total Orders Placed</div>
                    <h3 class="kpi-value"><asp:Literal ID="litTotalOrders" runat="server">0</asp:Literal></h3>
                </div>
            </div>
        </div>

        <!-- Pending Orders -->
        <div class="col-xl-4 col-md-6">
            <div class="kpi-card">
                <div class="kpi-icon" style="background-color: rgba(180, 125, 40, 0.12); color: var(--color-warning);">
                    <i class="bi bi-hourglass-split"></i>
                </div>
                <div>
                    <div class="kpi-title">Pending Orders (Placed/Confirmed)</div>
                    <h3 class="kpi-value"><asp:Literal ID="litPendingOrders" runat="server">0</asp:Literal></h3>
                </div>
            </div>
        </div>

        <!-- Registered Clients -->
        <div class="col-xl-4 col-md-6">
            <div class="kpi-card">
                <div class="kpi-icon">
                    <i class="bi bi-people"></i>
                </div>
                <div>
                    <div class="kpi-title">Registered Clientele</div>
                    <h3 class="kpi-value"><asp:Literal ID="litTotalUsers" runat="server">0</asp:Literal></h3>
                </div>
            </div>
        </div>

        <!-- Total Products -->
        <div class="col-xl-4 col-md-6">
            <div class="kpi-card">
                <div class="kpi-icon">
                    <i class="bi bi-box-seam"></i>
                </div>
                <div>
                    <div class="kpi-title">Live Atelier Pieces</div>
                    <h3 class="kpi-value"><asp:Literal ID="litTotalProducts" runat="server">0</asp:Literal></h3>
                </div>
            </div>
        </div>

        <!-- Low Stock Alerts -->
        <div class="col-xl-4 col-md-6">
            <div class="kpi-card">
                <div class="kpi-icon" style="background-color: rgba(155, 44, 44, 0.12); color: var(--color-danger);">
                    <i class="bi bi-exclamation-triangle"></i>
                </div>
                <div>
                    <div class="kpi-title">Low Stock Alert (&lt; 5 Units)</div>
                    <h3 class="kpi-value"><asp:Literal ID="litLowStockCount" runat="server">0</asp:Literal></h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Visual Charts Row -->
    <div class="row g-4 mb-4">
        <!-- Sales in Last 7 Days (Bar Chart) -->
        <div class="col-lg-8">
            <div class="card-luxury p-3">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="brand-font fs-6 mb-0">Sales Revenue Trend (Past 7 Days)</h5>
                    <span class="badge" style="background-color: var(--color-cream); color: var(--color-deep-ocean); border: 1px solid var(--color-beige);">
                        Daily Activity (&#8377;)
                    </span>
                </div>
                <div style="height: 280px; position: relative;">
                    <canvas id="salesChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Order Breakdown by Status (Doughnut Chart) -->
        <div class="col-lg-4">
            <div class="card-luxury p-3">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="brand-font fs-6 mb-0">Orders Distribution</h5>
                    <span class="badge" style="background-color: var(--color-cream); color: var(--color-deep-ocean); border: 1px solid var(--color-beige);">
                        Status Lifecycle
                    </span>
                </div>
                <div style="height: 280px; position: relative;">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Orders & Low Stock Tables Row -->
    <div class="row g-4">
        <!-- Recent Orders Table -->
        <div class="col-lg-7">
            <div class="card-luxury p-3">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="brand-font fs-6 mb-0">Recent Studio Orders</h5>
                    <a href='<%= ResolveUrl("~/Admin/Orders.aspx") %>' class="small text-decoration-none" style="color: var(--color-deep-ocean);">
                        View All <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
                <div class="table-responsive">
                    <asp:GridView ID="gvRecentOrders" runat="server" AutoGenerateColumns="false" CssClass="table-luxury" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="OrderNumber" HeaderText="Order Ref" />
                            <asp:BoundField DataField="ShippingName" HeaderText="Client" />
                            <asp:TemplateField HeaderText="Total">
                                <ItemTemplate>
                                    <strong>&#8377;<%# string.Format("{0:N0}", Eval("TotalAmount")) %></strong>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <%# GetStatusPill(Eval("OrderStatus").ToString()) %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <a href='<%# ResolveUrl("~/Admin/OrderDetails.aspx?orderNo=" + Eval("OrderNumber")) %>' class="btn btn-sm btn-luxury-outline py-1 px-2">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Low Stock Alerts Table -->
        <div class="col-lg-5">
            <div class="card-luxury p-3">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="brand-font fs-6 mb-0 text-danger"><i class="bi bi-exclamation-circle me-1"></i>Low Stock Inventory Alert</h5>
                    <a href='<%= ResolveUrl("~/Admin/Products.aspx") %>' class="small text-decoration-none" style="color: var(--color-deep-ocean);">
                        Catalog <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
                <div class="table-responsive">
                    <asp:GridView ID="gvLowStock" runat="server" AutoGenerateColumns="false" CssClass="table-luxury" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Atelier Piece" />
                            <asp:TemplateField HeaderText="Stock">
                                <ItemTemplate>
                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">
                                        <%# Eval("Stock") %> left
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <a href='<%# ResolveUrl("~/Admin/ProductEdit.aspx?id=" + Eval("Id")) %>' class="btn btn-sm btn-luxury-outline py-1 px-2">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script type="text/javascript">
        // Render Chart.js Visualizations dynamically from backend JSON arrays
        document.addEventListener("DOMContentLoaded", function () {
            // 1. Sales Trend (Bar Chart)
            var salesCtx = document.getElementById('salesChart');
            if (salesCtx) {
                new Chart(salesCtx.getContext('2d'), {
                    type: 'bar',
                    data: {
                        labels: <%= SalesDaysJson %>,
                        datasets: [{
                            label: 'Daily Sales (\u20B9)',
                            data: <%= SalesAmountsJson %>,
                            backgroundColor: '#2C365A',
                            borderColor: '#1C233B',
                            borderWidth: 1,
                            borderRadius: 6
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value) { return '\u20B9 ' + Number(value).toLocaleString('en-IN'); }
                                }
                            }
                        }
                    }
                });
            }

            // 2. Orders by Status (Doughnut Chart)
            var statusCtx = document.getElementById('statusChart');
            if (statusCtx) {
                new Chart(statusCtx.getContext('2d'), {
                    type: 'doughnut',
                    data: {
                        labels: <%= StatusLabelsJson %>,
                        datasets: [{
                            data: <%= StatusCountsJson %>,
                            backgroundColor: [
                                '#3B82F6', // Placed: Blue
                                '#6366F1', // Confirmed: Indigo
                                '#F59E0B', // Shipped: Amber
                                '#10B981', // Delivered: Emerald
                                '#EF4444'  // Cancelled: Red
                            ],
                            borderWidth: 2,
                            borderColor: '#FFFFFF'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'bottom' }
                        }
                    }
                });
            }
        });
    </script>
</asp:Content>
