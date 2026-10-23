<%@ Page Title="Consultation Leads" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="Consultations.aspx.cs" Inherits="KriyaID.AdminConsultations" %>

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
                <h5 class="brand-font fs-5 mb-0" style="color: var(--color-deep-ocean);">Interior Design Consultation Leads</h5>
                <small class="text-muted">Review client room requirements, budget allocations, and update lead pipeline status</small>
            </div>

            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select form-control-luxury py-1 small" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" style="width: auto;">
                <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                <asp:ListItem Value="New" Text="New Enquiries"></asp:ListItem>
                <asp:ListItem Value="Contacted" Text="Architect Contacted"></asp:ListItem>
                <asp:ListItem Value="Closed" Text="Closed / Commissioned"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvConsultations" runat="server" AutoGenerateColumns="false" CssClass="table-luxury" GridLines="None" DataKeyNames="Id" OnRowCommand="gvConsultations_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="#" />

                    <asp:TemplateField HeaderText="Client Contact">
                        <ItemTemplate>
                            <strong style="color: var(--color-deep-ocean);"><%# Eval("Name") %></strong>
                            <div class="small text-muted"><i class="bi bi-telephone me-1"></i><%# Eval("Phone") %></div>
                            <div class="small text-muted"><i class="bi bi-envelope me-1"></i><%# Eval("Email") %></div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Scope & Budget">
                        <ItemTemplate>
                            <span class="badge" style="background-color: var(--color-cream); color: var(--color-deep-ocean); border: 1px solid var(--color-beige);">
                                <%# Eval("RoomType") %>
                            </span>
                            <div class="small fw-semibold mt-1" style="color: var(--color-deep-ocean);">Budget: <%# Eval("Budget") %></div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Aesthetic Vision & Message">
                        <ItemTemplate>
                            <small class="text-muted" style="max-width: 250px; display: block;">
                                <%# Server.HtmlEncode(Eval("Message").ToString()) %>
                            </small>
                            <small class="text-muted d-block mt-1"><i class="bi bi-calendar me-1"></i><%# Convert.ToDateTime(Eval("CreatedOn")).ToString("dd MMM yyyy, hh:mm tt") %></small>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Lead Status">
                        <ItemTemplate>
                            <%# GetLeadStatusBadge(Eval("Status").ToString()) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="d-flex gap-1">
                                <asp:LinkButton ID="btnMarkContacted" runat="server" CommandName="SetContacted" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-warning py-1 px-2" ToolTip="Mark Contacted" CausesValidation="false">
                                    <i class="bi bi-telephone-outbound"></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnMarkClosed" runat="server" CommandName="SetClosed" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-success py-1 px-2" ToolTip="Mark Closed" CausesValidation="false">
                                    <i class="bi bi-check2-circle"></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteConsultation" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger py-1 px-2" ToolTip="Delete" OnClientClick="return confirmAction('Delete this consultation record?');" CausesValidation="false">
                                    <i class="bi bi-trash"></i>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
