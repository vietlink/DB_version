/****** Object:  Table [dbo].[LeaveAdjustmentPeople]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeaveAdjustmentPeople](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[LeaveAdjustmentHeaderID] [int] NOT NULL,
 CONSTRAINT [PK_LeaveAdjustmentPeople] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LeaveAdjustmentPeople]  WITH CHECK ADD  CONSTRAINT [FK_LeaveAdjustmentPeople_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([id])
ALTER TABLE [dbo].[LeaveAdjustmentPeople] CHECK CONSTRAINT [FK_LeaveAdjustmentPeople_Employee]
ALTER TABLE [dbo].[LeaveAdjustmentPeople]  WITH CHECK ADD  CONSTRAINT [FK_LeaveAdjustmentPeople_LeaveAdjustmentHeader] FOREIGN KEY([LeaveAdjustmentHeaderID])
REFERENCES [dbo].[LeaveAdjustmentHeader] ([ID])
ALTER TABLE [dbo].[LeaveAdjustmentPeople] CHECK CONSTRAINT [FK_LeaveAdjustmentPeople_LeaveAdjustmentHeader]
