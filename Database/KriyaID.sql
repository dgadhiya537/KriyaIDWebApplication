-- =========================================================================
-- Kriya ID - Interior Designing & Luxury Furniture E-Commerce Database
-- Database Script: Tables Creation and Seed Data
-- =========================================================================

-- Create Database if not running inside an attached database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'KriyaID')
BEGIN
    -- Only run CREATE DATABASE if needed; when attached via App_Data\KriyaID.mdf, it is already current database
    PRINT 'Database context initialized';
END
GO

-- 1. Users Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
    CREATE TABLE Users (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        FullName NVARCHAR(150) NOT NULL,
        Email NVARCHAR(150) NOT NULL UNIQUE,
        Phone NVARCHAR(20) NULL,
        PasswordHash NVARCHAR(256) NOT NULL,
        Salt NVARCHAR(100) NOT NULL,
        Role NVARCHAR(50) NOT NULL DEFAULT 'User', -- 'User', 'Admin'
        IsBlocked BIT NOT NULL DEFAULT 0,
        Address NVARCHAR(255) NULL,
        City NVARCHAR(100) NULL,
        Pincode NVARCHAR(20) NULL,
        CreatedOn DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 2. Categories Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Categories')
BEGIN
    CREATE TABLE Categories (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(100) NOT NULL,
        Description NVARCHAR(500) NULL,
        ImageUrl NVARCHAR(300) NULL,
        IsActive BIT NOT NULL DEFAULT 1
    );
END
GO

-- 3. SubCategories Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SubCategories')
BEGIN
    CREATE TABLE SubCategories (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id) ON DELETE CASCADE,
        Name NVARCHAR(100) NOT NULL,
        Description NVARCHAR(500) NULL,
        ImageUrl NVARCHAR(300) NULL,
        IsActive BIT NOT NULL DEFAULT 1
    );
END
GO

