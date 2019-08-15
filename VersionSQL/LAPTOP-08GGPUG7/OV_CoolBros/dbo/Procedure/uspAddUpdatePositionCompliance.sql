/****** Object:  Procedure [dbo].[uspAddUpdatePositionCompliance]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdatePositionCompliance](@positionid int, @listid int, @updatedby varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idResultTable TABLE (id int);

	INSERT INTO @idResultTable EXEC dbo.uspGetAuditLogTypeIDByDesc 'Position Compliance', 'New';
	DECLARE @auditLogTypeIDNew int = 0;
	SELECT @auditLogTypeIDNew = id FROM @idResultTable

	DELETE FROM @idResultTable;
	INSERT INTO @idResultTable EXEC dbo.uspGetAuditLogTypeIDByDesc 'Position Compliance', 'Edit';
	DECLARE @auditLogTypeIDEdit int = 0;
	SELECT @auditLogTypeIDEdit = id FROM @idResultTable

    DECLARE @pclId int = 0;
	SELECT @pclId = id FROM PositionCompetencyList WHERE positionid = @positionid AND competencylistid = @listid;
	
	DECLARE @auditLogID int = 0;
	DECLARE @currentIsMandatory bit;

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

	IF @pclId > 0 BEGIN  -- edit
		return;
		
		--UPDATE
		--	PositionCompetencyList
		--SET
		--	IsMandatory = @ismandatory
		--WHERE
		--	id = @pclId;

		--INSERT INTO
			--AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
				--VALUES(0, @positionid, @pclId, @updatedby, GETDATE(), @auditLogTypeIDEdit, @compDesc)
		--SET	@auditLogID = @@IDENTITY;

		--INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			--VALUES(@auditLogID, 0, case when @currentIsMandatory = 1 then 'true' else 'false' end, case when @ismandatory = 1 then 'true' else 'false' end, 'Is Mandatory');

	END
	ELSE BEGIN  -- new
		INSERT INTO
			PositionCompetencyList(PositionId, CompetencyListId, IsMandatory)
				VALUES(@positionid, @listid, 1)

		INSERT INTO
			AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
				VALUES(0, @positionid, @pclId, @updatedby, GETDATE(), @auditLogTypeIDNew, @compDesc)
		SET	@auditLogID = @@IDENTITY;

		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, '', 'true', 'Is Required');
		DECLARE @dateTimeNow datetime = GETDATE();
		EXEC uspCreateEmployeeComplianceRequirements @positionid, @listid, @dateTimeNow, @updatedby, 1
	END

	IF @currentIsMandatory IS NULL BEGIN -- new
		EXEC uspUpdateIsMandatoryCompliance @positionid, @listid, 0;
	END
	ELSE BEGIN
		IF @currentIsMandatory = 0 BEGIN -- changed from optional to mandatory
			EXEC uspUpdateIsMandatoryCompliance @positionid, @listid, 0;
		END
	END
		

END


