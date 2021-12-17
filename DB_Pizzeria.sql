create database Pizzeria

create table Pizza(
	CodicePizza int identity(1,1) constraint PK_Pizza primary key,
	Nome varchar(30) not null,
	Prezzo decimal(5,2) not null constraint CHK_PrezzoPizza check (Prezzo > 0)
	)

create table Ingrediente (
	CodiceIngrediente int identity(1,1) constraint PK_Ingrediente primary key,
	Nome varchar(30) not null,
	Costo decimal(5,2) not null constraint CHK_CostoIngrediente check (Costo > 0),
	QtaMagazzino int not null constraint CHK_QtaMagazzino check (QtaMagazzino >= 0)
	)

create table IngredientePizza (
	CodiceIngrediente int constraint FK_Ingrediente foreign key references Ingrediente(CodiceIngrediente),
	CodicePizza int constraint FK_Pizza foreign key references Pizza(CodicePizza),
	constraint PK_IngredientePizza primary key(CodiceIngrediente, CodicePizza)
	)

--procedures
--1. INSERIMENTO NUOVA PIZZA
create procedure InserisciPizza
@nome varchar(30),
@prezzo decimal(5,2)
as
insert into Pizza values (@nome, @prezzo)
go

create procedure InserisciIngrediente
@nome varchar(30),
@costo decimal(5,2),
@qta integer
as
insert into Ingrediente values (@nome, @costo, @qta)
go

--2. ASSEGNAZIONE INGREDIENTE A PIZZA
create procedure AssegnaIngredienteAPizza
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
go

--3. AGGIORNAMENTO PREZZO PIZZA
create procedure AggiornaPrezzoPizza
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
go
 
exec AggiornaPrezzoPizza 'Margherita', 10
exec AggiornaPrezzoPizza 'Margherita', 0

--4. ELIMINAZIONE INGREDIENTE DA PIZZA
create procedure EliminaIngredienteDaPizza
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
go

exec AssegnaIngredienteAPizza 'Olive', 'Quattro Formaggi'
exec EliminaIngredienteDaPizza 'Olive', 'Quattro Formaggi'

--5. INCREMENTO 10% PREZZO PIZZE CON TALE INGREDIENTE
create procedure Aumenta10PerCentoPizzeConIngrediente
@nomeIngr varchar(30)
as
	declare @ID_ingr int
			select @ID_ingr = i.CodiceIngrediente from Ingrediente i where i.Nome = @nomeIngr

	update Pizza set Prezzo += (Prezzo/10) where Nome in (select p.Nome
															from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
															where ip.CodiceIngrediente = @ID_ingr)
go

exec Aumenta10PerCentoPizzeConIngrediente 'Bresaola'

--dataentry
exec InserisciPizza 'Margherita', 5
exec InserisciPizza 'Bufala', 7
exec InserisciPizza 'Diavola', 6
exec InserisciPizza 'Quattro Stagioni', 6.5
exec InserisciPizza 'Porcini', 7
exec InserisciPizza 'Dioniso', 8
exec InserisciPizza 'Ortolana', 8
exec InserisciPizza 'Patate e Salsiccia', 6
exec InserisciPizza 'Pomodorini', 6
exec InserisciPizza 'Quattro Formaggi', 7.5
exec InserisciPizza 'Caprese', 7.5
exec InserisciPizza 'Zeus', 7.5

exec InserisciIngrediente 'Pomodoro', 8.2, 32
exec InserisciIngrediente 'Mozzarella', 17.80, 20
exec InserisciIngrediente 'Mozzarella di bufala', 21.20, 12
exec InserisciIngrediente 'Spianata piccante', 14.22, 18
exec InserisciIngrediente 'Funghi', 12.80, 15
exec InserisciIngrediente 'Carciofi', 7.63, 5
exec InserisciIngrediente 'Cotto', 21.49, 20
exec InserisciIngrediente 'Olive', 12.10, 6
exec InserisciIngrediente 'Funghi porcini', 30.21, 6
exec InserisciIngrediente 'Stracchino', 15.2, 8
exec InserisciIngrediente 'Speck', 22.50, 2
exec InserisciIngrediente 'Rucola', 4.7, 12
exec InserisciIngrediente 'Grana', 27.00, 4
exec InserisciIngrediente 'Verdure di stagione', 11.4, 9
exec InserisciIngrediente 'Patate', 3.88, 14
exec InserisciIngrediente 'Salsiccia', 6.3, 7
exec InserisciIngrediente 'Pomodorini', 5.99, 12
exec InserisciIngrediente 'Ricotta', 17.33, 6
exec InserisciIngrediente 'Provola', 18.23, 4
exec InserisciIngrediente 'Gorgonzola', 15.70, 9
exec InserisciIngrediente 'Pomodoro fresco', 13.5, 15
exec InserisciIngrediente 'Basilico', 7.7, 2
exec InserisciIngrediente 'Bresaola', 18.8, 4

