<%@ Page Title="Product Catalog Management" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="KriyaID.AdminProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Action Alert -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success py-2 small" role="alert">
        <asp:Literal ID="litAlert" runat="server"></asp:Literal>
    </asp:Panel>

    <div class="card-luxury p-4">
        <!-- Top Controls: Search, Filter, Add New Button -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div class="d-flex flex-wrap align-items-center gap-2">
                <!-- Search Box -->
                <div class="input-group" style="max-width: 260px;">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control form-control-luxury py-1 small" placeholder="Search piece name..."></asp:TextBox>
                    <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-luxury-primary py-1 px-3" OnClick="btnSearch_Click">
                        <i class="bi bi-search"></i>
                    </asp:LinkButton>
                </div>

                <!-- Category Filter -->
                <asp:DropDownList ID="ddlFilterCategory" runat="server" CssClass="form-select form-control-luxury py-1 small" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterCategory_SelectedIndexChanged" style="width: auto;">
                </asp:DropDownList>
            </div>

            <!-- Add Product Button -->
            <a href='<%= ResolveUrl("~/Admin/ProductEdit.aspx") %>' class="btn btn-luxury-primary py-2 px-3">
                <i class="bi bi-plus-circle me-1"></i>Add New Atelier Piece
            </a>
        </div>

        <!-- Products GridView -->
        <div class="table-responsive">
            <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="false" CssClass="table-luxury" GridLines="None" DataKeyNames="Id" OnRowCommand="gvProducts_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="Thumbnail">
                        <ItemTemplate>
                            <img src='<%# Eval("PrimaryImage") %>' alt='<%# Eval("Name") %>' style="width: 55px; height: 55px; object-fit: cover; border-radius: 8px;" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Piece Details">
                        <ItemTemplate>
                            <strong style="color: var(--color-deep-ocean);"><%# Eval("Name") %></strong>
                            <div class="small text-muted"><%# Eval("CategoryName") %> • <%# Eval("SubCategoryName") %></div>
                            <%# Convert.ToBoolean(Eval("IsFeatured")) ? "<span class='badge bg-warning-subtle text-warning border border-warning-subtle small mt-1'><i class='bi bi-star-fill me-1'></i>Featured</span>" : "" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Pricing">
                        <ItemTemplate>
                            <div><strong>&#8377;<%# string.Format("{0:N0}", (Convert.ToDecimal(Eval("Price")) * (100 - Convert.ToInt32(Eval("DiscountPercent")))) / 100) %></strong></div>
                            <%# Convert.ToInt32(Eval("DiscountPercent")) > 0 ? "<small class='text-muted text-decoration-line-through'>&#8377;" + string.Format("{0:N0}", Eval("Price")) + "</small> <span class='badge bg-danger-subtle text-danger small'>-" + Eval("DiscountPercent") + "%</span>" : "" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Inventory">
                        <ItemTemplate>
                            <%# Convert.ToInt32(Eval("Stock")) < 5 
                                ? "<span class='badge bg-danger-subtle text-danger border border-danger-subtle'>" + Eval("Stock") + " left</span>"
                                : "<span class='badge bg-success-subtle text-success border border-success-subtle'>" + Eval("Stock") + " units</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Variants">
                        <ItemTemplate>
                            <span class="badge" style="background-color: var(--color-cream); color: var(--color-deep-ocean); border: 1px solid var(--color-beige);">
                                <%# Eval("VariantCount") %> variants
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <a href='<%# ResolveUrl("~/Admin/ProductEdit.aspx?id=" + Eval("Id")) %>' class="btn btn-sm btn-luxury-outline py-1 px-2 me-1" title="Edit Piece">
                                <i class="bi bi-pencil"></i>
                            </a>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteProduct" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger py-1 px-2" OnClientClick="return confirmAction('Are you sure you want to delete this piece? All attached images and variants will be deleted.');" title="Delete Piece">
                                <i class="bi bi-trash"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
