/****** Object:  Procedure [dbo].[uspCreateEPIRecord]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateEPIRecord](@empPosId int, @empId int, @posId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT id FROM EmployeePositionInfo WHERE id = @empPosId) BEGIN
		INSERT INTO
			EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
			customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
				VALUES(@empPosId, @empId, @posId, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
	END
END