exec AssegnaIngredienteAPizza 'Pomodoro', 'Margherita'
exec AssegnaIngredienteAPizza 'Mozzarella', 'Margherita'

exec AssegnaIngredienteAPizza 'Pomodoro', 'Bufala'
exec AssegnaIngredienteAPizza 'Mozzarella di bufala', 'Bufala'

exec AssegnaIngredienteAPizza 'Pomodoro', 'Diavola'
exec AssegnaIngredienteAPizza 'Mozzarella', 'Diavola'
exec AssegnaIngredienteAPizza 'Spianata piccante', 'Diavola'

exec AssegnaIngredienteAPizza 'Pomodoro', 'Quattro Stagioni'
exec AssegnaIngredienteAPizza 'Mozzarella', 'Quattro Stagioni'
exec AssegnaIngredienteAPizza 'Funghi', 'Quattro Stagioni'
exec AssegnaIngredienteAPizza 'Carciofi', 'Quattro Stagioni'
exec AssegnaIngredienteAPizza 'Cotto', 'Quattro Stagioni'
exec AssegnaIngredienteAPizza 'Olive', 'Quattro Stagioni'

exec AssegnaIngredienteAPizza 'Pomodoro', 'Porcini'
exec AssegnaIngredienteAPizza 'Mozzarella', 'Porcini'
exec AssegnaIngredienteAPizza 'Funghi porcini', 'Porcini'

exec AssegnaIngredienteAPizza 'Pomodoro', 'Dioniso'
exec AssegnaIngredienteAPizza 'Mozzarella', 'Dioniso'
exec AssegnaIngredienteAPizza 'Stracchino', 'Dioniso'
exec AssegnaIngredienteAPizza 'Speck', 'Dioniso'
exec AssegnaIngredienteAPizza 'Rucola', 'Dioniso'
exec AssegnaIngredienteAPizza 'Grana', 'Dioniso'

exec AssegnaIngredienteAPizza 'Pomodoro', 'Ortolana'
exec AssegnaIngredienteAPizza 'Mozzarella', 'Ortolana'
exec AssegnaIngredienteAPizza 'Verdure di stagione', 'Ortolana'

exec AssegnaIngredienteAPizza 'Mozzarella', 'Patate e Salsiccia'
exec AssegnaIngredienteAPizza 'Patate', 'Patate e Salsiccia'
exec AssegnaIngredienteAPizza 'Salsiccia', 'Patate e Salsiccia'

exec AssegnaIngredienteAPizza 'Mozzarella', 'Pomodorini'
exec AssegnaIngredienteAPizza 'Pomodorini', 'Pomodorini'
exec AssegnaIngredienteAPizza 'Ricotta', 'Pomodorini'

exec AssegnaIngredienteAPizza 'Mozzarella', 'Quattro Formaggi'
exec AssegnaIngredienteAPizza 'Provola', 'Quattro Formaggi'
exec AssegnaIngredienteAPizza 'Gorgonzola', 'Quattro Formaggi'
exec AssegnaIngredienteAPizza 'Grana', 'Quattro Formaggi'

exec AssegnaIngredienteAPizza 'Mozzarella', 'Caprese'
exec AssegnaIngredienteAPizza 'Pomodoro fresco', 'Caprese'
exec AssegnaIngredienteAPizza 'Basilico', 'Caprese'

exec AssegnaIngredienteAPizza 'Mozzarella', 'Zeus'
exec AssegnaIngredienteAPizza 'Bresaola', 'Zeus'
exec AssegnaIngredienteAPizza 'Rucola', 'Zeus'

select * from Pizza
select * from Ingrediente
select * from IngredientePizza

--queries
--1. Estrarre tutte le pizze con prezzo superiore a 6 euro
select *
from Pizza p
where p.Prezzo > 6

--2. Estrarre la pizza/le pizze più costosa/e
select *
from Pizza p
where p.Prezzo = (select max(p.Prezzo)
					from Pizza p)

--3. Estrarre le pizze "bianche"
select * 
from Pizza p
where p.Nome not in (select p.Nome
						from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
									join Ingrediente i on ip.CodiceIngrediente = i.CodiceIngrediente
						where i.Nome = 'Pomodoro')

--4. Estrarre le pizze che contengono funghi (di qualsiasi tipo)
select p.*
from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
			join Ingrediente i on ip.CodiceIngrediente = i.CodiceIngrediente
