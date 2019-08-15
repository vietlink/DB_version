/****** Object:  Function [dbo].[fnCheckPermissionAttCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnCheckPermissionAttCode](@attCode varchar(100), @loggedInPositionId int, @userId int, @empId int, @posId int, @iAmManager bit)
RETURNS int
AS
BEGIN
	DECLARE @attId int;
	SELECT @attId = id FROM Attribute WHERE code = @attCode;
	IF(@attId IS NOT NULL) BEGIN
		RETURN dbo.fnCheckPermission(@loggedInPositionId, @userId, @attId, @empId, @posId, @iAmManager)
	END

	RETURN 0;
END


