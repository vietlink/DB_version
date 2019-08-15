/****** Object:  Procedure [dbo].[uspGetBuildOrgChartPositions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetBuildOrgChartPositions](@isGroupMode bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @unassignedId int = 0;
	SELECT @unassignedId = id FROM Position WHERE IsUnassigned = 1

	SELECT id, title, identifier FROM Position WHERE parentid = @unassignedId AND IsDeleted = 0
	AND
	((@isGroupMode = 0 AND IsPlaceholder = 0) OR (@isGroupMode = 1 AND IsPlaceHolder = 1))
	ORDER BY title
END