where i.Nome like 'Funghi%'



--functions
--1. Tabella listino pizze (nome, prezzo)
create function TabellaListinoPizze()
returns table
as 
return select p.Nome, p.Prezzo from Pizza p
	
select * from TabellaListinoPizze()

--2. Tabella listino pizze (nome, prezzo) contententi un ingrediente (parametro: nome ingrediente)
create function TabellaListinoPizzeConIngrediente(@nomeIngrediente varchar(30))
returns table
as
return select p.Nome as Pizza, p.Prezzo
		from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
					join Ingrediente i on ip.CodiceIngrediente = i.CodiceIngrediente 
		where i.CodiceIngrediente = (select i.CodiceIngrediente from Ingrediente i where i.Nome = @nomeIngrediente)

select * from TabellaListinoPizzeConIngrediente('Mozzarella')
select * from TabellaListinoPizzeConIngrediente('Olive')
select * from TabellaListinoPizzeConIngrediente('Rucola')


--3. Tab listino pizze (nome, prezzo) NON contententi un certo ingrediente (par: nome ingr)
create function TabellaListinoPizzeSenzaIngrediente(@nomeIngrediente varchar(30))
returns table as
return select * 
		from Pizza p
		where p.Nome not in (select p.Nome
								from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
											join Ingrediente i on ip.CodiceIngrediente = i.CodiceIngrediente
								where i.CodiceIngrediente = (select i.CodiceIngrediente from Ingrediente i where i.Nome = @nomeIngrediente))

select * from TabellaListinoPizzeSenzaIngrediente('Mozzarella')
select * from TabellaListinoPizzeSenzaIngrediente('Grana')


--4. Calcolo numero pizze contententi un certo ingrediente (par: nome ingr)
create function CalcolaNumPizzeConIngrediente(@nomeIngrediente varchar(30))
returns int as
	begin
	declare @num int
		select @num = count(*) 
		from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
		where ip.CodiceIngrediente = (select i.CodiceIngrediente from Ingrediente i where i.Nome = @nomeIngrediente)
	return @num 
	end

select dbo.CalcolaNumPizzeConIngrediente('Pomodoro')as [Numero pizze]
select dbo.CalcolaNumPizzeConIngrediente('Rucola')as [Numero pizze]
select dbo.CalcolaNumPizzeConIngrediente('Cotto')as [Numero pizze]

--5. Calcolo numero pizze NON contententi un certo ingr (par: codice ingr)
create function CalcolaNumPizzeSenzaIngrediente(@idIngrediente int)
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

select dbo.CalcolaNumPizzeSenzaIngrediente(1)as [Numero pizze]
select dbo.CalcolaNumPizzeSenzaIngrediente(6)as [Numero pizze]
select dbo.CalcolaNumPizzeSenzaIngrediente(2)as [Numero pizze]

--6. Calcolo numero ingredienti contenuti in una certa pizza (par: nome pizza)
create function CalcolaNumIngredientiNellaPizza(@nomePizza varchar(30))
returns int as
	begin
		declare @num int
		select @num = count(*) 
		from Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
					 join Ingrediente i on ip.CodiceIngrediente = i.CodiceIngrediente
		where p.CodicePizza = (select p.CodicePizza from Pizza p where p.Nome = @nomePizza)
	return @num 
	end

select dbo.CalcolaNumIngredientiNellaPizza('Margherita') as [Numero ingredienti]
select dbo.CalcolaNumIngredientiNellaPizza('Quattro Formaggi') as [Numero ingredienti]
select dbo.CalcolaNumIngredientiNellaPizza('Quattro Stagioni') as [Numero ingredienti]


--VIEW
create view Menu as 
(select p.Nome as Pizza, p.Prezzo, i.Nome as Ingredienti
from  Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
			 join Ingrediente i on ip.CodiceIngrediente = i.CodiceIngrediente
)

select * from Menu order by Menu.Pizza

-- VIEW OPZIONALE -> Menu2
create view IdPizzaNomeIngrediente as
(
select p.CodicePizza, i.Nome
from  Pizza p join IngredientePizza ip on p.CodicePizza = ip.CodicePizza
			 join Ingrediente i on ip.CodiceIngrediente = i.CodiceIngrediente)


create view Menu2 as (SELECT 
   p.Nome as Pizza, p.Prezzo,
   STUFF((SELECT ', ' + ipni.Nome
          FROM IdPizzaNomeIngrediente ipni
		  where ipni.CodicePizza = p.CodicePizza
          FOR XML PATH('')), 1, 1, '') [Ingredienti]
FROM Pizza p
GROUP BY p.CodicePizza, p.Nome, p.Prezzo
)

select * from Menu2

