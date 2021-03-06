USE [master]
GO
/****** Object:  Database [Pizzeria]    Script Date: 17-Dec-21 14:27:18 ******/
CREATE DATABASE [Pizzeria]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Pizzeria', FILENAME = N'C:\Users\laura.gagliani\Pizzeria.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Pizzeria_log', FILENAME = N'C:\Users\laura.gagliani\Pizzeria_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Pizzeria] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Pizzeria].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Pizzeria] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Pizzeria] SET ARITHABORT OFF 
GO
ALTER DATABASE [Pizzeria] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Pizzeria] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Pizzeria] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Pizzeria] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Pizzeria] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Pizzeria] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Pizzeria] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Pizzeria] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Pizzeria] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Pizzeria] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Pizzeria] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Pizzeria] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Pizzeria] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Pizzeria] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Pizzeria] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Pizzeria] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Pizzeria] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Pizzeria] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Pizzeria] SET  MULTI_USER 
GO
ALTER DATABASE [Pizzeria] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Pizzeria] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Pizzeria] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Pizzeria] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Pizzeria] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Pizzeria] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Pizzeria] SET QUERY_STORE = OFF
GO
USE [Pizzeria]
GO
/****** Object:  UserDefinedFunction [dbo].[CalcolaNumIngredientiNellaPizza]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CalcolaNumIngredientiNellaPizza](@nomePizza varchar(30))
returns int as
	begin
		declare @num int
		select @num = count(*) 
		from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
					 join Ingrediente i on ip.CodiceIngrediente = i.CodiceIngrediente
		where p.CodicePizza = (select p.CodicePizza from Pizza p where p.Nome = @nomePizza)
	return @num 
	end
GO
/****** Object:  UserDefinedFunction [dbo].[CalcolaNumPizzeConIngrediente]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CalcolaNumPizzeConIngrediente](@nomeIngrediente varchar(30))
returns int as
	begin
	declare @num int
		select @num = count(*) 
		from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
		where ip.CodiceIngrediente = (select i.CodiceIngrediente from Ingrediente i where i.Nome = @nomeIngrediente)
	return @num 
	end
GO
/****** Object:  UserDefinedFunction [dbo].[CalcolaNumPizzeSenzaIngrediente]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CalcolaNumPizzeSenzaIngrediente](@idIngrediente int)
returns int as
	begin
	declare @num int
		select @num = count(*) 
		from Pizza p 
		where p.Nome not in (select p.Nome
								from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
								where ip.CodiceIngrediente = @idIngrediente)
	return @num 
	end
GO
/****** Object:  Table [dbo].[Pizza]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pizza](
	[CodicePizza] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](30) NOT NULL,
	[Prezzo] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK_Pizza] PRIMARY KEY CLUSTERED 
(
	[CodicePizza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[TabellaListinoPizze]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[TabellaListinoPizze]()
returns table
as 
return select p.Nome, p.Prezzo from Pizza p
GO
/****** Object:  Table [dbo].[Ingrediente]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ingrediente](
	[CodiceIngrediente] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](30) NOT NULL,
	[Costo] [decimal](5, 2) NOT NULL,
	[QtaMagazzino] [int] NOT NULL,
 CONSTRAINT [PK_Ingrediente] PRIMARY KEY CLUSTERED 
(
	[CodiceIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IngredientePizza]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IngredientePizza](
	[CodiceIngrediente] [int] NOT NULL,
	[CodicePizza] [int] NOT NULL,
 CONSTRAINT [PK_IngredientePizza] PRIMARY KEY CLUSTERED 
(
	[CodiceIngrediente] ASC,
	[CodicePizza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[TabellaListinoPizzeConIngrediente]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[TabellaListinoPizzeConIngrediente](@nomeIngrediente varchar(30))
returns table
as
return select p.Nome as Pizza, p.Prezzo
		from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
					join Ingrediente i on ip.CodiceIngrediente = i.CodiceIngrediente 
		where i.CodiceIngrediente = (select i.CodiceIngrediente from Ingrediente i where i.Nome = @nomeIngrediente)
GO
/****** Object:  UserDefinedFunction [dbo].[TabellaListinoPizzeSenzaIngrediente]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[TabellaListinoPizzeSenzaIngrediente](@nomeIngrediente varchar(30))
returns table as
return select * 
		from Pizza p
		where p.Nome not in (select p.Nome
								from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
											join Ingrediente i on ip.CodiceIngrediente = i.CodiceIngrediente
								where i.CodiceIngrediente = (select i.CodiceIngrediente from Ingrediente i where i.Nome = @nomeIngrediente))
GO
/****** Object:  View [dbo].[IdPizzaNomeIngrediente]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[IdPizzaNomeIngrediente] as
(
select p.CodicePizza, i.Nome
from  Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
			 join Ingrediente i on ip.CodiceIngrediente = i.CodiceIngrediente)
GO
/****** Object:  View [dbo].[Menu]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Menu] as 
(select p.Nome as Pizza, p.Prezzo, i.Nome as Ingredienti
from  Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
			 join Ingrediente i on ip.CodiceIngrediente = i.CodiceIngrediente
)
GO
/****** Object:  View [dbo].[Menu2]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Menu2] as (SELECT 
   p.Nome as Pizza, p.Prezzo,
   STUFF((SELECT ', ' + ipni.Nome
          FROM IdPizzaNomeIngrediente ipni
		  where ipni.CodicePizza = p.CodicePizza
          FOR XML PATH('')), 1, 1, '') [Ingredienti]
FROM Pizza p
GROUP BY p.CodicePizza, p.Nome, p.Prezzo
)
GO
SET IDENTITY_INSERT [dbo].[Ingrediente] ON 

INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (1, N'Pomodoro', CAST(8.20 AS Decimal(5, 2)), 32)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (2, N'Mozzarella', CAST(17.80 AS Decimal(5, 2)), 20)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (3, N'Mozzarella di bufala', CAST(21.20 AS Decimal(5, 2)), 12)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (4, N'Spianata piccante', CAST(14.22 AS Decimal(5, 2)), 18)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (5, N'Funghi', CAST(12.80 AS Decimal(5, 2)), 15)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (6, N'Carciofi', CAST(7.63 AS Decimal(5, 2)), 5)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (7, N'Cotto', CAST(21.49 AS Decimal(5, 2)), 20)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (8, N'Olive', CAST(12.10 AS Decimal(5, 2)), 6)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (9, N'Funghi porcini', CAST(30.21 AS Decimal(5, 2)), 6)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (10, N'Stracchino', CAST(15.20 AS Decimal(5, 2)), 8)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (11, N'Speck', CAST(22.50 AS Decimal(5, 2)), 2)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (12, N'Rucola', CAST(4.70 AS Decimal(5, 2)), 12)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (13, N'Grana', CAST(27.00 AS Decimal(5, 2)), 4)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (14, N'Verdure di stagione', CAST(11.40 AS Decimal(5, 2)), 9)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (15, N'Patate', CAST(3.88 AS Decimal(5, 2)), 14)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (16, N'Salsiccia', CAST(6.30 AS Decimal(5, 2)), 7)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (17, N'Pomodorini', CAST(5.99 AS Decimal(5, 2)), 12)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (18, N'Ricotta', CAST(17.33 AS Decimal(5, 2)), 6)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (19, N'Provola', CAST(18.23 AS Decimal(5, 2)), 4)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (20, N'Gorgonzola', CAST(15.70 AS Decimal(5, 2)), 9)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (21, N'Pomodoro fresco', CAST(13.50 AS Decimal(5, 2)), 15)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (22, N'Basilico', CAST(7.70 AS Decimal(5, 2)), 2)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (23, N'Bresaola', CAST(18.80 AS Decimal(5, 2)), 4)
SET IDENTITY_INSERT [dbo].[Ingrediente] OFF
GO
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (1, 1)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (1, 2)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (1, 3)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (1, 4)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (1, 5)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (1, 6)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (1, 7)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (2, 1)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (2, 3)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (2, 4)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (2, 5)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (2, 6)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (2, 7)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (2, 8)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (2, 9)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (2, 10)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (2, 11)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (2, 12)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (3, 2)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (4, 3)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (5, 4)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (6, 4)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (7, 4)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (8, 4)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (9, 5)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (10, 6)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (11, 6)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (12, 6)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (12, 12)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (13, 6)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (13, 10)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (14, 7)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (15, 8)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (16, 8)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (17, 9)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (18, 9)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (19, 10)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (20, 10)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (21, 11)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (22, 11)
INSERT [dbo].[IngredientePizza] ([CodiceIngrediente], [CodicePizza]) VALUES (23, 12)
GO
SET IDENTITY_INSERT [dbo].[Pizza] ON 

INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (1, N'Margherita', CAST(5.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (2, N'Bufala', CAST(7.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (3, N'Diavola', CAST(6.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (4, N'Quattro Stagioni', CAST(6.50 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (5, N'Porcini', CAST(7.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (6, N'Dioniso', CAST(8.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (7, N'Ortolana', CAST(8.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (8, N'Patate e Salsiccia', CAST(6.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (9, N'Pomodorini', CAST(6.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (10, N'Quattro Formaggi', CAST(7.50 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (11, N'Caprese', CAST(7.50 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (12, N'Zeus', CAST(7.50 AS Decimal(5, 2)))
SET IDENTITY_INSERT [dbo].[Pizza] OFF
GO
ALTER TABLE [dbo].[IngredientePizza]  WITH CHECK ADD  CONSTRAINT [FK_Ingrediente] FOREIGN KEY([CodiceIngrediente])
REFERENCES [dbo].[Ingrediente] ([CodiceIngrediente])
GO
ALTER TABLE [dbo].[IngredientePizza] CHECK CONSTRAINT [FK_Ingrediente]
GO
ALTER TABLE [dbo].[IngredientePizza]  WITH CHECK ADD  CONSTRAINT [FK_Pizza] FOREIGN KEY([CodicePizza])
REFERENCES [dbo].[Pizza] ([CodicePizza])
GO
ALTER TABLE [dbo].[IngredientePizza] CHECK CONSTRAINT [FK_Pizza]
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD  CONSTRAINT [CHK_CostoIngrediente] CHECK  (([Costo]>(0)))
GO
ALTER TABLE [dbo].[Ingrediente] CHECK CONSTRAINT [CHK_CostoIngrediente]
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD  CONSTRAINT [CHK_QtaMagazzino] CHECK  (([QtaMagazzino]>=(0)))
GO
ALTER TABLE [dbo].[Ingrediente] CHECK CONSTRAINT [CHK_QtaMagazzino]
GO
ALTER TABLE [dbo].[Pizza]  WITH CHECK ADD  CONSTRAINT [CHK_PrezzoPizza] CHECK  (([Prezzo]>(0)))
GO
ALTER TABLE [dbo].[Pizza] CHECK CONSTRAINT [CHK_PrezzoPizza]
GO
/****** Object:  StoredProcedure [dbo].[AggiornaPrezzoPizza]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AggiornaPrezzoPizza]
@nomePizza varchar(30),
@nuovoPrezzo decimal(5,2)
as
	begin try
		declare @ID_pizza int
					select @ID_pizza = p.CodicePizza from Pizza p where p.Nome = @nomePizza
		update Pizza set Prezzo = @nuovoPrezzo where CodicePizza = @ID_pizza
	end try
	begin catch
			select ERROR_LINE() as Riga, ERROR_MESSAGE() as [Messaggio di errore]
		end catch
GO
/****** Object:  StoredProcedure [dbo].[AssegnaIngredienteAPizza]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--2. ASSEGNAZIONE INGREDIENTE A PIZZA
create procedure [dbo].[AssegnaIngredienteAPizza]
@nomeIngr varchar(30),
@nomePizza varchar(30)
as
	begin try
		declare @ID_pizza int
			select @ID_pizza = p.CodicePizza from Pizza p where p.Nome = @nomePizza
		declare @ID_ingr int
			select @ID_ingr = i.CodiceIngrediente from Ingrediente i where i.Nome = @nomeIngr

		insert into IngredientePizza values (@ID_ingr, @ID_pizza)
	end try
	begin catch
		select ERROR_LINE() as Riga, ERROR_MESSAGE() as [Messaggio di errore]
	end catch
GO
/****** Object:  StoredProcedure [dbo].[Aumenta10PerCentoPizzeConIngrediente]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Aumenta10PerCentoPizzeConIngrediente]
@nomeIngr varchar(30)
as
	declare @ID_ingr int
			select @ID_ingr = i.CodiceIngrediente from Ingrediente i where i.Nome = @nomeIngr

	update Pizza set Prezzo += (Prezzo/10) where Nome in (select p.Nome
															from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
															where ip.CodiceIngrediente = @ID_ingr)
GO
/****** Object:  StoredProcedure [dbo].[EliminaIngredienteDaPizza]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[EliminaIngredienteDaPizza]
@nomeIngrediente varchar(30),
@nomePizza varchar(30)
as
	begin try
		declare @ID_pizza int
			select @ID_pizza = p.CodicePizza from Pizza p where p.Nome = @nomePizza
		declare @ID_ingr int
			select @ID_ingr = i.CodiceIngrediente from Ingrediente i where i.Nome = @nomeIngrediente

		delete from IngredientePizza where (CodiceIngrediente = @ID_ingr AND CodicePizza = @ID_pizza)
	end try
	begin catch
			select ERROR_LINE() as Riga, ERROR_MESSAGE() as [Messaggio di errore]
		end catch
GO
/****** Object:  StoredProcedure [dbo].[InserisciIngrediente]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserisciIngrediente]
@nome varchar(30),
@costo decimal(5,2),
@qta integer
as
insert into Ingrediente values (@nome, @costo, @qta)
GO
/****** Object:  StoredProcedure [dbo].[InserisciPizza]    Script Date: 17-Dec-21 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserisciPizza]
@nome varchar(30),
@prezzo decimal(5,2)
as
insert into Pizza values (@nome, @prezzo)
GO
USE [master]
GO
ALTER DATABASE [Pizzeria] SET  READ_WRITE 
GO
