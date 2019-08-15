/****** Object:  Table [dbo].[User]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[User](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[authenticationmethodid] [dbo].[udtId] NOT NULL,
	[accountname] [dbo].[udtLongName] NOT NULL,
	[password] [dbo].[udtLongName] NULL,
	[displayname] [dbo].[udtLongName] NOT NULL,
	[enabled] [dbo].[udtYesNo] NOT NULL,
	[usereditable] [dbo].[udtYesNo] NOT NULL,
	[type] [dbo].[udtName] NOT NULL,
	[ClientId] [int] NULL,
	[RequiresPasswordReset] [bit] NOT NULL,
	[HasBeenEmailed] [bit] NOT NULL,
	[WorkEmail] [varchar](255) NULL,
	[LastLoginDate] [datetime] NULL,
	[EmployeeIdentifier] [varchar](255) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [pkUser] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE UNIQUE NONCLUSTERED INDEX [idxUserName] ON [dbo].[User]
(
	[accountname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_RequiresPasswordReset]  DEFAULT ((0)) FOR [RequiresPasswordReset]
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_HasBeenEmailed]  DEFAULT ((0)) FOR [HasBeenEmailed]
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_AuthenticationMethod] FOREIGN KEY([authenticationmethodid])
REFERENCES [dbo].[AuthenticationMethod] ([id])
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_AuthenticationMethod]
