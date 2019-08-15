/****** Object:  Procedure [dbo].[uspGetAttributesSortedByGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAttributesSortedByGroup](@idList varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @attList TABLE(id int);

    IF CHARINDEX(',', @idList, 0) > 0 BEGIN
		INSERT INTO @attList -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@idList, ',');
    END

	SELECT 
		a.*
	FROM
		Attribute a
	INNER JOIN
		AttributeGroupRelations agr
	ON
		agr.AttributeID = a.id
	WHERE
		a.ID IN	(SELECT ID FROM @attList)
	ORDER BY
		agr.SortOrder

END

