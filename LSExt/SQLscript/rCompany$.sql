
use lansweeperdb;

go

/*
	��������������� ���������� �� ��������� 
*/

if OBJECT_ID (N'rCompany$') is null
begin;
	create table dbo.rCompany$ (
		Id int not null identity(1,1) primary key,
		[�������� �����������] nvarchar(255) null,
		[������] nvarchar(255) null,
		Code nvarchar(255) null,		-- ��� ������� (�������)
		Parent nvarchar(255) null,		-- ��� ������������ ����������� (�������)
		[��� ENG] nvarchar(50) null,	-- ��� ������� (����������)
		numPC	int null,				-- ���������� �� ���������� ���������
		Comment nvarchar(255) null,
		titleNaumen nvarchar(255) null,
		IdCompanyDogovor int null,
		Constraint FK_rCompany_rCompanyDogovor_IdCompanyDogovor_Id foreign key (IdCompanyDogovor)
			references rCompanyDogovor (Id)
	)
end;

alter table rCompany$ add IdCompanyDogovor int null;
alter table rCompany$ add Constraint FK_rCompany_rCompanyDogovor_IdCompanyDogovor_Id foreign key (IdCompanyDogovor)
			references rCompanyDogovor (Id);