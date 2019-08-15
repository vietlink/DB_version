/****** Object:  Procedure [dbo].[uspGetMandatoryAddPositionFields]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetMandatoryAddPositionFields]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @posEntity int = 0;
	SELECT @posEntity = id FROM Entity WHERE tablename = 'Position'

	SELECT
		a.id as attributeid, a.columnname, a.shortname, a.datatype, e.tablename, e.code as EntityCode,
		COLUMNPROPERTY(OBJECT_ID(e.tablename, 'U'), a.columnname, 'AllowsNull') as AllowsNull
	FROM
		Attribute a
	INNER JOIN
		Entity e
	ON
		e.id = a.entityid
	WHERE a.code IN ('posid', 'postitle') AND entityid = @posEntity
	ORDER BY e.Ordering, a.sortorder
	
END


