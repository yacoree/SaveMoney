USE [SaveMoney]
GO
/****** Object:  Table [dbo].[BankAccounts]    Script Date: 21.11.2023 9:06:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BankAccounts](
	[BankAccount_ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ID_User] [int] NOT NULL,
 CONSTRAINT [PK_BankAccounts] PRIMARY KEY CLUSTERED 
(
	[BankAccount_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 21.11.2023 9:06:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[Transaction_ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_BankAccount] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Date] [date] NOT NULL,
	[ID_Category] [int] NOT NULL,
 CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED 
(
	[Transaction_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[BankAccountsAmounts]    Script Date: 21.11.2023 9:06:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BankAccountsAmounts]
AS
	SELECT BA.BankAccount_ID AS BankAccount_ID, 
			SUM(T.Amount) AS BankAccountAmount
	FROM Transactions T
	INNER JOIN BankAccounts BA ON ID_BankAccount = BA.BankAccount_ID
	GROUP BY BA.BankAccount_ID;
GO
/****** Object:  Table [dbo].[Users]    Script Date: 21.11.2023 9:06:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[User_ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[User_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[UsersAmounts]    Script Date: 21.11.2023 9:06:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[UsersAmounts]
AS
	SELECT U.User_ID AS User_ID, 
			SUM(BAA.BankAccountAmount) AS UserAmount
	FROM BankAccountsAmounts BAA
	INNER JOIN BankAccounts BA On BAA.BankAccount_ID = BA.BankAccount_ID
	INNER JOIN Users U ON BA.ID_User = U.User_ID
	GROUP BY U.User_ID;
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 21.11.2023 9:06:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Category_ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ID_TransactionTypes] [int] NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Category_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CategoriesTransactions]    Script Date: 21.11.2023 9:06:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CategoriesTransactions]
AS
Select T.ID_BankAccount, SUM(Amount) as Amount, C.Name
from Transactions T
Inner Join Categories C On ID_Category = C.Category_ID
Group by T.ID_BankAccount, C.Name
GO
/****** Object:  Table [dbo].[Logins]    Script Date: 21.11.2023 9:06:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Logins](
	[Login_ID] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[ID_User] [int] NOT NULL,
 CONSTRAINT [PK_Logins] PRIMARY KEY CLUSTERED 
(
	[Login_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TransactionTypes]    Script Date: 21.11.2023 9:06:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransactionTypes](
	[TransactionTypes_ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TransactionTypes] PRIMARY KEY CLUSTERED 
(
	[TransactionTypes_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[BankAccounts] ON 

INSERT [dbo].[BankAccounts] ([BankAccount_ID], [Name], [ID_User]) VALUES (1, N'Main', 1)
SET IDENTITY_INSERT [dbo].[BankAccounts] OFF
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([Category_ID], [Name], [ID_TransactionTypes]) VALUES (1, N'Salary', 1)
INSERT [dbo].[Categories] ([Category_ID], [Name], [ID_TransactionTypes]) VALUES (2, N'Gift', 1)
INSERT [dbo].[Categories] ([Category_ID], [Name], [ID_TransactionTypes]) VALUES (3, N'Income from shares', 1)
INSERT [dbo].[Categories] ([Category_ID], [Name], [ID_TransactionTypes]) VALUES (4, N'Another', 1)
INSERT [dbo].[Categories] ([Category_ID], [Name], [ID_TransactionTypes]) VALUES (5, N'Health', 2)
INSERT [dbo].[Categories] ([Category_ID], [Name], [ID_TransactionTypes]) VALUES (6, N'Education', 2)
INSERT [dbo].[Categories] ([Category_ID], [Name], [ID_TransactionTypes]) VALUES (7, N'Entertainments', 2)
INSERT [dbo].[Categories] ([Category_ID], [Name], [ID_TransactionTypes]) VALUES (9, N'Meal', 2)
INSERT [dbo].[Categories] ([Category_ID], [Name], [ID_TransactionTypes]) VALUES (10, N'Another', 2)
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Logins] ON 

INSERT [dbo].[Logins] ([Login_ID], [Email], [Password], [ID_User]) VALUES (3, N'123@mail.ru', N'123', 1)
SET IDENTITY_INSERT [dbo].[Logins] OFF
GO
SET IDENTITY_INSERT [dbo].[Transactions] ON 

INSERT [dbo].[Transactions] ([Transaction_ID], [ID_BankAccount], [Amount], [Date], [ID_Category]) VALUES (1, 1, CAST(123.00 AS Decimal(18, 2)), CAST(N'2023-11-21' AS Date), 1)
INSERT [dbo].[Transactions] ([Transaction_ID], [ID_BankAccount], [Amount], [Date], [ID_Category]) VALUES (2, 1, CAST(333.00 AS Decimal(18, 2)), CAST(N'2023-11-20' AS Date), 1)
INSERT [dbo].[Transactions] ([Transaction_ID], [ID_BankAccount], [Amount], [Date], [ID_Category]) VALUES (3, 1, CAST(333.00 AS Decimal(18, 2)), CAST(N'2023-10-12' AS Date), 2)
SET IDENTITY_INSERT [dbo].[Transactions] OFF
GO
SET IDENTITY_INSERT [dbo].[TransactionTypes] ON 

INSERT [dbo].[TransactionTypes] ([TransactionTypes_ID], [Name]) VALUES (1, N'Income')
INSERT [dbo].[TransactionTypes] ([TransactionTypes_ID], [Name]) VALUES (2, N'Expense')
SET IDENTITY_INSERT [dbo].[TransactionTypes] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([User_ID]) VALUES (1)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
ALTER TABLE [dbo].[BankAccounts]  WITH CHECK ADD  CONSTRAINT [FK_BankAccounts_Users] FOREIGN KEY([ID_User])
REFERENCES [dbo].[Users] ([User_ID])
GO
ALTER TABLE [dbo].[BankAccounts] CHECK CONSTRAINT [FK_BankAccounts_Users]
GO
ALTER TABLE [dbo].[Categories]  WITH CHECK ADD  CONSTRAINT [FK_Categories_TransactionTypes] FOREIGN KEY([ID_TransactionTypes])
REFERENCES [dbo].[TransactionTypes] ([TransactionTypes_ID])
GO
ALTER TABLE [dbo].[Categories] CHECK CONSTRAINT [FK_Categories_TransactionTypes]
GO
ALTER TABLE [dbo].[Logins]  WITH CHECK ADD  CONSTRAINT [FK_Logins_Users] FOREIGN KEY([ID_User])
REFERENCES [dbo].[Users] ([User_ID])
GO
ALTER TABLE [dbo].[Logins] CHECK CONSTRAINT [FK_Logins_Users]
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD  CONSTRAINT [FK_Transactions_BankAccounts] FOREIGN KEY([ID_BankAccount])
REFERENCES [dbo].[BankAccounts] ([BankAccount_ID])
GO
ALTER TABLE [dbo].[Transactions] CHECK CONSTRAINT [FK_Transactions_BankAccounts]
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD  CONSTRAINT [FK_Transactions_Categories] FOREIGN KEY([ID_Category])
REFERENCES [dbo].[Categories] ([Category_ID])
GO
ALTER TABLE [dbo].[Transactions] CHECK CONSTRAINT [FK_Transactions_Categories]
GO
