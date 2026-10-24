<%@ Page Title="Hero Banners Management" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="Banners.aspx.cs" Inherits="KriyaID.AdminBanners" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Action Alert -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success py-2 small" role="alert">
        <asp:Literal ID="litAlert" runat="server"></asp:Literal>
    </asp:Panel>

    <div class="row g-4">
        <!-- Left Column: Add / Edit Banner Form -->
        <div class="col-lg-4">
            <div class="card-luxury p-3">
                <h5 class="brand-font fs-5 mb-3" style="color: var(--color-deep-ocean);">
                    <asp:Literal ID="litFormTitle" runat="server" Text="Add Hero Carousel Banner"></asp:Literal>
                </h5>

                <asp:HiddenField ID="hfEditId" runat="server" Value="0" />

                <div class="mb-3">
                    <label class="form-label-luxury">Headline Title <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control form-control-luxury" placeholder="e.g. Curated Living Spaces"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Title is required." CssClass="small" />
                </div>

                <div class="mb-3">
                    <label class="form-label-luxury">Subtitle / Tagline</label>
                    <asp:TextBox ID="txtSubtitle" runat="server" CssClass="form-control form-control-luxury" TextMode="MultiLine" Rows="2" placeholder="Brief supporting narrative..."></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label-luxury">High-Res Banner Image URL <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control form-control-luxury" placeholder="https://images.unsplash.com/..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvImg" runat="server" ControlToValidate="txtImageUrl" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Image URL is required." CssClass="small" />
                </div>

                <div class="mb-3">
                    <label class="form-label-luxury">Target Destination Link</label>
                    <asp:TextBox ID="txtLinkUrl" runat="server" CssClass="form-control form-control-luxury" placeholder="Products.aspx?cat=1"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label-luxury">Display Sequence Order</label>
                    <asp:TextBox ID="txtDisplayOrder" runat="server" CssClass="form-control form-control-luxury" placeholder="1" TextMode="Number"></asp:TextBox>
                </div>

                <div class="mb-3 form-check">
                    <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" CssClass="form-check-input" />
                    <label class="form-check-label fw-semibold" for='<%= chkIsActive.ClientID %>'>Active on Homepage</label>
                </div>

                <div class="d-flex gap-2">
                    <asp:Button ID="btnSave" runat="server" CssClass="btn btn-luxury-primary flex-grow-1" Text="Save Banner" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-luxury-outline" Text="Cancel" OnClick="btnCancel_Click" Visible="false" CausesValidation="false" />
                </div>
            </div>
        </div>

        <!-- Right Column: Banners GridView -->
        <div class="col-lg-8">
            <div class="card-luxury p-3">
                <h5 class="brand-font fs-5 mb-3" style="color: var(--color-deep-ocean);">Active Homepage Banners</h5>

                <div class="table-responsive">
                    <asp:GridView ID="gvBanners" runat="server" AutoGenerateColumns="false" CssClass="table-luxury" GridLines="None" DataKeyNames="Id" OnRowCommand="gvBanners_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Preview">
                                <ItemTemplate>
                                    <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Title") %>' style="width: 100px; height: 50px; object-fit: cover; border-radius: 6px;" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Banner Details">
                                <ItemTemplate>
                                    <strong style="color: var(--color-deep-ocean);"><%# Eval("Title") %></strong>
                                    <div class="small text-muted text-truncate" style="max-width: 200px;"><%# Eval("Subtitle") %></div>
                                    <small class="text-primary"><i class="bi bi-link-45deg"></i><%# Eval("LinkUrl") %></small>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="DisplayOrder" HeaderText="Order" />

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <%# Convert.ToBoolean(Eval("IsActive")) ? "<span class='badge bg-success-subtle text-success border border-success-subtle'>Active</span>" : "<span class='badge bg-secondary-subtle text-secondary border border-secondary-subtle'>Hidden</span>" %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditBanner" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-luxury-outline py-1 px-2 me-1" CausesValidation="false">
                                        <i class="bi bi-pencil"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteBanner" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger py-1 px-2" OnClientClick="return confirmAction('Delete this homepage banner?');" CausesValidation="false">
                                        <i class="bi bi-trash"></i>
                                    </asp:LinkButton>
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
</asp:Content>
