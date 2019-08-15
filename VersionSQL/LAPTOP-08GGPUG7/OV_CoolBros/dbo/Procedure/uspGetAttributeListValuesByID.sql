/****** Object:  Procedure [dbo].[uspGetAttributeListValuesByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAttributeListValuesByID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		v.*
	FROM
		Attribute a
	INNER JOIN
		FieldValueList l
	ON
		l.id = a.FieldValueListID
	INNER JOIN
		FieldValueListItem v
	ON
		v.FieldValueListID = l.id
	WHERE
		a.id = @id AND v.IsDeleted = 0 AND l.IsDeleted = 0
	ORDER BY v.Value
END


