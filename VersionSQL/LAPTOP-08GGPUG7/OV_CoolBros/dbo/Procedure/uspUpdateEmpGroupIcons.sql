/****** Object:  Procedure [dbo].[uspUpdateEmpGroupIcons]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmpGroupIcons](@empId int, @groupId int, @code varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @groupTooltip varchar(100);
	DECLARE @groupImgUrl varchar(200);
	SELECT @groupTooltip = name, @groupImgUrl = 'employee group/' + icon FROM EmployeeGroup WHERE id = @groupId

	IF NOT EXISTS (SELECT id FROM EmployeeGroupEmployee WHERE employeegroupid = @groupId AND employeeid = @empId) BEGIN
		SET @groupTooltip = '';
		SET @groupImgUrl = '';
		SET @groupTooltip = '';
	END

	IF @code = 'customicon1url' BEGIN
		UPDATE EmployeePositionInfo SET customicon1id = @groupId, customicon1tooltip = @groupTooltip, customicon1url = @groupImgUrl WHERE employeeid = @empid
	END
	IF @code =  'customicon2url' BEGIN
		UPDATE EmployeePositionInfo SET customicon2id = @groupId, customicon2tooltip = @groupTooltip, customicon2url = @groupImgUrl WHERE employeeid = @empid
	END
	IF @code =  'customicon3url' BEGIN
		UPDATE EmployeePositionInfo SET customicon3id = @groupId, customicon3tooltip = @groupTooltip, customicon3url = @groupImgUrl WHERE employeeid = @empid
	END
	IF @code =  'customicon4url' BEGIN
		UPDATE EmployeePositionInfo SET customicon4id = @groupId, customicon4tooltip = @groupTooltip, customicon4url = @groupImgUrl WHERE employeeid = @empid
	END
	IF @code =  'customicon5url' BEGIN
		UPDATE EmployeePositionInfo SET customicon5id = @groupId, customicon5tooltip = @groupTooltip, customicon5url = @groupImgUrl WHERE employeeid = @empid
	END
END


