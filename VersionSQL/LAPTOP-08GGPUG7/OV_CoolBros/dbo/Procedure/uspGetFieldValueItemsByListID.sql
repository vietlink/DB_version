/****** Object:  Procedure [dbo].[uspGetFieldValueItemsByListID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetFieldValueItemsByListID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		*
	FROM
		FieldValueListItem
	WHERE
		FieldValueListID = @id AND IsDeleted = 0
	ORDER BY Value
END


