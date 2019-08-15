/****** Object:  Procedure [dbo].[uspUpdateUnassignedParent]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateUnassignedParent] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @actualParentPosition int = NULL;
	SELECT @actualParentPosition = id FROM Position WHERE parentid IS NULL AND IsUnassigned = 0 AND IsDeleted = 0
	UPDATE Position SET parentid = @actualParentPosition, DefaultExclFromSubordCount = 'Y' WHERE IsUnassigned = 1
END

