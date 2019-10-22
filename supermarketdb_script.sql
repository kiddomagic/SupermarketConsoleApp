USE [master]
GO
/****** Object:  Database [SupermarketDB]    Script Date: 10/22/2019 1:53:14 PM ******/
CREATE DATABASE [SupermarketDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SupermarketDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\SupermarketDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SupermarketDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\SupermarketDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [SupermarketDB] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SupermarketDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SupermarketDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SupermarketDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SupermarketDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SupermarketDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SupermarketDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [SupermarketDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SupermarketDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SupermarketDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SupermarketDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SupermarketDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SupermarketDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SupermarketDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SupermarketDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SupermarketDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SupermarketDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SupermarketDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SupermarketDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SupermarketDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SupermarketDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SupermarketDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SupermarketDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SupermarketDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SupermarketDB] SET RECOVERY FULL 
GO
ALTER DATABASE [SupermarketDB] SET  MULTI_USER 
GO
ALTER DATABASE [SupermarketDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SupermarketDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SupermarketDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SupermarketDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SupermarketDB] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'SupermarketDB', N'ON'
GO
ALTER DATABASE [SupermarketDB] SET QUERY_STORE = OFF
GO
USE [SupermarketDB]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 10/22/2019 1:53:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[No] [int] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[TotalPrice] [int] NOT NULL,
	[Membership] [bit] NOT NULL,
	[ProductSale] [bit] NOT NULL,
	[VegiePromotion] [bit] NOT NULL,
	[OtherPromotion] [bit] NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[No] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItem]    Script Date: 10/22/2019 1:53:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItem](
	[OrdItemNo] [int] NOT NULL,
	[ItemId] [nchar](10) NOT NULL,
	[Price] [int] NOT NULL,
	[OrderNo] [int] NOT NULL,
 CONSTRAINT [PK_OrderItem] PRIMARY KEY CLUSTERED 
(
	[OrdItemNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 10/22/2019 1:53:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ProductCode] [nchar](10) NOT NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[TypeId] [int] NOT NULL,
	[Price] [int] NOT NULL,
	[Unit] [nchar](10) NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductType]    Script Date: 10/22/2019 1:53:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductType](
	[Id] [int] NOT NULL,
	[ProductType] [nchar](30) NOT NULL,
	[IdentificationType] [nchar](10) NOT NULL,
 CONSTRAINT [PK_ProductType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Promotion]    Script Date: 10/22/2019 1:53:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Promotion](
	[Id] [int] NOT NULL,
	[TypeId] [int] NOT NULL,
	[ProductCode] [nchar](10) NOT NULL,
	[RequiredQuantity] [int] NULL,
	[QuantityDiscount] [int] NULL,
	[SalePercent] [int] NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
 CONSTRAINT [PK_Promotion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PromotionType]    Script Date: 10/22/2019 1:53:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PromotionType](
	[Id] [int] NOT NULL,
	[PromotionType] [nvarchar](200) NULL,
 CONSTRAINT [PK_PromotionType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Order] ([No], [DateTime], [TotalPrice], [Membership], [ProductSale], [VegiePromotion], [OtherPromotion]) VALUES (400001, CAST(N'2019-10-22T11:27:35.030' AS DateTime), 18622, 1, 0, 1, 0)
INSERT [dbo].[Order] ([No], [DateTime], [TotalPrice], [Membership], [ProductSale], [VegiePromotion], [OtherPromotion]) VALUES (400002, CAST(N'2019-10-22T11:28:33.780' AS DateTime), 32000, 0, 0, 0, 0)
INSERT [dbo].[Order] ([No], [DateTime], [TotalPrice], [Membership], [ProductSale], [VegiePromotion], [OtherPromotion]) VALUES (400003, CAST(N'2019-10-22T11:30:13.200' AS DateTime), 168000, 0, 0, 0, 0)
INSERT [dbo].[Order] ([No], [DateTime], [TotalPrice], [Membership], [ProductSale], [VegiePromotion], [OtherPromotion]) VALUES (400004, CAST(N'2019-10-22T11:30:46.027' AS DateTime), 254468, 1, 1, 1, 1)
INSERT [dbo].[Order] ([No], [DateTime], [TotalPrice], [Membership], [ProductSale], [VegiePromotion], [OtherPromotion]) VALUES (400005, CAST(N'2019-10-22T11:32:58.820' AS DateTime), 128000, 0, 0, 0, 1)
INSERT [dbo].[Order] ([No], [DateTime], [TotalPrice], [Membership], [ProductSale], [VegiePromotion], [OtherPromotion]) VALUES (400006, CAST(N'2019-10-22T11:46:42.010' AS DateTime), 160000, 0, 1, 0, 0)
INSERT [dbo].[Order] ([No], [DateTime], [TotalPrice], [Membership], [ProductSale], [VegiePromotion], [OtherPromotion]) VALUES (400007, CAST(N'2019-10-22T11:47:26.290' AS DateTime), 230400, 1, 1, 0, 1)
INSERT [dbo].[OrderItem] ([OrdItemNo], [ItemId], [Price], [OrderNo]) VALUES (400001001, N'V1        ', 20900, 400001)
INSERT [dbo].[OrderItem] ([OrdItemNo], [ItemId], [Price], [OrderNo]) VALUES (400002001, N'H1        ', 32000, 400002)
INSERT [dbo].[OrderItem] ([OrdItemNo], [ItemId], [Price], [OrderNo]) VALUES (400003001, N'H1        ', 32000, 400003)
INSERT [dbo].[OrderItem] ([OrdItemNo], [ItemId], [Price], [OrderNo]) VALUES (400003002, N'H2        ', 136000, 400003)
INSERT [dbo].[OrderItem] ([OrdItemNo], [ItemId], [Price], [OrderNo]) VALUES (400004001, N'H1        ', 128000, 400004)
INSERT [dbo].[OrderItem] ([OrdItemNo], [ItemId], [Price], [OrderNo]) VALUES (400004002, N'V2        ', 38123, 400004)
INSERT [dbo].[OrderItem] ([OrdItemNo], [ItemId], [Price], [OrderNo]) VALUES (400004003, N'M1        ', 80000, 400004)
INSERT [dbo].[OrderItem] ([OrdItemNo], [ItemId], [Price], [OrderNo]) VALUES (400004004, N'H3        ', 37000, 400004)
INSERT [dbo].[OrderItem] ([OrdItemNo], [ItemId], [Price], [OrderNo]) VALUES (400005001, N'H1        ', 128000, 400005)
INSERT [dbo].[OrderItem] ([OrdItemNo], [ItemId], [Price], [OrderNo]) VALUES (400006001, N'M1        ', 160000, 400006)
INSERT [dbo].[OrderItem] ([OrdItemNo], [ItemId], [Price], [OrderNo]) VALUES (400007001, N'M1        ', 160000, 400007)
INSERT [dbo].[OrderItem] ([OrdItemNo], [ItemId], [Price], [OrderNo]) VALUES (400007002, N'H1        ', 96000, 400007)
INSERT [dbo].[Product] ([ProductCode], [ProductName], [TypeId], [Price], [Unit]) VALUES (N'H1        ', N'Bowl', 3, 32000, N'unit      ')
INSERT [dbo].[Product] ([ProductCode], [ProductName], [TypeId], [Price], [Unit]) VALUES (N'H2        ', N'Pan', 3, 68000, N'unit      ')
INSERT [dbo].[Product] ([ProductCode], [ProductName], [TypeId], [Price], [Unit]) VALUES (N'H3        ', N'Chopstick', 3, 37000, N'unit      ')
INSERT [dbo].[Product] ([ProductCode], [ProductName], [TypeId], [Price], [Unit]) VALUES (N'M1        ', N'Beef', 1, 200000, N'kg        ')
INSERT [dbo].[Product] ([ProductCode], [ProductName], [TypeId], [Price], [Unit]) VALUES (N'M2        ', N'Chicken', 1, 140000, N'kg        ')
INSERT [dbo].[Product] ([ProductCode], [ProductName], [TypeId], [Price], [Unit]) VALUES (N'M3        ', N'Pork', 1, 90000, N'kg        ')
INSERT [dbo].[Product] ([ProductCode], [ProductName], [TypeId], [Price], [Unit]) VALUES (N'V1        ', N'Tomato', 2, 20900, N'kg        ')
INSERT [dbo].[Product] ([ProductCode], [ProductName], [TypeId], [Price], [Unit]) VALUES (N'V2        ', N'Potato', 2, 29900, N'kg        ')
INSERT [dbo].[Product] ([ProductCode], [ProductName], [TypeId], [Price], [Unit]) VALUES (N'V3        ', N'Bean sprouts', 2, 10000, N'kg        ')
INSERT [dbo].[ProductType] ([Id], [ProductType], [IdentificationType]) VALUES (1, N'Meat                          ', N'M         ')
INSERT [dbo].[ProductType] ([Id], [ProductType], [IdentificationType]) VALUES (2, N'Vegie                         ', N'V         ')
INSERT [dbo].[ProductType] ([Id], [ProductType], [IdentificationType]) VALUES (3, N'Household items               ', N'H         ')
INSERT [dbo].[Promotion] ([Id], [TypeId], [ProductCode], [RequiredQuantity], [QuantityDiscount], [SalePercent], [StartDate], [EndDate]) VALUES (1, 1, N'H1        ', 2, 1, 0, CAST(N'2019-10-21' AS Date), CAST(N'2019-11-18' AS Date))
INSERT [dbo].[Promotion] ([Id], [TypeId], [ProductCode], [RequiredQuantity], [QuantityDiscount], [SalePercent], [StartDate], [EndDate]) VALUES (2, 2, N'V2        ', 0, 0, 15, CAST(N'2019-10-21' AS Date), CAST(N'2019-11-18' AS Date))
INSERT [dbo].[Promotion] ([Id], [TypeId], [ProductCode], [RequiredQuantity], [QuantityDiscount], [SalePercent], [StartDate], [EndDate]) VALUES (3, 2, N'M1        ', 0, 0, 20, CAST(N'2019-10-22' AS Date), CAST(N'2019-11-19' AS Date))
INSERT [dbo].[PromotionType] ([Id], [PromotionType]) VALUES (1, N'Buy X Get Y')
INSERT [dbo].[PromotionType] ([Id], [PromotionType]) VALUES (2, N'Sale X%')
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_Order] FOREIGN KEY([OrderNo])
REFERENCES [dbo].[Order] ([No])
GO
ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [FK_OrderItem_Order]
GO
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_Product] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Product] ([ProductCode])
GO
ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [FK_OrderItem_Product]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_ProductType] FOREIGN KEY([TypeId])
REFERENCES [dbo].[ProductType] ([Id])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_ProductType]
GO
ALTER TABLE [dbo].[Promotion]  WITH CHECK ADD  CONSTRAINT [FK_Promotion_Product] FOREIGN KEY([ProductCode])
REFERENCES [dbo].[Product] ([ProductCode])
GO
ALTER TABLE [dbo].[Promotion] CHECK CONSTRAINT [FK_Promotion_Product]
GO
ALTER TABLE [dbo].[Promotion]  WITH CHECK ADD  CONSTRAINT [FK_Promotion_PromotionType] FOREIGN KEY([TypeId])
REFERENCES [dbo].[PromotionType] ([Id])
GO
ALTER TABLE [dbo].[Promotion] CHECK CONSTRAINT [FK_Promotion_PromotionType]
GO
USE [master]
GO
ALTER DATABASE [SupermarketDB] SET  READ_WRITE 
GO
