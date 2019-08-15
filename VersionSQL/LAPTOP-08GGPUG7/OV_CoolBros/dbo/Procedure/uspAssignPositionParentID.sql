/****** Object:  Procedure [dbo].[uspAssignPositionParentID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAssignPositionParentID](@posId int, @parentId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE Position SET parentid = @parentId WHERE id = @posId;

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
	
		EXEC uspRunUpdatePreference @empPosId, @empId, @posId;
	END
	ELSE BEGIN
		DECLARE @activeCount int = 0;
		SELECT @activeCount = COUNT(ep.id) FROM EmployeePosition ep INNER JOIN Employee e ON ep.employeeid = e.id WHERE PositionID = @posId AND e.IsDeleted = 0 AND ep.IsDeleted = 0;

		IF @activeCount < 1 BEGIN
			DECLARE @empPosNewId int = 0;
			DECLARE @vacantId int = 0;
			SELECT @vacantId = id FROM employee WHERE identifier = 'Vacant';
			IF NOT EXISTS(SELECT id FROM EmployeePosition WHERE employeeid = @vacantId AND positionid = @posId) BEGIN
				INSERT INTO EmployeePosition(employeeid, positionid, primaryposition, fte, vacant, Managerial, ExclFromSubordCount)
					VALUES(@vacantId, @posId, 'Y', 1, 'Y', 'N', 'N');
				SET @empPosNewId = @@IDENTITY;
			END
			ELSE BEGIN
				UPDATE EmployeePosition SET IsDeleted = 0 WHERE employeeid = @vacantId AND positionid = @posId
				SELECT @empPosNewId = id FROM EmployeePosition WHERE employeeid = @vacantId AND positionid = @posId
			END
			IF NOT EXISTS (SELECT id FROM EmployeePositionInfo WHERE employeeid = @vacantId AND positionid = @posId) BEGIN
				INSERT INTO
				EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
					customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
						VALUES(@empPosNewId, @vacantId, @posId, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
			END
			EXEC uspRunUpdatePreference @empPosNewID, @vacantId, @posId;
		END
		ELSE BEGIN
			-- run mini update pref for each person in the position
			DECLARE epCursor CURSOR  
				FOR SELECT ep.id, ep.employeeid, ep.positionid FROM EmployeePosition ep INNER JOIN Employee e ON ep.employeeid = e.id WHERE PositionID = @posId AND e.IsDeleted = 0 AND ep.IsDeleted = 0;   
			OPEN epCursor  

			DECLARE @_epId int = 0;
			DECLARE @_empId int =  0;
			DECLARE @_posId int = 0;

			FETCH NEXT FROM epCursor INTO
				@_epId, @_empId, @_posId;

			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				EXEC uspRunUpdatePreference @_epId, @_empId, @_posId;
				FETCH NEXT FROM epCursor INTO
					@_epId, @_empId, @_posId;
			END

			CLOSE epCursor;  
			DEALLOCATE epCursor;  
		END
	END
END

