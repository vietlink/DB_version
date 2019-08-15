/****** Object:  Table [dbo].[EmployeeProfile]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeProfile](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[Profile] [varchar](max) NOT NULL,
 CONSTRAINT [PK_EmployeeProfile] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[EmployeeProfile] ADD  CONSTRAINT [DF_EmployeeProfile_Profile]  DEFAULT ('') FOR [Profile]
ALTER TABLE [dbo].[EmployeeProfile]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeProfile_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([id])
ALTER TABLE [dbo].[EmployeeProfile] CHECK CONSTRAINT [FK_EmployeeProfile_Employee]
