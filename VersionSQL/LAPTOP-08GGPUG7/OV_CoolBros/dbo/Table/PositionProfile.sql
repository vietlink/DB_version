/****** Object:  Table [dbo].[PositionProfile]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PositionProfile](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PositionID] [int] NOT NULL,
	[Profile] [varchar](max) NOT NULL,
 CONSTRAINT [PK_PositionProfile] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[PositionProfile]  WITH CHECK ADD  CONSTRAINT [FK_PositionProfile_Position] FOREIGN KEY([PositionID])
REFERENCES [dbo].[Position] ([id])
ALTER TABLE [dbo].[PositionProfile] CHECK CONSTRAINT [FK_PositionProfile_Position]
