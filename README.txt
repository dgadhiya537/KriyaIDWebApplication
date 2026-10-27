===================================================================================
               KRIYA ID - BESPOKE INTERIOR ARCHITECTURE & E-COMMERCE
                   Complete ASP.NET Web Forms (.NET 4.8, C#) Atelier
===================================================================================

Thank you for choosing Kriya ID. This project is a complete, production-ready
ASP.NET Web Forms web application built with C#, .NET Framework 4.8, ADO.NET,
and SQL Server LocalDB.

-----------------------------------------------------------------------------------
1. PALETTE & DESIGN SYSTEM (STRICT ADHERENCE TO REFERENCE IMAGE)
-----------------------------------------------------------------------------------
This project strictly implements the bespoke luxury interior color palette
from your requested specification image:

  - Cream       : #EEE8DF  (RGB: 238, 232, 223) -> Soft surfaces, card accents, bars
  - Beige       : #C4BCB0  (RGB: 196, 188, 176) -> Borders, secondary buttons, tags
  - Deep Ocean  : #2C365A  (RGB: 44, 54, 90)    -> Primary buttons, headers, accents
  - Canvas Light: #F7F5F0  (RGB: 247, 245, 240) -> Body background
  - Typography  : 'Playfair Display' (Serif) & 'Poppins' (Sans-Serif) from Google Fonts

-----------------------------------------------------------------------------------
2. DEMO ACCOUNTS & CREDENTIALS
-----------------------------------------------------------------------------------
All passwords use SHA256 hashing with cryptographic salt:

  [CLIENT / CUSTOMER ACCOUNT]
  - Email    : user@kriyaid.com
  - Password : User@123
  - Role     : User

  [EXECUTIVE ADMINISTRATOR ACCOUNT]
  - Email    : admin@kriyaid.com
  - Password : Admin@123
  - Role     : Admin
  - Portal   : Admin/AdminLogin.aspx

-----------------------------------------------------------------------------------
3. HOW TO OPEN & RUN IN VISUAL STUDIO 2022 (F5 ZERO SETUP)
-----------------------------------------------------------------------------------
1. Double-click the root solution file:
      e:\5BCA\ASP.NET\Kriya ID\KriyaID.sln
2. In Visual Studio 2022, set the startup project to "KriyaID".
3. Press F5 (or Ctrl+F5) to run in IIS Express.
4. The database is attached via SQL Server LocalDB automatically:
      App_Data\KriyaID.mdf
   Even on a fresh computer, Global.asax checks and auto-creates all 13 tables
   and inserts seed data if needed with ZERO manual setup.
5. If you prefer to inspect or run the SQL script in SSMS manually, the script
   is available at:
      Database\KriyaID.sql

-----------------------------------------------------------------------------------
4. COMPLETE END-TO-END DEMO WALKTHROUGH
-----------------------------------------------------------------------------------
Step 1: Splash Screen
  - Application starts at Default.aspx with an animated luxury logo mark.
  - Automatically redirects after exactly 3 seconds to Register.aspx.
  - (If already signed in, immediately skips splash to Home or Admin Dashboard).

Step 2: Registration & Sign In
  - Register.aspx provides client registration with input validators.
  - Or click "Login" and enter user@kriyaid.com / User@123.
  - Redirects to Home.aspx upon sign-in.

Step 3: Curated Collections Browsing & Filtering
  - Home.aspx showcases dynamic hero carousel from the Banners table, categories,
    new arrivals, signature bestsellers, and consultation CTA.
  - Navigate to Products.aspx to filter by:
      * Living Space Category & Subcategory
      * Price range (Min - Max ₹)
      * Star rating (4★ & above, 3★ & above)
      * Keyword search & Sorting (Price Low-High, High-Low, Newest)
      * ListView with DataPager pagination.

Step 4: Product Customization & Shopping Bag
  - Click any piece (e.g., Azure Serenity Sofa or Bouclé Sofa).
  - Inspect the 3-image photo gallery (click thumbnails to swap).
  - Select variant (e.g., King Size, Teak Finish, Velvet Tone) — price updates dynamically!
  - Adjust quantity and click "Add to Cart" (or save to "Wishlist").
  - Open Cart.aspx: adjust quantities, inspect subtotal and free shipping progress meter.

Step 5: Checkout & Atomic Order Placement
  - Click "Proceed to Checkout" (Checkout.aspx).
  - Delivery details prefill from user profile.
  - Select payment: "Cash on Delivery" or "Online Payment (Demo)".
  - Click "Place Order & Confirm Acquisition".
  - Executed inside an ADO.NET SQL Transaction:
      * Decrements stock in Products & ProductVariants
      * Empties user's CartItems
      * Inserts into Orders & OrderItems tables
  - Redirects to OrderSuccess.aspx with unique Order Reference (e.g., KID-20261018-XXXX).

Step 6: Visual Status Tracking & User Order Actions
  - Open MyOrders.aspx or click "Track Order Status" to view OrderDetails.aspx.
  - Shows visual status stepper: Placed -> Confirmed -> Shipped -> Delivered.
  - The client can cancel while Placed/Confirmed (cancelling restores stock).

Step 7: Admin Portal Fulfillment
  - Open Admin/AdminLogin.aspx (or sign out and enter admin credentials).
  - Sign in as admin@kriyaid.com / Admin@123.
  - Admin Dashboard.aspx displays:
      * Real-time KPI cards (Sales, Orders, Pending, Clients, Pieces, Low Stock)
      * Chart.js Doughnut Chart: Orders by Status
      * Chart.js Bar Chart: Sales Revenue trend (past 7 days)
      * Recent orders & low stock alerts
  - Open Orders.aspx -> click "Inspect & Fulfill" on the new order.
  - Click "Confirm Order" -> status becomes Confirmed.
  - Click "Mark as Shipped" -> status becomes Shipped.
  - Click "Mark as Delivered" -> status becomes Delivered, payment marks as Paid,
    and delivery timestamp is recorded.

Step 8: Verified Customer Appraisal / Review
  - Sign back in as user@kriyaid.com.
  - Open OrderDetails.aspx: the order displays "Delivered & Assembled" with delivery date.
  - Click "Leave an Appraisal / Review": select star rating (1-5), enter feedback,
    and submit review!

Step 9: Interior Design Consultation Leads
  - Visit BookDesigner.aspx on storefront to request a private consultation.
  - Admin can inspect, update (New -> Contacted -> Closed), and manage leads in
    Admin/Consultations.aspx.

-----------------------------------------------------------------------------------
5. TECHNICAL ARCHITECTURE & COMPLIANCE SUMMARY
-----------------------------------------------------------------------------------
  - Framework       : ASP.NET Web Forms (.NET Framework 4.8, C#)
  - Layouts         : Site.master, Admin.master, Plain.master
  - Data Access     : Plain ADO.NET (SqlConnection, SqlCommand, SqlDataAdapter,
                      SqlDataReader) with PARAMETERIZED queries ONLY.
  - Helper Class    : App_Code\DB.cs
  - Security        : Forms/Session auth, SHA256 with Salt, Role verification.
  - No Foreign Tech : NO MVC, NO Razor, NO Entity Framework, NO ASP.NET Identity,
                      NO .NET Core, NO Web API, and ZERO .json files.
  - UI Libraries    : Bootstrap 5, Bootstrap Icons, Chart.js, Google Fonts via CDN.
===================================================================================
