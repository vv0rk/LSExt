USE [lansweeperdb]
GO

/****** Object:  Table [dbo].[rEmployee]    Script Date: 03.06.2017 18:46:28 ******/
/*
таблица для хранения данных о персонале из Naumen
*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[rEmployee](
	[id] [bigint] NOT NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[last_modified_date] [datetime2](7) NULL,
	[removal_date] [datetime2](7) NULL,
	[removed] [bit] NOT NULL,
	[title] [nvarchar](4000) NULL,
	[case_id] [nvarchar](255) NOT NULL,
	[city_phone] [nvarchar](255) NULL,
	[date_of_birth] [datetime2](7) NULL,
	[email] [nvarchar](255) NULL,
	[first_name] [nvarchar](255) NULL,
	[home_phone] [nvarchar](255) NULL,
	[internal_phone] [nvarchar](255) NULL,
	[last_name] [nvarchar](255) NOT NULL,
	[login] [nvarchar](255) NULL,
	[middle_name] [nvarchar](255) NULL,
	[mobile_phone] [nvarchar](255) NULL,
	[num_] [bigint] NULL,
	[password] [nvarchar](255) NULL,
	[post] [nvarchar](255) NULL,
	[private_code] [nvarchar](255) NULL,
	[author_id] [bigint] NULL,
	[system_icon_id] [bigint] NULL,
	[parent_id] [bigint] NULL,
	[idHolder] [nvarchar](255) NULL,
	[icon] [bigint] NULL,
	[employee$intro] [nvarchar](max) NULL,
	[employee$shortDescr1] [nvarchar](max) NULL,
	[employee$keyEmployee] [bit] NULL,
	[employee$shortDescr2] [nvarchar](max) NULL,
	[employee$quickStart] [nvarchar](max) NULL,
	[employee$shortDescr3] [nvarchar](max) NULL,
	[employee$processDocumen] [nvarchar](max) NULL,
	[employee$cs] [nvarchar](max) NULL,
	[employee$workMng] [nvarchar](max) NULL,
	[contactPerson$keyEmployee] [bit] NULL,
	[objectGUID] [nvarchar](255) NULL,
	[organization] [bigint] NULL,
	[address] [nvarchar](255) NULL,
	[VIP] [bigint] NULL,
	[is_employee_locked] [bit] NULL,
	[password_change_date] [datetime2](7) NULL,
	[password_must_be_changed] [bit] NULL,
	[isRemoved] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