-- 4. Products Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Products')
BEGIN
    CREATE TABLE Products (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        SubCategoryId INT NOT NULL FOREIGN KEY REFERENCES SubCategories(Id) ON DELETE CASCADE,
        Name NVARCHAR(200) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        Price DECIMAL(18,2) NOT NULL,
        DiscountPercent INT NOT NULL DEFAULT 0,
        Stock INT NOT NULL DEFAULT 10,
        IsFeatured BIT NOT NULL DEFAULT 0,
        CreatedOn DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 5. ProductImages Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductImages')
BEGIN
    CREATE TABLE ProductImages (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        ProductId INT NOT NULL FOREIGN KEY REFERENCES Products(Id) ON DELETE CASCADE,
        ImageUrl NVARCHAR(300) NOT NULL,
        IsPrimary BIT NOT NULL DEFAULT 0
    );
END
GO

-- 6. ProductVariants Table (sub-products: size/color/material with extra price)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductVariants')
BEGIN
    CREATE TABLE ProductVariants (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        ProductId INT NOT NULL FOREIGN KEY REFERENCES Products(Id) ON DELETE CASCADE,
        VariantName NVARCHAR(100) NOT NULL,
        VariantValue NVARCHAR(100) NOT NULL,
        AdditionalPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
        Stock INT NOT NULL DEFAULT 10
    );
END
GO

-- 7. CartItems Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CartItems')
BEGIN
    CREATE TABLE CartItems (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NOT NULL FOREIGN KEY REFERENCES Users(Id) ON DELETE CASCADE,
        ProductId INT NOT NULL FOREIGN KEY REFERENCES Products(Id) ON DELETE CASCADE,
        VariantId INT NULL FOREIGN KEY REFERENCES ProductVariants(Id) ON DELETE NO ACTION,
        Quantity INT NOT NULL DEFAULT 1,
        AddedOn DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 8. Wishlist Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Wishlist')
BEGIN
    CREATE TABLE Wishlist (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NOT NULL FOREIGN KEY REFERENCES Users(Id) ON DELETE CASCADE,
        ProductId INT NOT NULL FOREIGN KEY REFERENCES Products(Id) ON DELETE CASCADE,
        AddedOn DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT UQ_Wishlist_User_Product UNIQUE (UserId, ProductId)
    );
END
GO

-- 9. Orders Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Orders')
BEGIN
    CREATE TABLE Orders (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NOT NULL FOREIGN KEY REFERENCES Users(Id) ON DELETE CASCADE,
        OrderNumber NVARCHAR(50) NOT NULL UNIQUE,
        OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
        SubTotal DECIMAL(18,2) NOT NULL,
        ShippingFee DECIMAL(18,2) NOT NULL DEFAULT 0,
        TotalAmount DECIMAL(18,2) NOT NULL,
        PaymentMethod NVARCHAR(50) NOT NULL, -- 'Cash on Delivery', 'Online Payment (Demo)'
        PaymentStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Paid'
        OrderStatus NVARCHAR(50) NOT NULL DEFAULT 'Placed', -- 'Placed', 'Confirmed', 'Shipped', 'Delivered', 'Cancelled'
        ShippingName NVARCHAR(150) NOT NULL,
        ShippingPhone NVARCHAR(20) NOT NULL,
        ShippingAddress NVARCHAR(255) NOT NULL,
        ShippingCity NVARCHAR(100) NOT NULL,
        ShippingPincode NVARCHAR(20) NOT NULL,
        DeliveredDate DATETIME NULL
    );
END
GO

-- 10. OrderItems Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderItems')
BEGIN
    CREATE TABLE OrderItems (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        OrderId INT NOT NULL FOREIGN KEY REFERENCES Orders(Id) ON DELETE CASCADE,
        ProductId INT NOT NULL,
        VariantId INT NULL,
        Quantity INT NOT NULL,
        UnitPrice DECIMAL(18,2) NOT NULL,
        TotalPrice DECIMAL(18,2) NOT NULL,
        CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductId) REFERENCES Products(Id) ON DELETE NO ACTION,
        CONSTRAINT FK_OrderItems_Variants FOREIGN KEY (VariantId) REFERENCES ProductVariants(Id) ON DELETE NO ACTION
    );
END
GO

-- 11. Reviews Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Reviews')
BEGIN
    CREATE TABLE Reviews (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NOT NULL FOREIGN KEY REFERENCES Users(Id) ON DELETE CASCADE,
        ProductId INT NOT NULL FOREIGN KEY REFERENCES Products(Id) ON DELETE CASCADE,
        Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
        Comment NVARCHAR(1000) NULL,
        CreatedOn DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 12. Consultations Table ("Book a Designer")
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Consultations')
BEGIN
    CREATE TABLE Consultations (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(150) NOT NULL,
        Phone NVARCHAR(20) NOT NULL,
        Email NVARCHAR(150) NOT NULL,
        RoomType NVARCHAR(100) NOT NULL,
        Budget NVARCHAR(100) NOT NULL,
        Message NVARCHAR(MAX) NULL,
        Status NVARCHAR(50) NOT NULL DEFAULT 'New', -- 'New', 'Contacted', 'Closed'
        CreatedOn DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 13. Banners Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Banners')
BEGIN
    CREATE TABLE Banners (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Title NVARCHAR(150) NOT NULL,
        Subtitle NVARCHAR(250) NULL,
        ImageUrl NVARCHAR(300) NOT NULL,
        LinkUrl NVARCHAR(300) NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        DisplayOrder INT NOT NULL DEFAULT 0
    );
END
GO

-- =========================================================================
-- SEED DATA
-- =========================================================================

-- Seed Users
IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'admin@kriyaid.com')
BEGIN
    INSERT INTO Users (FullName, Email, Phone, PasswordHash, Salt, Role, IsBlocked, Address, City, Pincode)
    VALUES ('kriyaid', 'admin@kriyaid.com', '+91 98765 00001', 'uTbEuNAjnkN8p8/8nflDhtQ2yobQvNuKw+eEsW1hNRo=', 'S3JpeWFJRF9TYWx0XzIwMjZfQWRtaW4=', 'Admin', 0, '101, Luxury Boulevard, Design District', 'Ahmedabad', '380015');
END

IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'tanvee@kriyaid.com')
BEGIN
    INSERT INTO Users (FullName, Email, Phone, PasswordHash, Salt, Role, IsBlocked, Address, City, Pincode)
    VALUES ('Tanvee', 'tanvee@kriyaid.com', '+91 98765 11112', 'DXBqdiD/l2ziJmXzo9F1V+TSJdDQ//pUlTvQAO8Fzwo=', 'S3JpeWFJRF9TYWx0XzIwMjZfVXNlcg==', 'User', 0, '402, Elegance Heights, Satellite Road', 'Ahmedabad', '380015');
END

IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'diyagadhiya06@gmail.com')
BEGIN
    INSERT INTO Users (FullName, Email, Phone, PasswordHash, Salt, Role, IsBlocked, Address, City, Pincode)
    VALUES ('Diya', 'diyagadhiya06@gmail.com', '+91 73595 90850', '3IzPcSWunWs0dMvp3c/2c+WB1pV8FZoCyxk25vH7qnE=', 'nm69u7XxyviXKEUFI6Dncg==', 'User', 0, 'Jetpur', 'Rajkot', '360370');
