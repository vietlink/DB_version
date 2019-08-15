/****** Object:  Function [dbo].[fnCheckPermissionValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnCheckPermissionValue](@value varchar(max), @loggedInPositionId int, @userId int, @attId int, @empId int, @posId int, @iAmManager bit)
RETURNS varchar(max)
AS
BEGIN
	IF(dbo.fnCheckPermission(@loggedInPositionId, @userId, @attId, @empId, @posId, @iAmManager) = 1) BEGIN
		RETURN @value;
	END
	RETURN '';

END


