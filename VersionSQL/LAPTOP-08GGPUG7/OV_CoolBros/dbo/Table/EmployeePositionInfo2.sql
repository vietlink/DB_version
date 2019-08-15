/****** Object:  Table [dbo].[EmployeePositionInfo2]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeePositionInfo2](
	[id] [dbo].[udtId] NOT NULL,
	[employeeid] [dbo].[udtId] NOT NULL,
	[positionid] [dbo].[udtId] NOT NULL,
	[displaynameid] [dbo].[udtId] NOT NULL,
	[displayname] [dbo].[udtLongName] NOT NULL,
	[employeeimageurlid] [dbo].[udtId] NOT NULL,
	[employeeimageurl] [dbo].[udtURL] NOT NULL,
	[positiontitleid] [dbo].[udtId] NOT NULL,
	[positiontitle] [dbo].[udtName] NOT NULL,
	[customfield1id] [dbo].[udtId] NULL,
	[customfield1] [dbo].[udtCode] NOT NULL,
	[customfield1value] [dbo].[udtLongName] NULL,
	[customfield2id] [dbo].[udtId] NULL,
	[customfield2] [dbo].[udtCode] NOT NULL,
	[customfield2value] [dbo].[udtLongName] NULL,
	[customfield3id] [dbo].[udtId] NULL,
	[customfield3] [dbo].[udtCode] NOT NULL,
	[customfield3value] [dbo].[udtLongName] NULL,
	[customfield4id] [dbo].[udtId] NULL,
	[customfield4] [dbo].[udtCode] NOT NULL,
	[customfield4value] [dbo].[udtLongName] NULL,
	[customicon1id] [dbo].[udtId] NULL,
	[customicon1url] [dbo].[udtURL] NULL,
	[customicon1tooltip] [dbo].[udtValue] NULL,
	[customnavigate1url] [dbo].[udtURL] NULL,
	[customicon2id] [dbo].[udtId] NULL,
	[customicon2url] [dbo].[udtURL] NULL,
	[customicon2tooltip] [dbo].[udtValue] NULL,
	[customnavigate2url] [dbo].[udtURL] NULL,
	[customicon3id] [dbo].[udtId] NULL,
	[customicon3url] [dbo].[udtURL] NULL,
	[customicon3tooltip] [dbo].[udtValue] NULL,
	[customnavigate3url] [dbo].[udtURL] NULL,
	[customicon4id] [dbo].[udtId] NULL,
	[customicon4url] [dbo].[udtURL] NULL,
	[customicon4tooltip] [dbo].[udtValue] NULL,
	[customnavigate4url] [dbo].[udtURL] NULL,
	[customicon5id] [dbo].[udtId] NULL,
	[customicon5url] [dbo].[udtURL] NULL,
	[customicon5tooltip] [dbo].[udtValue] NULL,
	[customnavigate5url] [dbo].[udtURL] NULL,
	[emailid] [dbo].[udtId] NULL,
	[email] [dbo].[udtEmail] NULL,
	[haschildren] [bit] NOT NULL,
	[childcount] [int] NULL,
	[positionparentid] [dbo].[udtId] NULL,
	[availabilitystatus] [dbo].[udtId] NOT NULL,
	[availabilitymessage] [dbo].[udtMessage] NULL,
	[availabilityiconurl] [dbo].[udtURL] NOT NULL,
	[directheadcount] [dbo].[udtId] NULL,
	[totalheadcount] [dbo].[udtId] NULL,
	[directftecount] [dbo].[udtDecimal2] NULL,
	[totalftecount] [dbo].[udtDecimal2] NULL,
	[IsVisible] [bit] NOT NULL,
	[UpdatedAvailabilityMessageDateTime] [datetime] NULL,
	[IsAssistant] [bit] NOT NULL,
	[ActualChildCount] [int] NOT NULL,
	[ActualTotalCount] [int] NOT NULL,
 CONSTRAINT [IX_EmployeePositionInfo2] UNIQUE CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeePositionInfo2] ADD  CONSTRAINT [DF_EmployeePositionInfo2_IsVisible]  DEFAULT ((1)) FOR [IsVisible]
ALTER TABLE [dbo].[EmployeePositionInfo2] ADD  CONSTRAINT [DF_EmployeePositionInfo2_IsAssistant]  DEFAULT ((0)) FOR [IsAssistant]
ALTER TABLE [dbo].[EmployeePositionInfo2] ADD  CONSTRAINT [DF_EmployeePositionInfo2_ActualChildCount]  DEFAULT ((0)) FOR [ActualChildCount]
ALTER TABLE [dbo].[EmployeePositionInfo2] ADD  CONSTRAINT [DF_EmployeePositionInfo2_ActualTotalCount]  DEFAULT ((0)) FOR [ActualTotalCount]
