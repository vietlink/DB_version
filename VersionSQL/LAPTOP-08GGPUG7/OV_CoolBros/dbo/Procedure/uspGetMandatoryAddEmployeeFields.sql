/****** Object:  Procedure [dbo].[uspGetMandatoryAddEmployeeFields]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetMandatoryAddEmployeeFields]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @empEntity int = 0;
	SELECT @empEntity = id FROM Entity WHERE tablename = 'Employee'

	SELECT
		a.id as attributeid, a.columnname, a.shortname, a.datatype, e.tablename, e.code as EntityCode,
		COLUMNPROPERTY(OBJECT_ID(e.tablename, 'U'), a.columnname, 'AllowsNull') as AllowsNull
	FROM
		Attribute a
	INNER JOIN
		Entity e
	ON
		e.id = a.entityid
	WHERE a.code IN ('empid', 'displayname', 'status', 'commencement') AND entityid = @empEntity
	ORDER BY e.Ordering, a.sortorder
	
END

