/****** Object:  Function [dbo].[fnCheckColumnPermissionValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnCheckColumnPermissionValue](@value varchar(max), @columnName varchar(100), @prefix varchar(10), @loggedInPositionId int, @userId int, @empId int, @posID int, @IsManager bit)
RETURNS varchar(max)
AS
BEGIN
	IF(dbo.fnCheckColumnPermission(@columnName, @prefix, @loggedInPositionId, @userId, @empId, @posID, @IsManager) = 1) BEGIN
		RETURN @value;
	END

	RETURN '';

END