END
GO

-- Seed Categories
IF NOT EXISTS (SELECT 1 FROM Categories WHERE Name = 'Living Room')
BEGIN
    INSERT INTO Categories (Name, Description, ImageUrl, IsActive)
    VALUES 
    ('Living Room', 'Bespoke sofas, sculptural accent chairs, and handcrafted coffee tables designed for intimate gathering.', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80', 1),
    ('Bedroom', 'Serene sanctuary suites featuring artisan beds, upholstered headboards, and soothing nightstands.', 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80', 1),
    ('Kitchen & Dining', 'Sculpted marble & teak dining sets, ergonomic bar seating, and minimalist cabinetry.', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=800&q=80', 1),
    ('Lighting', 'Architectural chandeliers, ambient brass pendants, and Italian marble base floor lamps.', 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=800&q=80', 1),
    ('Art & Decor', 'Curated ceramic pottery, textured woven rugs, and abstract bronze wall art.', 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?auto=format&fit=crop&w=800&q=80', 1);
END
GO

-- Seed SubCategories
IF NOT EXISTS (SELECT 1 FROM SubCategories)
BEGIN
    -- Living Room (Id: 1)
    INSERT INTO SubCategories (CategoryId, Name, Description, ImageUrl, IsActive) VALUES
    (1, 'Luxury Sofas', 'Deep-seated linen and velvet sectional sofas.', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80', 1),
    (1, 'Accent Chairs', 'Sculptural lounge chairs with brushed brass and bouclé finishes.', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=600&q=80', 1),
    (1, 'Coffee Tables', 'Travertine, smoked glass, and solid walnut statement coffee tables.', 'https://images.unsplash.com/photo-1533090161767-e6ffed986b88?auto=format&fit=crop&w=600&q=80', 1);

    -- Bedroom (Id: 2)
    INSERT INTO SubCategories (CategoryId, Name, Description, ImageUrl, IsActive) VALUES
    (2, 'Designer Beds', 'Platform beds crafted in oak and plush upholstered linen headboards.', 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=600&q=80', 1),
    (2, 'Nightstands', 'Minimalist side tables with fluted timber drawers and marble tops.', 'https://images.unsplash.com/photo-1532323544230-7191fd51bc1b?auto=format&fit=crop&w=600&q=80', 1),
    (2, 'Wardrobes & Dressers', 'Walk-in modules with integrated LED illumination and smoked glass doors.', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=600&q=80', 1);

    -- Kitchen & Dining (Id: 3)
    INSERT INTO SubCategories (CategoryId, Name, Description, ImageUrl, IsActive) VALUES
    (3, 'Dining Tables', 'Extendable walnut and Italian Calacatta marble dining tables.', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=600&q=80', 1),
    (3, 'Dining Chairs', 'Ergonomic upholstered dining seating in deep ocean velvet and woven cane.', 'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=600&q=80', 1),
    (3, 'Bar Stools', 'Counter-height barstools with tailored leather seats.', 'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=600&q=80', 1);

    -- Lighting (Id: 4)
    INSERT INTO SubCategories (CategoryId, Name, Description, ImageUrl, IsActive) VALUES
    (4, 'Chandeliers', 'Sculptural brass and blown opal glass celestial chandeliers.', 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=600&q=80', 1),
    (4, 'Pendant Lights', 'Artisan hand-hammered brass and ceramic pendant drops.', 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?auto=format&fit=crop&w=600&q=80', 1),
    (4, 'Floor & Table Lamps', 'Brushed brass floor lamps and travertine base table accents.', 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=600&q=80', 1);

    -- Art & Decor (Id: 5)
    INSERT INTO SubCategories (CategoryId, Name, Description, ImageUrl, IsActive) VALUES
    (5, 'Sculptural Vases', 'Hand-thrown terracotta and matte stoneware vessels.', 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?auto=format&fit=crop&w=600&q=80', 1),
    (5, 'Artisan Rugs', 'Hand-knotted wool and organic silk statement area rugs.', 'https://images.unsplash.com/photo-1600121848594-d8644e57abab?auto=format&fit=crop&w=600&q=80', 1),
    (5, 'Wall Mirrors', 'Organic asymmetrical brass-framed focal wall mirrors.', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=600&q=80', 1);
END
GO

-- Seed 20+ Products
IF NOT EXISTS (SELECT 1 FROM Products)
BEGIN
    -- Product 1: The Azure Serenity 3-Seater Sofa
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (1, 'Azure Serenity 3-Seater Sofa', 'Engineered with kiln-dried teak wood framing and wrapped in Belgian deep ocean velvet. Featuring dual-density memory foam cushioning for unprecedented luxury and lasting relaxation.', 48999.00, 15, 12, 1);

    -- Product 2: Nordic Minimalist Curved Bouclé Sofa
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (1, 'Nordic Minimalist Curved Bouclé Sofa', 'A sculptural statement sofa tailored with plush warm-cream bouclé fabric and rounded architectural silhouettes, blending modern Scandinavian style with bespoke comfort.', 62500.00, 10, 8, 1);

    -- Product 3: Aurelia Brushed Brass Lounge Armchair
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (2, 'Aurelia Brushed Brass Lounge Armchair', 'A signature conversational accent chair featuring a solid satin-brass electroplated frame and hand-stitched premium cognac saddle leather cushions.', 27500.00, 12, 15, 1);

    -- Product 4: Solis Swivel Occasional Chair
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (2, 'Solis Swivel Occasional Chair', '360-degree silent bearing swivel lounge chair draped in warm beige textured chenille. Ideal for sunrooms and master suites.', 21999.00, 0, 10, 0);

    -- Product 5: Tivoli Travertine & Smoked Glass Coffee Table
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (3, 'Tivoli Travertine & Smoked Glass Coffee Table', 'Raw unfilled Italian travertine stone pedestal paired with a 12mm beveled tempered smoked glass top. Each natural stone base has unique organic veins.', 34500.00, 20, 6, 1);

    -- Product 6: Artisan Fluted Walnut Center Table
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (3, 'Artisan Fluted Walnut Center Table', 'Hand-routed fluted solid American walnut drum coffee table with hidden dual touch-latch storage drawers.', 28900.00, 5, 9, 0);

    -- Product 7: Celestia Floating Platform King Bed
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (4, 'Celestia Floating Platform King Bed', 'Architectural floating platform bed with ambient under-rail LED glow, upholstered headboard in deep ocean woven linen, and solid white oak rails.', 58000.00, 10, 7, 1);

    -- Product 8: Elysian Upholstered Wingback Bed
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (4, 'Elysian Upholstered Wingback Bed', 'Grand wingback designer bed featuring hand-tufted channel detailing and ultra-soft beige fabric finish. Built on a reinforced steel slat foundation.', 52000.00, 15, 10, 0);

    -- Product 9: Verona Fluted Oak Nightstand
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (5, 'Verona Fluted Oak Nightstand', 'Solid white oak bedside table featuring smooth soft-close drawer slides, brass pulls, and an inset natural Carrara marble top.', 14500.00, 0, 18, 0);

    -- Product 10: Mirage Tinted Glass Bedside Table
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (5, 'Mirage Tinted Glass Bedside Table', 'Champagne bronze metal frame supporting a fluted bronze glass tier and walnut drawer for sophisticated nighttime essentials.', 11999.00, 8, 14, 0);

    -- Product 11: Atelier 6-Drawer Modern Dresser
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (6, 'Atelier 6-Drawer Modern Dresser', 'Substantial storage credenza crafted from bleached oak veneer with brushed deep ocean lacquer trim and soft-close German runners.', 39900.00, 10, 5, 0);

    -- Product 12: Calacatta Gold Marble Dining Table
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (7, 'Calacatta Gold Marble Dining Table', 'Showcasing a 6-seater solid engineered Calacatta gold composite marble tabletop resting atop sculptural fluted cylindrical pedestals.', 74999.00, 18, 4, 1);

    -- Product 13: Kyoto Live-Edge Teak Dining Table
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (7, 'Kyoto Live-Edge Teak Dining Table', 'Single-slab sustainable Burma teak dining table with natural live edge contours, protected with a natural matte hardwax oil.', 68000.00, 12, 6, 0);

    -- Product 14: Ravenna Cane & Velvet Dining Chair (Set of 2)
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (8, 'Ravenna Cane & Velvet Dining Chair (Set of 2)', 'Mid-century silhouette with hand-woven French cane backrest and rich deep ocean velvet padded seat cushions on ebonized ash wood legs.', 19500.00, 5, 16, 1);

    -- Product 15: Milo Brass Accent Bar Stool
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (9, 'Milo Brass Accent Bar Stool', 'Modern counter stool with footrest ring, contoured high-density seat in oatmeal beige fabric, and electroplated matte brass legs.', 9800.00, 0, 20, 0);

    -- Product 16: Cosmos 12-Light Constellation Chandelier
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (10, 'Cosmos 12-Light Constellation Chandelier', 'Statement branching ceiling fixture with hand-blown frosted glass globes and adjustable satin-brass arms for customized illumination.', 36000.00, 25, 8, 1);

    -- Product 17: Halcyon Ceramic Tiered Pendant Light
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (11, 'Halcyon Ceramic Tiered Pendant Light', 'Artisan-crafted ceramic pendant light with subtle textured ribbed finish, casting a warm diffused glow over kitchen islands or dining tables.', 8500.00, 0, 25, 0);

    -- Product 18: Lusso Arc Brass Floor Lamp with Marble Base
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (12, 'Lusso Arc Brass Floor Lamp with Marble Base', 'Dramatic sweeping brass arc lamp weighted by a 35kg polished black Marquina marble base with integrated touch dimmer switch.', 18900.00, 15, 11, 1);

    -- Product 19: Terra Ribbed Stoneware Vase Trio
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (13, 'Terra Ribbed Stoneware Vase Trio', 'A set of three sculptural textured stoneware ceramic vases in harmonizing tones of Cream, Warm Beige, and Deep Ocean glaze.', 4999.00, 10, 30, 0);

    -- Product 20: Kasbah Hand-Knotted High-Pile Wool Rug
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (14, 'Kasbah Hand-Knotted High-Pile Wool Rug', '100% New Zealand hand-spun virgin wool rug featuring geometric line work inspired by Berber architectural motifs. Ultra-plush 30mm pile.', 29500.00, 20, 9, 1);

    -- Product 21: Solstice Brass Asymmetric Wall Mirror
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (15, 'Solstice Brass Asymmetric Wall Mirror', 'Beveled organic droplet wall mirror encased in a 1-inch deep solid forged brass rim. Can be mounted in four unique orientations.', 12500.00, 0, 14, 1);

    -- Product 22: Nova Smoked Glass Table Lamp
    INSERT INTO Products (SubCategoryId, Name, Description, Price, DiscountPercent, Stock, IsFeatured)
    VALUES (12, 'Nova Smoked Glass Table Lamp', 'Cylindrical blown smoked glass lamp body with warm amber LED filament bulb and brushed brass top dial.', 6800.00, 10, 22, 0);
END
GO

-- Seed Product Images (At least 3 images per product)
IF NOT EXISTS (SELECT 1 FROM ProductImages)
BEGIN
    -- Product 1 (Azure Serenity Sofa)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (1, 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80', 1),
    (1, 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=800&q=80', 0),
    (1, 'https://images.unsplash.com/photo-1540574163026-643ea20ade25?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 2 (Bouclé Sofa)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (2, 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=800&q=80', 1),
    (2, 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80', 0),
    (2, 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 3 (Aurelia Armchair)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (3, 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=800&q=80', 1),
    (3, 'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=800&q=80', 0),
    (3, 'https://images.unsplash.com/photo-1580481077190-73614591e80d?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 4 (Solis Swivel Chair)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (4, 'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=800&q=80', 1),
    (4, 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=800&q=80', 0),
    (4, 'https://images.unsplash.com/photo-1580481077190-73614591e80d?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 5 (Tivoli Coffee Table)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (5, 'https://images.unsplash.com/photo-1533090161767-e6ffed986b88?auto=format&fit=crop&w=800&q=80', 1),
    (5, 'https://images.unsplash.com/photo-1532323544230-7191fd51bc1b?auto=format&fit=crop&w=800&q=80', 0),
    (5, 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 6 (Walnut Center Table)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (6, 'https://images.unsplash.com/photo-1532323544230-7191fd51bc1b?auto=format&fit=crop&w=800&q=80', 1),
    (6, 'https://images.unsplash.com/photo-1533090161767-e6ffed986b88?auto=format&fit=crop&w=800&q=80', 0),
    (6, 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 7 (Celestia Floating Bed)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (7, 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80', 1),
    (7, 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=800&q=80', 0),
    (7, 'https://images.unsplash.com/photo-1540518614846-7ede433c4b49?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 8 (Elysian Wingback Bed)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (8, 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=800&q=80', 1),
    (8, 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80', 0),
    (8, 'https://images.unsplash.com/photo-1540518614846-7ede433c4b49?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 9 (Verona Oak Nightstand)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (9, 'https://images.unsplash.com/photo-1532323544230-7191fd51bc1b?auto=format&fit=crop&w=800&q=80', 1),
    (9, 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=800&q=80', 0),
    (9, 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 10 (Mirage Glass Nightstand)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (10, 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=800&q=80', 1),
    (10, 'https://images.unsplash.com/photo-1532323544230-7191fd51bc1b?auto=format&fit=crop&w=800&q=80', 0),
    (10, 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 11 (Atelier Dresser)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (11, 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=800&q=80', 1),
    (11, 'https://images.unsplash.com/photo-1532323544230-7191fd51bc1b?auto=format&fit=crop&w=800&q=80', 0),
    (11, 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 12 (Calacatta Marble Dining Table)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (12, 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=800&q=80', 1),
    (12, 'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=800&q=80', 0),
    (12, 'https://images.unsplash.com/photo-1533090161767-e6ffed986b88?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 13 (Kyoto Teak Table)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (13, 'https://images.unsplash.com/photo-1533090161767-e6ffed986b88?auto=format&fit=crop&w=800&q=80', 1),
    (13, 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=800&q=80', 0),
    (13, 'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 14 (Ravenna Chairs)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (14, 'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=800&q=80', 1),
    (14, 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=800&q=80', 0),
    (14, 'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 15 (Milo Bar Stool)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (15, 'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=800&q=80', 1),
    (15, 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=800&q=80', 0),
    (15, 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 16 (Cosmos Chandelier)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (16, 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=800&q=80', 1),
    (16, 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?auto=format&fit=crop&w=800&q=80', 0),
    (16, 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 17 (Halcyon Pendant Light)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (17, 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?auto=format&fit=crop&w=800&q=80', 1),
    (17, 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=800&q=80', 0),
    (17, 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 18 (Lusso Floor Lamp)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (18, 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=800&q=80', 1),
    (18, 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=800&q=80', 0),
    (18, 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 19 (Terra Vase Trio)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (19, 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?auto=format&fit=crop&w=800&q=80', 1),
    (19, 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=800&q=80', 0),
    (19, 'https://images.unsplash.com/photo-1600121848594-d8644e57abab?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 20 (Kasbah Wool Rug)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (20, 'https://images.unsplash.com/photo-1600121848594-d8644e57abab?auto=format&fit=crop&w=800&q=80', 1),
    (20, 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=800&q=80', 0),
    (20, 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 21 (Solstice Wall Mirror)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (21, 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=800&q=80', 1),
    (21, 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?auto=format&fit=crop&w=800&q=80', 0),
    (21, 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80', 0);

    -- Product 22 (Nova Table Lamp)
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary) VALUES
    (22, 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=800&q=80', 1),
    (22, 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=800&q=80', 0),
    (22, 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?auto=format&fit=crop&w=800&q=80', 0);
END
GO

-- Seed ProductVariants (Variants for size / color / material with extra price)
IF NOT EXISTS (SELECT 1 FROM ProductVariants)
BEGIN
    -- Product 1 Variants
    INSERT INTO ProductVariants (ProductId, VariantName, VariantValue, AdditionalPrice, Stock) VALUES
    (1, 'Fabric / Finish', 'Deep Ocean Velvet', 0.00, 8),
    (1, 'Fabric / Finish', 'Warm Cream Bouclé', 2500.00, 4);

    -- Product 2 Variants
    INSERT INTO ProductVariants (ProductId, VariantName, VariantValue, AdditionalPrice, Stock) VALUES
    (2, 'Configuration', '3-Seater (86 Inch)', 0.00, 5),
    (2, 'Configuration', '4-Seater Curved Sectional (102 Inch)', 8500.00, 3);

    -- Product 3 Variants
    INSERT INTO ProductVariants (ProductId, VariantName, VariantValue, AdditionalPrice, Stock) VALUES
    (3, 'Leather Tone', 'Cognac Tan Saddle', 0.00, 10),
    (3, 'Leather Tone', 'Noir Onyx Leather', 1800.00, 5);

    -- Product 5 Variants
    INSERT INTO ProductVariants (ProductId, VariantName, VariantValue, AdditionalPrice, Stock) VALUES
    (5, 'Size & Shape', 'Round (36" Dia)', 0.00, 3),
    (5, 'Size & Shape', 'Oval (48" x 24")', 3200.00, 3);

    -- Product 7 Variants
    INSERT INTO ProductVariants (ProductId, VariantName, VariantValue, AdditionalPrice, Stock) VALUES
    (7, 'Bed Dimension', 'Queen Size (60x78 in)', 0.00, 4),
    (7, 'Bed Dimension', 'King Size (72x78 in)', 4500.00, 3);

    -- Product 12 Variants
    INSERT INTO ProductVariants (ProductId, VariantName, VariantValue, AdditionalPrice, Stock) VALUES
    (12, 'Seating Capacity', '6-Seater (72 x 36 in)', 0.00, 2),
    (12, 'Seating Capacity', '8-Seater (96 x 42 in)', 12000.00, 2);

    -- Product 16 Variants
    INSERT INTO ProductVariants (ProductId, VariantName, VariantValue, AdditionalPrice, Stock) VALUES
    (16, 'Finish', 'Brushed Satin Brass', 0.00, 5),
    (16, 'Finish', 'Matte Architectural Black', 1500.00, 3);

    -- Product 20 Variants
    INSERT INTO ProductVariants (ProductId, VariantName, VariantValue, AdditionalPrice, Stock) VALUES
    (20, 'Dimensions', '5 ft x 8 ft', 0.00, 5),
    (20, 'Dimensions', '8 ft x 10 ft', 8500.00, 4);
END
GO

-- Seed Reviews
IF NOT EXISTS (SELECT 1 FROM Reviews)
BEGIN
    INSERT INTO Reviews (UserId, ProductId, Rating, Comment, CreatedOn) VALUES
    (2, 1, 5, 'Exceptional craftsmanship! The deep ocean velvet color matches our living room wall perfectly. Worth every rupee.', DATEADD(day, -10, GETDATE())),
    (2, 5, 5, 'The travertine stone base is genuinely solid and heavy. Truly an architectural centerpiece.', DATEADD(day, -7, GETDATE())),
    (2, 16, 4, 'Breathtaking illumination. All our guests complimented the constellation chandelier!', DATEADD(day, -4, GETDATE())),
    (2, 21, 5, 'Heavy brass frame, distortion-free reflection. Elegant and timeless design.', DATEADD(day, -2, GETDATE()));
END
GO

-- Seed Banners
IF NOT EXISTS (SELECT 1 FROM Banners)
BEGIN
    INSERT INTO Banners (Title, Subtitle, ImageUrl, LinkUrl, IsActive, DisplayOrder) VALUES
    ('Curated Living Spaces', 'Immerse in timeless elegance with our new Autumn architectural collection.', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1600&q=80', 'Products.aspx?cat=1', 1, 1),
    ('Sanctuaries of Serenity', 'Handcrafted master bedroom suites built with sustainable hardwoods and Italian linen.', 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1600&q=80', 'Products.aspx?cat=2', 1, 2),
    ('Architectural Luminescence', 'Sculptural brass lighting designed to evoke emotion and refine every angle.', 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&w=1600&q=80', 'Products.aspx?cat=4', 1, 3);
END
GO

-- Seed Sample Orders (for demo user)
IF NOT EXISTS (SELECT 1 FROM Orders)
BEGIN
    -- Order 1: Delivered
    INSERT INTO Orders (UserId, OrderNumber, OrderDate, SubTotal, ShippingFee, TotalAmount, PaymentMethod, PaymentStatus, OrderStatus, ShippingName, ShippingPhone, ShippingAddress, ShippingCity, ShippingPincode, DeliveredDate)
    VALUES (2, 'KID-20261001-8821', DATEADD(day, -15, GETDATE()), 48999.00, 0.00, 48999.00, 'Online Payment (Demo)', 'Paid', 'Delivered', 'Aarav Patel', '+91 98765 11112', '402, Elegance Heights, Satellite Road', 'Ahmedabad', '380015', DATEADD(day, -10, GETDATE()));

    DECLARE @Ord1Id INT = SCOPE_IDENTITY();
    INSERT INTO OrderItems (OrderId, ProductId, VariantId, Quantity, UnitPrice, TotalPrice)
    VALUES (@Ord1Id, 1, 1, 1, 48999.00, 48999.00);

    -- Order 2: Placed
    INSERT INTO Orders (UserId, OrderNumber, OrderDate, SubTotal, ShippingFee, TotalAmount, PaymentMethod, PaymentStatus, OrderStatus, ShippingName, ShippingPhone, ShippingAddress, ShippingCity, ShippingPincode, DeliveredDate)
    VALUES (2, 'KID-20261018-9342', DATEADD(hour, -2, GETDATE()), 27500.00, 0.00, 27500.00, 'Cash on Delivery', 'Pending', 'Placed', 'Aarav Patel', '+91 98765 11112', '402, Elegance Heights, Satellite Road', 'Ahmedabad', '380015', NULL);

    DECLARE @Ord2Id INT = SCOPE_IDENTITY();
    INSERT INTO OrderItems (OrderId, ProductId, VariantId, Quantity, UnitPrice, TotalPrice)
    VALUES (@Ord2Id, 3, 3, 1, 27500.00, 27500.00);
END
GO

-- Seed Sample Consultations
IF NOT EXISTS (SELECT 1 FROM Consultations)
BEGIN
    INSERT INTO Consultations (Name, Phone, Email, RoomType, Budget, Message, Status, CreatedOn) VALUES
    ('Sneha Sharma', '+91 98989 12345', 'sneha@example.com', 'Full Home Interior', '₹15 Lakh - ₹25 Lakh', 'Looking for a warm minimalist redesign of our 3BHK penthouse in Bodakdev with emphasis on deep ocean blue and cream accents.', 'New', DATEADD(day, -2, GETDATE())),
    ('Rohan Mehta', '+91 97234 56789', 'rohan.m@example.com', 'Living Room', '₹5 Lakh - ₹10 Lakh', 'Require bespoke fluted wall paneling, modular lighting setup and a comfortable 6-seater sofa arrangement.', 'Contacted', DATEADD(day, -5, GETDATE()));
END
GO
