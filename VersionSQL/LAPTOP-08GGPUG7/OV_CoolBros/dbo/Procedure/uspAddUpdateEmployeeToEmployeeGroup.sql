/****** Object:  Procedure [dbo].[uspAddUpdateEmployeeToEmployeeGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateEmployeeToEmployeeGroup](@empGroupId int, @empId int, @isLeader bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	    IF NOT EXISTS(SELECT * FROM EmployeeGroupEmployee WHERE employeegroupid = @empGroupId AND employeeid = @empId) BEGIN
		DECLARE @empidentifier varchar(255);
		SELECT @empidentifier = identifier FROM Employee WHERE id = @empId
		INSERT INTO EmployeeGroupEmployee(employeeid, employeegroupid, empidentifier, IsLeader)
			VALUES(@empId, @empGroupId, @empidentifier, @isLeader);
	END
	ELSE
		UPDATE
			EmployeeGroupEmployee
		SET
			IsLeader = @isLeader
		WHERE
		employeeid = @empId AND employeegroupid = @empGroupId			
	END

	RETURN @@IDENTITY

