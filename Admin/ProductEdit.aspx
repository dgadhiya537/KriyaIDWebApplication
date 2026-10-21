<%@ Page Title="Atelier Piece Editor" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="ProductEdit.aspx.cs" Inherits="KriyaID.AdminProductEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .edit-section-card {
            background-color: var(--color-white);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-md);
            padding: 1.75rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow-soft);
        }
        .thumb-preview-box {
            position: relative;
            width: 110px;
            height: 110px;
            border-radius: var(--radius-sm);
            overflow: hidden;
            border: 2px solid var(--color-beige);
        }
        .thumb-preview-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .primary-badge-tag {
            position: absolute;
            top: 4px;
            left: 4px;
            background-color: var(--color-deep-ocean);
            color: var(--color-cream);
            font-size: 0.65rem;
            padding: 2px 6px;
            border-radius: 4px;
            font-weight: 600;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header with Back Button -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="brand-font fs-3 mb-0">
                <asp:Literal ID="litPageTitle" runat="server" Text="Create New Atelier Piece"></asp:Literal>
            </h1>
            <small class="text-muted">Fill out the architectural details, materials, and upload high-res imagery</small>
        </div>
        <a href='<%= ResolveUrl("~/Admin/Products.aspx") %>' class="btn btn-luxury-outline py-2 px-3">
            <i class="bi bi-arrow-left me-1"></i>Back to Catalog
        </a>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success py-2 small" role="alert">
        <asp:Literal ID="litAlert" runat="server"></asp:Literal>
    </asp:Panel>

    <div class="row g-4">
        <!-- Left Column: Core Product Info -->
        <div class="col-lg-7">
            <div class="edit-section-card">
                <h5 class="brand-font fs-5 mb-3" style="color: var(--color-deep-ocean);">
                    1. Basic Piece Specifications
                </h5>

                <div class="mb-3">
                    <label class="form-label-luxury">Sub-Category <span class="text-danger">*</span></label>
                    <asp:DropDownList ID="ddlSubCategory" runat="server" CssClass="form-select form-control-luxury">
                    </asp:DropDownList>
                </div>

                <div class="mb-3">
                    <label class="form-label-luxury">Piece Title / Name <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control form-control-luxury" placeholder="e.g. Aurelia Brushed Brass Lounge Armchair"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Name is required." CssClass="small" />
                </div>

                <div class="mb-3">
                    <label class="form-label-luxury">Architectural Description & Craftsmanship Details</label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control form-control-luxury" TextMode="MultiLine" Rows="5" placeholder="Dimensions, hardwood framing, upholstery composition, foam density..."></asp:TextBox>
                </div>

                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label-luxury">Original Price (&#8377;) <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control form-control-luxury" placeholder="e.g. 45000" TextMode="Number" step="0.01"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPrice" runat="server" ControlToValidate="txtPrice" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Price is required." CssClass="small" />
                    </div>

                    <div class="col-md-4">
                        <label class="form-label-luxury">Discount (%)</label>
                        <asp:TextBox ID="txtDiscountPercent" runat="server" CssClass="form-control form-control-luxury" placeholder="0" TextMode="Number"></asp:TextBox>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label-luxury">Stock Units <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtStock" runat="server" CssClass="form-control form-control-luxury" placeholder="10" TextMode="Number"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvStock" runat="server" ControlToValidate="txtStock" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Stock is required." CssClass="small" />
                    </div>
                </div>

                <div class="mt-4 form-check">
                    <asp:CheckBox ID="chkIsFeatured" runat="server" CssClass="form-check-input" />
                    <label class="form-check-label fw-semibold" for='<%= chkIsFeatured.ClientID %>'>
                        Feature in Signature Bestsellers on Homepage
                    </label>
                </div>

                <div class="mt-4 pt-3 border-top">
                    <asp:Button ID="btnSaveProduct" runat="server" CssClass="btn btn-luxury-primary px-4 py-2 fs-6" Text="Save Product Details" OnClick="btnSaveProduct_Click" />
                </div>
            </div>
        </div>

        <!-- Right Column: Images & Variants Management -->
        <div class="col-lg-5">
            <!-- Image Management Box -->
            <div class="edit-section-card">
                <h5 class="brand-font fs-5 mb-3" style="color: var(--color-deep-ocean);">
                    2. Imagery & Gallery
                </h5>

                <asp:PlaceHolder ID="phImageUpload" runat="server">
                    <!-- File Upload (AllowMultiple) -->
                    <div class="mb-3">
                        <label class="form-label-luxury">Upload Images from Disk (Local / Product Photo)</label>
                        <asp:FileUpload ID="fuImages" runat="server" AllowMultiple="true" CssClass="form-control form-control-luxury" />
                        <small class="text-muted">Saved automatically to <code>/images/products/</code></small>
                    </div>

                    <!-- Direct URL option -->
                    <div class="mb-3">
                        <label class="form-label-luxury">Or Add Image by Web URL</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control form-control-luxury" placeholder="https://..."></asp:TextBox>
                            <asp:Button ID="btnAddImageUrl" runat="server" CssClass="btn btn-luxury-primary" Text="Add URL" OnClick="btnAddImageUrl_Click" CausesValidation="false" />
                        </div>
                    </div>

                    <!-- Existing Images Repeater -->
                    <div class="d-flex flex-wrap gap-2 mt-3">
                        <asp:Repeater ID="rptImages" runat="server" OnItemCommand="rptImages_ItemCommand">
                            <ItemTemplate>
                                <div class="thumb-preview-box">
                                    <img src='<%# Eval("ImageUrl") %>' alt="Product Image" />
                                    <%# Convert.ToBoolean(Eval("IsPrimary")) ? "<span class='primary-badge-tag'>Primary</span>" : "" %>
                                    <div class="position-absolute bottom-0 start-0 end-0 bg-dark bg-opacity-75 d-flex justify-content-between p-1">
                                        <asp:LinkButton ID="btnSetPrimary" runat="server" CommandName="SetPrimary" CommandArgument='<%# Eval("Id") %>' CssClass="text-warning small" ToolTip="Set as Primary" CausesValidation="false">
                                            <i class="bi bi-star"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDelImg" runat="server" CommandName="DeleteImage" CommandArgument='<%# Eval("Id") %>' CssClass="text-danger small" ToolTip="Delete" CausesValidation="false">
                                            <i class="bi bi-trash"></i>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:PlaceHolder>

                <asp:PlaceHolder ID="phSaveProductFirstMsg" runat="server" Visible="false">
                    <p class="text-muted small">Please save initial product details before uploading imagery and defining sub-variants.</p>
                </asp:PlaceHolder>
            </div>

            <!-- Product Variants Box -->
            <asp:PlaceHolder ID="phVariantsSection" runat="server">
                <div class="edit-section-card">
                    <h5 class="brand-font fs-5 mb-3" style="color: var(--color-deep-ocean);">
                        3. Customization Variants (Sub-Products)
                    </h5>

                    <!-- Add Variant Form -->
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label-luxury small">Variant Type</label>
                            <asp:TextBox ID="txtVarName" runat="server" CssClass="form-control form-control-luxury p-1 small" placeholder="e.g. Size / Material"></asp:TextBox>
                        </div>
                        <div class="col-6">
                            <label class="form-label-luxury small">Option Value</label>
                            <asp:TextBox ID="txtVarValue" runat="server" CssClass="form-control form-control-luxury p-1 small" placeholder="e.g. King Size / Teak"></asp:TextBox>
                        </div>
                        <div class="col-6">
                            <label class="form-label-luxury small">Extra Cost (+&#8377;)</label>
                            <asp:TextBox ID="txtVarExtraPrice" runat="server" CssClass="form-control form-control-luxury p-1 small" placeholder="0" TextMode="Number" step="0.01"></asp:TextBox>
                        </div>
                        <div class="col-6">
                            <label class="form-label-luxury small">Variant Stock</label>
                            <asp:TextBox ID="txtVarStock" runat="server" CssClass="form-control form-control-luxury p-1 small" placeholder="10" TextMode="Number"></asp:TextBox>
                        </div>
                        <div class="col-12 mt-2">
                            <asp:Button ID="btnAddVariant" runat="server" CssClass="btn btn-luxury-primary w-100 py-1 small" Text="+ Add Variant" OnClick="btnAddVariant_Click" CausesValidation="false" />
                        </div>
                    </div>

                    <!-- Existing Variants List -->
                    <div class="border rounded overflow-hidden mt-3" style="border-color: var(--color-beige-light) !important;">
                        <asp:Repeater ID="rptVariants" runat="server" OnItemCommand="rptVariants_ItemCommand">
                            <ItemTemplate>
                                <div class="d-flex justify-content-between align-items-center p-2 border-bottom small">
                                    <div>
                                        <strong><%# Eval("VariantName") %>: <%# Eval("VariantValue") %></strong>
                                        <div class="text-muted">+&#8377;<%# string.Format("{0:N0}", Eval("AdditionalPrice")) %> | Stock: <%# Eval("Stock") %></div>
                                    </div>
                                    <asp:LinkButton ID="btnDelVar" runat="server" CommandName="DeleteVariant" CommandArgument='<%# Eval("Id") %>' CssClass="text-danger" CausesValidation="false">
                                        <i class="bi bi-trash"></i>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </asp:PlaceHolder>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
