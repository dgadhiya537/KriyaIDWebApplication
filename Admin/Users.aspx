<%@ Page Title="Client & Staff Directory" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="KriyaID.AdminUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Action Alert -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success py-2 small" role="alert">
        <asp:Literal ID="litAlert" runat="server"></asp:Literal>
    </asp:Panel>

    <div class="card-luxury p-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div>
                <h5 class="brand-font fs-5 mb-0" style="color: var(--color-deep-ocean);">Registered Users & Client Profiles</h5>
                <small class="text-muted">Manage access status, inspect registration records</small>
            </div>

            <!-- Search User -->
            <div class="input-group" style="max-width: 280px;">
                <asp:TextBox ID="txtSearchUser" runat="server" CssClass="form-control form-control-luxury py-1 small" placeholder="Search name or email..."></asp:TextBox>
                <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-luxury-primary py-1 px-3" OnClick="btnSearch_Click">
                    <i class="bi bi-search"></i>
                </asp:LinkButton>
            </div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" CssClass="table-luxury" GridLines="None" DataKeyNames="Id" OnRowCommand="gvUsers_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="#" />
                    <asp:BoundField DataField="FullName" HeaderText="Client Name" />
                    <asp:BoundField DataField="Email" HeaderText="Email Address" />
                    <asp:BoundField DataField="Phone" HeaderText="Phone" />
                    <asp:BoundField DataField="City" HeaderText="City" />
                    <asp:TemplateField HeaderText="Role">
                        <ItemTemplate>
                            <span class='<%# Eval("Role").ToString() == "Admin" ? "badge bg-dark text-white px-2 py-1" : "badge bg-light text-secondary border px-2 py-1" %>'>
                                <%# Eval("Role") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Registration Date">
                        <ItemTemplate>
                            <%# Convert.ToDateTime(Eval("CreatedOn")).ToString("dd MMM yyyy") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <%# Convert.ToBoolean(Eval("IsBlocked")) 
                                ? "<span class='badge bg-danger-subtle text-danger border border-danger-subtle'>Deactivated</span>" 
                                : "<span class='badge bg-success-subtle text-success border border-success-subtle'>Active</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Security Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnToggleBlock" runat="server" CommandName="ToggleBlock" CommandArgument='<%# Eval("Id") %>' 
                                CssClass='<%# Convert.ToBoolean(Eval("IsBlocked")) ? "btn btn-sm btn-outline-success py-1 px-2" : "btn btn-sm btn-outline-danger py-1 px-2" %>' 
                                Visible='<%# Eval("Role").ToString() != "Admin" %>'
                                OnClientClick="return confirmAction('Update client account status?');">
                                <%# Convert.ToBoolean(Eval("IsBlocked")) ? "<i class='bi bi-unlock me-1'></i>Unblock" : "<i class='bi bi-lock me-1'></i>Deactivate" %>
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
