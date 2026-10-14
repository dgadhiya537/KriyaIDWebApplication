<%@ Page Title="Order Confirmed" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="OrderSuccess.aspx.cs" Inherits="KriyaID.OrderSuccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .success-box {
            background-color: var(--color-white);
            border: 1px solid var(--color-beige);
            border-radius: var(--radius-lg);
            padding: 3.5rem 2rem;
            max-width: 650px;
            margin: 0 auto;
            text-align: center;
            box-shadow: var(--shadow-elevated);
        }
        .success-icon-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background-color: var(--color-cream);
            color: var(--color-deep-ocean);
            border: 2px solid var(--color-beige);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2.6rem;
            margin-bottom: 1.5rem;
        }
        .order-number-pill {
            display: inline-block;
            background-color: var(--color-cream);
            border: 1px dashed var(--color-deep-ocean);
            padding: 0.5rem 1.25rem;
            border-radius: 30px;
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--color-deep-ocean);
            letter-spacing: 0.05em;
            margin: 1rem 0 1.5rem 0;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="success-box">
            <div class="success-icon-circle">
                <i class="bi bi-check2"></i>
            </div>

            <h1 class="brand-font fs-2 mb-2">Acquisition Confirmed</h1>
            <p class="text-muted small mb-1">Thank you for curating with Kriya ID. Your bespoke interior order has been placed.</p>

            <div class="order-number-pill">
                Order Reference: <asp:Literal ID="litOrderNumber" runat="server"></asp:Literal>
            </div>

            <p class="small text-muted mb-4 px-md-4" style="line-height: 1.6;">
                Our studio master craftsman and logistical concierge will coordinate white-glove transport and in-home installation. 
                You can inspect the live status of your shipment in your client account.
            </p>

            <div class="d-flex flex-wrap justify-content-center gap-3">
                <asp:HyperLink ID="lnkOrderDetails" runat="server" CssClass="btn btn-luxury-primary px-4 py-2">
                    <i class="bi bi-eye me-1"></i>Track Order Status
                </asp:HyperLink>
                <a href='<%= ResolveUrl("~/Home.aspx") %>' class="btn btn-luxury-outline px-4 py-2">
                    Continue Browsing
                </a>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
