/****** Object:  Procedure [dbo].[uspCreatePlaceholder]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreatePlaceholder](@identifier varchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @availStatusId int = 0;
	SELECT @availStatusId = id FROM AvailabilityStatus WHERE code = 'avail';

	DECLARE @Empid int = 0;
	DECLARE @Posid int = 0;
	DECLARE @EPid int = 0;

	DECLARE @unassignedId int = 0;
	SELECT @unassignedId = id FROM Position WHERE IsUnassigned = 1;

	IF EXISTS (SELECT id FROM Position WHERE identifier = @identifier)
		RETURN -1;

    IF NOT EXISTS (SELECT id FROM Employee WHERE identifier = @identifier) BEGIN
		INSERT INTO Employee(identifier, availabilitystatusid, status, picture, IsPlaceholder, displayname, commencement)
			VALUES(@identifier, @availStatusId, 'Active', 'no_pic.gif', 1, '', Convert(date, getdate()))
		SET @Empid = @@IDENTITY;

		IF NOT EXISTS (SELECT ID FROM EmployeeContact WHERE employeeid = @Empid) BEGIN
			INSERT INTO EmployeeContact(employeeid)
				VALUES(@Empid);
		END

		DECLARE @statusId int = 0;
		SELECT @statusId = id FROM [status] WHERE code = 'a';
		IF NOT EXISTS (SELECT id FROM EmployeeStatusHistory WHERE employeeid = @Empid AND StatusID = @statusId) BEGIN
			INSERT INTO EmployeeStatusHistory(EmployeeID, StartDate, StatusID, LastUpdatedBy, LastUpdatedDate)
				VALUES(@Empid, Convert(date, getdate()), @statusId, 'system', Convert(date, getdate()));
		END

		SELECT @Posid = id FROM Position WHERE Identifier = @identifier
		IF @Posid > 0 BEGIN
			UPDATE Position SET IsPlaceholder = 1, IsDeleted = 0 WHERE id = @Posid;
			INSERT INTO EmployeePosition(EmployeeID, PositionID, ExclFromSubordCount, primaryposition)
				VALUES(@Empid, @Posid, 'Y', 'Y');
			SET @EPid = @@IDENTITY
		END
		ELSE BEGIN
			INSERT INTO Position(Identifier, IsPlaceholder, isassistant, description, title, DefaultExclFromSubordCount, parentid)
				VALUES(@identifier, 1, 'N', '', '', 'Y', @unassignedId);
			SET @Posid = @@IDENTITY;

			INSERT INTO EmployeePosition(EmployeeID, PositionID, ExclFromSubordCount, primaryposition)
				VALUES(@Empid, @Posid, 'Y', 'Y');
			SET @EPid = @@IDENTITY;
		END

		IF NOT EXISTS (SELECT id FROM EmployeePositionInfo WHERE employeeid = @empid AND positionid = @posid) BEGIN
			INSERT INTO
				EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
				customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
				VALUES(@EPid, @Empid, @Posid, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
		END
		RETURN @Empid;
	END
	ELSE BEGIN
		SELECT @Empid = id FROM Employee WHERE identifier = @identifier
		SELECT @Posid = id FROM Position WHERE Identifier = @identifier
		SELECT @EPid = id FROM EmployeePosition WHERE employeeid = @empid and positionid = @posid;
		UPDATE Employee SET IsDeleted = 0, IsPlaceholder = 1 WHERE id = @Empid;
		UPDATE Position SET IsDeleted = 0, IsPlaceholder = 1 WHERE id = @Posid;

		DECLARE @vacantId int = 0;
		SELECT @vacantId = id FROM Employee WHERE identifier = 'vacant';

		UPDATE EmployeePosition SET IsDeleted = 1 WHERE Employeeid = @vacantId AND positionid = @posid;
		UPDATE EmployeePositionInfo SET IsVisible = 0 WHERE Employeeid = @vacantId AND positionid = @posid;

		IF EXISTS (SELECT id FROM EmployeePosition WHERE EmployeeID = @empId AND Positionid = @posID) BEGIN
			UPDATE EmployeePosition SET IsDeleted = 0 WHERE Employeeid = @Empid AND Positionid = @Posid;
		END
		ELSE BEGIN
			INSERT INTO EmployeePosition(EmployeeID, PositionID, ExclFromSubordCount, primaryposition)
				VALUES(@Empid, @Posid, 'Y', 'Y');
		END

		IF NOT EXISTS (SELECT id FROM EmployeePositionInfo WHERE employeeid = @empid AND positionid = @posid) BEGIN
			INSERT INTO
				EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
				customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
				VALUES(@EPid, @Empid, @Posid, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
		END

		RETURN @Empid;
	END
	RETURN -1;
END

