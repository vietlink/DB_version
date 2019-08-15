/****** Object:  Procedure [dbo].[uspSetTopPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetTopPosition](@posId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE Position SET parentid = @posId WHERE parentid IS NULL;
    UPDATE Position SET parentid = NULL WHERE id = @posId;

	DECLARE @IsPlaceholder bit = 0;
	SELECT @IsPlaceholder = IsPlaceholder FROM Position WHERE id = @posId;

	IF(@IsPlaceholder = 1) BEGIN
		DECLARE @empId int = 0;
		DECLARE @posIdentifier varchar(255);

		SELECT @posIdentifier = identifier FROM Position WHERE id = @posId;
		SELECT @empId = id FROM Employee WHERE identifier = @posIdentifier

		DECLARE @empPosId int = 0;
		SELECT @empPosId = id FROM EmployeePosition WHERE employeeid = @empId AND positionid = @posId;

		IF NOT EXISTS (SELECT id FROM EmployeePositionInfo WHERE employeeid = @empId AND positionid = @posId) BEGIN
			INSERT INTO
				EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
				customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
					VALUES(@empPosId, @empId, @posId, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
		END
	
		EXEC uspRunUpdatePreference-- @empPosId, @empId, @posId;
	END
	ELSE BEGIN
		DECLARE @vacantId int = 0;
		SELECT @vacantId = id FROM Employee WHERE identifier = 'Vacant';

		DECLARE @newEmpPosId int = 0;

		IF EXISTS (SELECT id FROM EmployeePosition WHERE positionid = @posId AND employeeid = @vacantId) BEGIN
			UPDATE EmployeePosition SET IsDeleted = 0 WHERE positionid = @posId AND employeeid = @vacantId;
			SELECT @newEmpPosId = id FROM EmployeePosition WHERE positionid = @posId AND employeeid = @vacantId;
			PRINT @newEmpPosId;
		END
		ELSE BEGIN
			INSERT INTO EmployeePosition(positionid, employeeid, fte, managerial, primaryposition, ExclFromSubordCount)
				VALUES(@posId, @vacantId, NULL, 'N', 'Y', 'N');
			SET @newEmpPosId = @@IDENTITY; 
		END
	
		IF NOT EXISTS (SELECT id FROM EmployeePositionInfo WHERE employeeid = @vacantId AND positionid = @posId) BEGIN
			INSERT INTO
				EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
				customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
					VALUES(@newEmpPosId, @vacantId, @posId, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
		END
	
		EXEC uspRunUpdatePreference-- @newEmpPosId, @vacantId, @posId;
	END
END

