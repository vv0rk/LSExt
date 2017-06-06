use lansweeperdb;

go

/*
	Ћична€ карточка это документ, который подтверждает 
	лична€ карточка имеет силу, только тогда, когда ее одобрил ћќЋ
*/

if object_id (N'rDvigLK') is null
begin;
	CREATE TABLE [dbo].rDvigLK
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		[idEmployee] int not null,
		Constraint FK_rDvigLK_rEmployeeMod_idEmployee_Id foreign key (idEmployee)
			references dbo.rEmployeeMod (id),
		-- одобрено молом 0 - не одобрено, 1 - одобрено
		[isApproved] bit not null default 0,
		-- мол
		[idmol] int not null,
		Constraint FK_rDvigLK_rEmployeeMod_idmol_id foreign key (idmol)
			references dbo.rEmployeeMod (id),

		-- ссылка на предыдущую личную карточку, если была
		[idprev] int null, 
		-- тип документа, возможно это будет лична€ карточка, запись в журнале, 
		-- [idType] int not null 

	);
end;

