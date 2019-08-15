/****** Object:  Procedure [dbo].[uspGetVideos]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetVideos](@search varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT v.*, vg.Name as GroupName, vg.Id as GroupID FROM Videos v
	INNER JOIN VideoGroups vg
	ON vg.id = v.VideoGroupID WHERE
	v.Name LIKE '%' + @search + '%' OR v.Keywords LIKE '%' + @search + '%' OR vg.Name LIKE '%' + @search + '%'
	ORDER BY vg.Name, v.Name
END


