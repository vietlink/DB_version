/****** Object:  Procedure [dbo].[uspGetFieldValueLists]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetFieldValueLists](@search varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		fvl.*,
		ISNULL(CountSet.ItemCount, 0) as ItemCount,
		CASE WHEN (SELECT TOP 1 ID FROM Attribute WHERE FieldValueListID = fvl.id) IS NOT NULL THEN 1 ELSE 0 END AS IsAssigned
	FROM
		FieldValueList fvl
	LEFT OUTER JOIN
		(SELECT FieldValueListId, COUNT(*) as ItemCount FROM FieldValueListItem WHERE IsDeleted = 0 GROUP BY FieldValueListID) as CountSet 
	ON
		CountSet.FieldValueListId = fvl.id
	WHERE
		IsDeleted = 0 AND IsSystem = 0
	AND
		[Description] like '%' + @search + '%'
	ORDER BY [Description]
END

