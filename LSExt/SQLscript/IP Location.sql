use lansweeperdb;

-- По заявке Одякова распределение сетевых диапазонов по кустам
-- Позволяет назначить сетевые диапазоны по кустам
--

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if OBJECT_ID (N'rCompanyCust') is null
	begin;
		Create table rCompanyCust
		(
			Id int not null identity(1,1) primary key,
			Name nvarchar(100) not null
		)
	end;


if OBJECT_ID (N'rCompanyCustLink') is null
	begin;
		Create table rCompanyCustLink
		(
			Id int not null identity(1,1) primary key,
			IdCust int null,
			Constraint FK_rCompanyCustLink_rCompanyCust_IdCust foreign key (IdCust)
				references rCompanyCust(Id),
			IdIPLocations int not null,
			Constraint FK_rCompanyCustLink_tsysIPLocations_IdIPLocations foreign key (IdIPLocations)
				references tsysIPLocations(LocationID)
		)
	end;

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

drop trigger dbo.Trigger_tsysIPLocations;
go

Create trigger trigger_tsysIPLocations_Insert
on dbo.tsysIPLocations for insert
as 
begin;
	set nocount on;

	-- если создается новый сетевой диапазон, то создаем запись в таблице rCompanyCustLink
	insert into 
		dbo.rCompanyCustLink
		(
			IdIPLocations
		)
		select 
			i.LocationID
		from inserted as i
end;