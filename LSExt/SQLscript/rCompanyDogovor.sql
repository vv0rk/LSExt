
use lansweeperdb;

go

/*
	��������������� ���������� �� ��������� 
*/

if OBJECT_ID (N'rCompanyDogovor') is null
begin;
	create table dbo.rCompanyDogovor (
		Id int not null identity(1,1) primary key,
		Name nvarchar(100) null,	-- ������������ ����������� 
		Number nvarchar(50) null,	-- ����� ��������
		DateStart datetime null,	-- ���� ������ ��������
		DateDS int null, -- ����� � ������� ����������������� ��������� ��������
	)
end;