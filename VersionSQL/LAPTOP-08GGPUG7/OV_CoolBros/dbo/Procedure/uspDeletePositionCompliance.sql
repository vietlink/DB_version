/****** Object:  Procedure [dbo].[uspDeletePositionCompliance]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeletePositionCompliance](@listid int, @posid int, @updatedby varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @pclId int = 0;
	SELECT @pclId = id FROM PositionCompetencyList WHERE competencylistid = @listid AND Positionid = @posid;
    DELETE FROM PositionCompetencyList WHERE id = @pclId;

	DECLARE @compDesc varchar(255);
	SELECT
		@compDesc = c.[description]
	FROM
		CompetencyList cl
	INNER JOIN
		Competencies c
	ON
		cl.CompetencyId = c.id
	WHERE
		cl.id = @listid;

	DECLARE @idResultTable TABLE (id int);

	INSERT INTO @idResultTable EXEC dbo.uspGetAuditLogTypeIDByDesc 'Position Compliance', 'Delete';
	DECLARE @auditLogTypeIDDelete int = 0;
	SELECT @auditLogTypeIDDelete = id FROM @idResultTable;

	DECLARE @auditLogID int = 0;
	INSERT INTO
		AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
			VALUES(0, @posid, @pclId, @updatedby, GETDATE(), @auditLogTypeIDDelete, @compDesc)
	SET	@auditLogID = @@IDENTITY;

	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, '', 'Deleted', '');
END


