/****** Object:  Procedure [dbo].[uspSetEmptyParentEmpPos]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetEmptyParentEmpPos]
AS
BEGIN
	DECLARE @unassignedId int = 0;
	SELECT @unassignedId = id FROM Position WHERE IsUnassigned = 1

	DECLARE posScan CURSOR
	FOR
	SELECT
		p.ID
	FROM
		Position p
	WHERE
		p.IsDeleted = 0 AND
		p.Isplaceholder = 0 AND
		p.parentid <> @unassignedId
		AND
		ID NOT IN
		(
			SELECT
				ep.PositionID
			FROM
				EmployeePosition ep
			INNER JOIN
				Employee e
			ON
				e.id = ep.employeeid
			INNER JOIN
				[Status] s
			ON
				s.[Description] = e.[status]
			WHERE
				e.IsDeleted = 0 AND ep.IsDeleted = 0 AND s.IsVisibleChart = 1 AND e.identifier <> 'Vacant'
		)
	--	AND
	--	dbo.uspGetTotalHeadCountRecursive(p.ID) > 0

	DECLARE @vacantId int = 0;
	SELECT @vacantId = id FROM Employee WHERE identifier = 'Vacant'

	DECLARE @posId int;
	OPEN posScan
	FETCH NEXT FROM 
		posScan
	INTO 
		@posId
	IF @posId > 0 BEGIN
		DECLARE @empPosNewId int = 0;
		IF EXISTS(SELECT id FROM EmployeePosition WHERE employeeid = @vacantId AND positionid = @posId) BEGIN
			UPDATE EmployeePosition SET IsDeleted = 0 WHERE employeeid = @vacantId AND positionid = @posId
			SELECT @empPosNewId = id FROM EmployeePosition WHERE employeeid = @vacantId AND positionid = @posId
			IF NOT EXISTS (SELECT id FROM EmployeePositionInfo WHERE employeeid = @vacantId AND positionid = @posId) BEGIN
			INSERT INTO
				EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
				customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
					VALUES(@empPosNewId, @vacantId, @posId, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
			END
			ELSE BEGIN
				UPDATE EmployeePositionInfo SET IsVisible = 1 WHERE ID = @empPosNewId;
			END
			EXEC uspRunUpdatePreference @empPosNewID, @vacantId, @posId, 1;
		END
		ELSE
		BEGIN
			INSERT INTO EmployeePosition(employeeid, positionid, primaryposition, fte, vacant, Managerial, ExclFromSubordCount)
				VALUES(@vacantId, @posId, 'Y', 1, 'Y', 'N', 'N');
			SET @empPosNewId = @@IDENTITY;
			IF NOT EXISTS (SELECT id FROM EmployeePositionInfo WHERE employeeid = @vacantId AND positionid = @posId) BEGIN
			INSERT INTO
				EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
				customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
					VALUES(@empPosNewId, @vacantId, @posId, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
				EXEC uspRunUpdatePreference @empPosNewID, @vacantId, @posId, 1;
			END
			ELSE BEGIN
				UPDATE EmployeePositionInfo SET IsVisible = 1 WHERE ID = @empPosNewId;
				EXEC uspRunUpdatePreference @empPosNewID, @vacantId, @posId, 1;
			END
		END
		WHILE @@FETCH_STATUS = 0
		BEGIN
			FETCH NEXT FROM
				posScan
			INTO
				@posId
			IF @posId > 0 
			BEGIN
				IF EXISTS(SELECT id FROM EmployeePosition WHERE employeeid = @vacantId AND positionid = @posId) 
				BEGIN
					UPDATE EmployeePosition SET IsDeleted = 0 WHERE employeeid = @vacantId AND positionid = @posId
					SELECT @empPosNewId = id FROM EmployeePosition WHERE employeeid = @vacantId AND positionid = @posId

					IF NOT EXISTS (SELECT id FROM EmployeePositionInfo WHERE employeeid = @vacantId AND positionid = @posId)
					BEGIN 
						INSERT INTO
						EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
						customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
							VALUES(@empPosNewId, @vacantId, @posId, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
					END
					ELSE BEGIN
						UPDATE EmployeePositionInfo SET IsVisible = 1 WHERE ID = @empPosNewId;
					END
					EXEC uspRunUpdatePreference @empPosNewID, @vacantId, @posId, 1;
				END
				ELSE 
				BEGIN
				
					INSERT INTO EmployeePosition(employeeid, positionid, primaryposition, fte, vacant, Managerial, ExclFromSubordCount)
						VALUES(@vacantId, @posId, 'Y', 1, 'Y', 'N', 'N');
					SET @empPosNewId = @@IDENTITY;
					
					IF NOT EXISTS (SELECT id FROM EmployeePositionInfo WHERE employeeid = @vacantId AND positionid = @posId)
					BEGIN
						INSERT INTO
						EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
						customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
							VALUES(@empPosNewId, @vacantId, @posId, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
						EXEC uspRunUpdatePreference @empPosNewID, @vacantId, @posId, 1;
					END
					ELSE BEGIN
						UPDATE EmployeePositionInfo SET IsVisible = 1 WHERE ID = @empPosNewId;
						EXEC uspRunUpdatePreference @empPosNewID, @vacantId, @posId, 1;
					END
				END
			END
		END
	END
	CLOSE posScan
	DEALLOCATE posScan

END

