/****** Object:  Procedure [dbo].[uspSetPositionPlaceholderDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetPositionPlaceholderDetails](@empId int, @title varchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @posId int = 0;
	SELECT @posId = id FROM Position WHERE identifier = (SELECT TOP 1 Identifier FROM Employee WHERE ID = @empId);
	DECLARE @vacantId int = 0;
	SELECT @vacantId = id FROM Employee WHERE Identifier = 'vacant';

	DECLARE @ident varchar(200);
	SELECT TOP 1 @ident = Identifier FROM Employee WHERE ID = @empId
	print @ident;
    UPDATE Position SET title = @title, [description]  = @title, IsPlaceholder = 1 WHERE id = @posId;
	UPDATE Employee SET DisplayName = @title, status='Active', isplaceholder = 1 WHERE id = @empId;
	UPDATE EmployeePositionInfo SET displayname = @title, positiontitle = @title WHERE employeeid = @empId;
	print @posid;
	IF EXISTS (SELECT ID FROM EmployeePosition WHERE Positionid = @posId AND Employeeid = @vacantId) BEGIN
		UPDATE EmployeePosition SET IsDeleted = 1 WHERE Positionid = @posId AND Employeeid = @vacantId
		UPDATE EmployeePositionInfo SET IsVisible = 0 WHERE Positionid = @posId AND Employeeid = @vacantId
	END
	IF NOT EXISTS (SELECT ID FROM EmployeePosition WHERE Positionid = @posId AND EmployeeID = @empId) BEGIN
		INSERT INTO EmployeePosition(EmployeeID, PositionID, ExclFromSubordCount, primaryposition)
		VALUES(@Empid, @Posid, 'N', 'Y');
	END
	ELSE BEGIN
		UPDATE EmployeePosition SET IsDeleted = 0 WHERE Positionid = @posId AND Employeeid = @empId;
	END
END

