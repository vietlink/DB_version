/****** Object:  Procedure [dbo].[uspGetAttributesByGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAttributesByGroup](@groupName varchar(50))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		a.*
	FROM
		Attribute a
	INNER JOIN
		AttributeGroupRelations agr
	ON
		agr.AttributeID = a.ID
	INNER JOIN
		AttributeGroups ag
	ON
		ag.ID = agr.AttributeGroupID
	WHERE
		ag.GroupName = @groupName
	ORDER BY
		agr.SortOrder
END

