use lansweeperdb;

go

alter table rShtatR drop column id
alter table rShtatR add id int identity(1,1) not null Primary key


alter table rCompany$
drop column id 

alter table dbo.rCompany$
add id int identity(1,1) not null Primary key


-- ��������� ������� ��� ���������� �� ������� ������������� ������������
alter table dbo.rCompany$
add numPC int null

-- ��������� ������� ��� ���������� �� ������� ������������� ������������
alter table dbo.rCompany$
add Comment nvarchar(255) null