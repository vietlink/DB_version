/****** Object:  Procedure [dbo].[uspGetPositionLocations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPositionLocations]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT ROW_NUMBER() OVER(ORDER BY rs.location ASC) as id, rs.* FROM(
    SELECT DISTINCT CASE WHEN ISNULL(location, '') = '' THEN '(Blank)' ELSE Location END AS Location FROM Position WHERE IsDeleted = 0
	) as rs
END


