/****** Object:  Procedure [dbo].[uspCreateNewEmail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateNewEmail](@subject varchar(1000), @body varchar(max), @emailTo varchar(256))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO Emails([Subject], Body, EmailTo)
		Values(@subject, @body, @emailTo)
END


