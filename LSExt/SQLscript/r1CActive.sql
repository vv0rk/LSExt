use lansweeperdb;

go 

Create table r1CActiveStatus (
	Id int not null identity(1,1) primary key,
	[Status] nvarchar(3) not null
)

Create table r1CActive (
	Id int not null identity(1,1) primary key,
	Company nvarchar(100) not null,
	nrInv nvarchar(20) not null unique,
	nrSerial nvarchar(50) null,
	Nomenclatura nvarchar(200) not null,
	nrNom nvarchar(20) not null,
	Responce nvarchar(100) not null,
	Departament nvarchar(100) not null,
	Office nvarchar(20) not null,
	[Address] nvarchar(200) not null,
	[Status] int not null default 1,
	Constraint FK_r1CActive_r1CActiveStatus_Status foreign key (Status)
		references r1CActiveStatus (Id)

)