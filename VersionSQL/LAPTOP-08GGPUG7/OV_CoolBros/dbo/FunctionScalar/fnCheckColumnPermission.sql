/****** Object:  Function [dbo].[fnCheckColumnPermission]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnCheckColumnPermission](@columnName varchar(100), @prefix varchar(10), @loggedInPositionId int, @userId int, @empId int, @posID int, @IsManager bit)
RETURNS int
AS
BEGIN
	DECLARE @attId int;
	SELECT @attId = a.id FROM Attribute a
	INNER JOIN
	Entity e ON e.id = a.entityId
	WHERE e.code = @prefix AND a.columnname = @columnName

	IF(@attId IS NOT NULL) BEGIN
		RETURN dbo.fnCheckPermission(@loggedInPositionId, @userId, @attId, @empId, @posId, @IsManager)
	END

	RETURN 0;

END


