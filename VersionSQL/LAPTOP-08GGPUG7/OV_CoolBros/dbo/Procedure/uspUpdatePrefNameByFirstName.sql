/****** Object:  Procedure [dbo].[uspUpdatePrefNameByFirstName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdatePrefNameByFirstName](@value varchar(max), @id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- UPDATE Employee SET firstnamepreferred = firstname WHERE id = @id AND (firstnamepreferred IS NULL OR firstnamepreferred = '');
END

