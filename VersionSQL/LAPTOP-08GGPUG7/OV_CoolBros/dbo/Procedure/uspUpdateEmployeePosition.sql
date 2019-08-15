/****** Object:  Procedure [dbo].[uspUpdateEmployeePosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmployeePosition](@id int, @fte decimal(18,8), @primary varchar(1), @manager varchar(1), @exclude varchar(1))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @empId int = 0;
	SELECT TOP 1 @empId = employeeid FROM employeeposition where id = @id;

	DECLARE @currentPrimaryCount int = 0;
	SELECT @currentPrimaryCount = COUNT(id) FROM EmployeePosition
		WHERE EmployeeID = @empId AND primaryposition = 'Y' AND IsDeleted = 0 AND id <> @id;

	IF @primary = 'Y' AND @currentPrimaryCount >= 1 BEGIN
		UPDATE EmployeePosition SET primaryposition = 'N' WHERE EmployeeID = @empId;
	END

	IF @currentPrimaryCount < 1 BEGIN
		SET @primary = 'Y';
	END

    UPDATE
		EmployeePosition
	SET
		fte = @fte,
		primaryposition = @primary,
		Managerial = @manager,
		ExclFromSubordCount = @exclude
	WHERE
		id = @id;
END

