<%@ Page Title="Manage Atelier Sub-Categories" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="SubCategories.aspx.cs" Inherits="KriyaID.AdminSubCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Action Alert -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success py-2 small" role="alert">
        <asp:Literal ID="litAlert" runat="server"></asp:Literal>
    </asp:Panel>

    <div class="row g-4">
        <!-- Left Column: Add / Edit SubCategory Form -->
        <div class="col-lg-4">
            <div class="card-luxury p-3">
                <h5 class="brand-font fs-5 mb-3" style="color: var(--color-deep-ocean);">
                    <asp:Literal ID="litFormTitle" runat="server" Text="Add New Sub-Category"></asp:Literal>
                </h5>

                <asp:HiddenField ID="hfEditId" runat="server" Value="0" />

                <div class="mb-3">
                    <label class="form-label-luxury">Parent Living Space Category <span class="text-danger">*</span></label>
                    <asp:DropDownList ID="ddlFormCategory" runat="server" CssClass="form-select form-control-luxury">
                    </asp:DropDownList>
                </div>

                <div class="mb-3">
                    <label class="form-label-luxury">Sub-Category Name <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control form-control-luxury" placeholder="e.g. Luxury Sofas"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" Display="Dynamic" ForeColor="#9B2C2C" ErrorMessage="Name is required." CssClass="small" />
                </div>

                <div class="mb-3">
                    <label class="form-label-luxury">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control form-control-luxury" TextMode="MultiLine" Rows="2" placeholder="Sub-category notes..."></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label-luxury">Image URL</label>
                    <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control form-control-luxury" placeholder="https://images.unsplash.com/..."></asp:TextBox>
                </div>

                <div class="mb-3 form-check">
                    <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" CssClass="form-check-input" />
                    <label class="form-check-label fw-semibold" for='<%= chkIsActive.ClientID %>'>Active & Available</label>
                </div>

                <div class="d-flex gap-2">
                    <asp:Button ID="btnSave" runat="server" CssClass="btn btn-luxury-primary flex-grow-1" Text="Save Sub-Category" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-luxury-outline" Text="Cancel" OnClick="btnCancel_Click" Visible="false" CausesValidation="false" />
                </div>
            </div>
        </div>

        <!-- Right Column: SubCategories GridView with Category Filter -->
        <div class="col-lg-8">
            <div class="card-luxury p-3">
                <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 gap-2">
                    <h5 class="brand-font fs-5 mb-0" style="color: var(--color-deep-ocean);">Atelier Sub-Categories</h5>
                    <div class="d-flex align-items-center gap-2">
                        <label class="form-label-luxury mb-0 small text-nowrap">Filter By:</label>
                        <asp:DropDownList ID="ddlFilterCategory" runat="server" CssClass="form-select form-control-luxury py-1 small" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterCategory_SelectedIndexChanged" style="width: auto;">
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="gvSubCategories" runat="server" AutoGenerateColumns="false" CssClass="table-luxury" GridLines="None" DataKeyNames="Id" OnRowCommand="gvSubCategories_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Thumb">
                                <ItemTemplate>
                                    <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Name") %>' style="width: 45px; height: 45px; object-fit: cover; border-radius: 6px;" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                            <asp:BoundField DataField="Name" HeaderText="Sub-Category" />
                            <asp:TemplateField HeaderText="Products">
                                <ItemTemplate>
                                    <span class="badge" style="background-color: var(--color-cream); color: var(--color-deep-ocean); border: 1px solid var(--color-beige);">
                                        <%# Eval("ProductCount") %> pieces
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <%# Convert.ToBoolean(Eval("IsActive")) ? "<span class='badge bg-success-subtle text-success border border-success-subtle'>Active</span>" : "<span class='badge bg-secondary-subtle text-secondary border border-secondary-subtle'>Hidden</span>" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditSubCategory" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-luxury-outline py-1 px-2 me-1" CausesValidation="false">
                                        <i class="bi bi-pencil"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteSubCategory" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger py-1 px-2" OnClientClick="return confirmAction('Delete this sub-category and all associated products?');" CausesValidation="false">
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
