/****** Object:  Procedure [dbo].[uspGetStatusByValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetStatusByValue](@value varchar(50))
AS
BEGIN
	SELECT * FROM [Status] WHERE [Description] LIKE @value
END


