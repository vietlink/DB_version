/****** Object:  Table [dbo].[EmployeeDetailFields]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeDetailFields](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [int] NOT NULL,
	[AttributeID] [int] NOT NULL,
	[Section] [int] NOT NULL,
	[Field] [int] NOT NULL,
 CONSTRAINT [PK_EmployeeDetailFields] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeeDetailFields]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeDetailFields_Attribute] FOREIGN KEY([AttributeID])
REFERENCES [dbo].[Attribute] ([id])
ALTER TABLE [dbo].[EmployeeDetailFields] CHECK CONSTRAINT [FK_EmployeeDetailFields_Attribute]
