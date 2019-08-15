/****** Object:  Procedure [dbo].[uspCreateEmployee]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateEmployee](@identifier varchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @availStatusId int = 0;
	SELECT @availStatusId = id FROM AvailabilityStatus WHERE code = 'avail';
	DECLARE @today datetime = DATEADD(d,0,DATEDIFF(d,0,GETDATE()));

	DECLARE @id int = 0;
    IF NOT EXISTS (SELECT id FROM Employee WHERE identifier = @identifier) BEGIN
		INSERT INTO Employee(identifier, availabilitystatusid, status, picture)
			VALUES(@identifier, @availStatusId, 'Active', 'no_pic.gif')
		SET @id = @@IDENTITY;
		INSERT INTO EmployeeContact(employeeid)
			VALUES(@id);
		DECLARE @unassignedPosId int = 0;
		DECLARE @DefaultExclFromSubordCount varchar(1) = 'Y'
		SELECT @unassignedPosId = id, @DefaultExclFromSubordCount = DefaultExclFromSubordCount FROM Position WHERE IsUnassigned = 1;
		DECLARE @empPosId int = 0;
		INSERT INTO
			EmployeePosition(employeeid, positionid, vacant, isdeleted, primaryposition, ExclFromSubordCount, startdate)
				VALUES(@id, @unassignedPosId, 'N', 0, 'Y', @DefaultExclFromSubordCount, @today);
		SELECT @empPosId = @@IDENTITY;
		INSERT INTO
			EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
			customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
				VALUES(@empPosId, @id, @unassignedPosId, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
						
		--INSERT INTO 
		--	EmployeePositionHistory(employeeid, positionid, primaryposition, startdate, enddate, fte, vacant,
		--	exclfromsubordcount, managerial, managerid)
		--	VALUES(@id, @unassignedPosId, 'Y', @today, NULL, 0, 'N', 'Y', 'N', NULL);
		RETURN @id;
	END
	RETURN -1;
END

