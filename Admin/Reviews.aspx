<%@ Page Title="Client Reviews Moderation" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="Reviews.aspx.cs" Inherits="KriyaID.AdminReviews" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Action Alert -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success py-2 small" role="alert">
        <asp:Literal ID="litAlert" runat="server"></asp:Literal>
    </asp:Panel>

    <div class="card-luxury p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h5 class="brand-font fs-5 mb-0" style="color: var(--color-deep-ocean);">Client Appraisals & Reviews Moderation</h5>
                <small class="text-muted">Review feedback and moderate inappropriate remarks</small>
            </div>
            <div>
                <span class="text-muted small">Total Reviews: <strong><asp:Literal ID="litTotalReviews" runat="server">0</asp:Literal></strong></span>
            </div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvReviews" runat="server" AutoGenerateColumns="false" CssClass="table-luxury" GridLines="None" DataKeyNames="Id" OnRowCommand="gvReviews_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="#" />

                    <asp:TemplateField HeaderText="Atelier Piece">
                        <ItemTemplate>
                            <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("ProductId")) %>' target="_blank" class="fw-semibold text-decoration-none" style="color: var(--color-deep-ocean);">
                                <%# Eval("ProductName") %>
                            </a>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="FullName" HeaderText="Client" />

                    <asp:TemplateField HeaderText="Rating">
                        <ItemTemplate>
                            <%# RenderStars(Convert.ToInt32(Eval("Rating"))) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Comment">
                        <ItemTemplate>
                            <span class="small text-muted" style="max-width: 300px; display: block;">
                                <%# Server.HtmlEncode(Eval("Comment").ToString()) %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Submitted On">
                        <ItemTemplate>
                            <%# Convert.ToDateTime(Eval("CreatedOn")).ToString("dd MMM yyyy") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteReview" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger py-1 px-2" OnClientClick="return confirmAction('Delete this customer review?');" CausesValidation="false">
                                <i class="bi bi-trash me-1"></i>Delete
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
