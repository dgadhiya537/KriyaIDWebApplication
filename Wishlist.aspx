<%@ Page Title="Personal Wishlist" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Wishlist.aspx.cs" Inherits="KriyaID.WishlistPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .wishlist-thumb {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: var(--radius-sm);
            border: 1px solid var(--color-beige);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <h1 class="brand-font fs-2 mb-4">Your Saved Atelier Curations</h1>

        <!-- Alert Panel -->
        <asp:Panel ID="pnlWishlistAlert" runat="server" Visible="false" CssClass="alert alert-success py-2 small" role="alert">
            <asp:Literal ID="litWishlistAlert" runat="server"></asp:Literal>
        </asp:Panel>

        <!-- Empty Wishlist -->
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="text-center py-5 bg-white rounded border" style="border-color: var(--color-beige) !important;">
            <i class="bi bi-heart fs-1 text-muted mb-3 d-block"></i>
            <h3 class="brand-font">Your Wishlist is Empty</h3>
            <p class="text-muted small">Save items you love to revisit or purchase later.</p>
            <a href='<%= ResolveUrl("~/Products.aspx") %>' class="btn btn-luxury-primary mt-3 px-4 py-2">
                Discover Pieces <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </asp:Panel>

        <!-- Wishlist Items Grid -->
        <asp:Panel ID="pnlWishlistContent" runat="server">
            <div class="bg-white rounded border overflow-hidden" style="border-color: var(--color-beige) !important;">
                <asp:Repeater ID="rptWishlist" runat="server" OnItemCommand="rptWishlist_ItemCommand">
                    <ItemTemplate>
                        <div class="p-3 border-bottom d-flex flex-wrap align-items-center gap-3" style="border-color: rgba(196, 188, 176, 0.4) !important;">
                            <!-- Image -->
                            <img src='<%# Eval("PrimaryImage") %>' alt='<%# Eval("Name") %>' class="wishlist-thumb flex-shrink-0" />

                            <!-- Details -->
                            <div class="flex-grow-1">
                                <span class="product-category-meta"><%# Eval("CategoryName") %></span>
                                <h5 class="brand-font fs-5 mb-1">
                                    <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("ProductId")) %>' class="text-decoration-none" style="color: var(--color-deep-ocean);">
                                        <%# Eval("Name") %>
                                    </a>
                                </h5>
                                <div class="d-flex align-items-baseline gap-2 mb-2">
                                    <span class="fs-5 fw-bold" style="color: var(--color-deep-ocean);">
                                        &#8377;<%# string.Format("{0:N0}", (Convert.ToDecimal(Eval("Price")) * (100 - Convert.ToInt32(Eval("DiscountPercent")))) / 100) %>
                                    </span>
                                    <%# Convert.ToInt32(Eval("DiscountPercent")) > 0 ? "<span class='text-muted text-decoration-line-through small'>&#8377;" + string.Format("{0:N0}", Eval("Price")) + "</span>" : "" %>
                                </div>
                                <small class="text-muted"><i class="bi bi-calendar-check me-1"></i>Saved on <%# Convert.ToDateTime(Eval("AddedOn")).ToString("dd MMM yyyy") %></small>
                            </div>

                            <!-- Actions -->
                            <div class="d-flex flex-column gap-2 ms-auto">
                                <asp:LinkButton ID="btnMoveToCart" runat="server" CommandName="MoveToCart" CommandArgument='<%# Eval("ProductId") %>' CssClass="btn btn-luxury-primary py-2 px-3 small" CausesValidation="false">
                                    <i class="bi bi-bag-plus me-1"></i>Move to Bag
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnRemove" runat="server" CommandName="RemoveWishlist" CommandArgument='<%# Eval("WishlistId") %>' CssClass="btn btn-luxury-outline py-1 px-3 small text-danger" CausesValidation="false">
                                    <i class="bi bi-trash me-1"></i>Remove
                                </asp:LinkButton>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
