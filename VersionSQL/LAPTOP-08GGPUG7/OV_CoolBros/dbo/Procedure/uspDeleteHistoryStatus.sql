/****** Object:  Procedure [dbo].[uspDeleteHistoryStatus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteHistoryStatus](@id int, @empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @updateId int = 0;
	DECLARE @newStatus varchar(50);
	DECLARE @terminationReason varchar(255);
	DECLARE @regrettableLoss varchar(50);
	DECLARE @terminationDate datetime = null;

    SELECT TOP 1 @updateId = h.id, @terminationDate = h.StartDate, @newStatus = s.[description], @terminationReason = h.TerminationReason, @regrettableLoss = h.RegrettableLoss FROM EmployeeStatusHistory h
	INNER JOIN [status] s ON s.id = h.statusid
	WHERE employeeid = @empId AND h.id < @id
	ORDER BY h.id desc

	UPDATE EmployeeStatusHistory SET EndDate = null WHERE id = @updateId;
	DELETE FROM EmployeeStatusHistory WHERE id = @id;

	IF @terminationReason IS NULL
		SET @terminationDate = null;

	UPDATE Employee SET termination = @terminationDate, [status] = @newStatus, TerminationReason = @terminationReason, RegrettableLoss = @regrettableLoss
	WHERE id = @empId;

	RETURN @updateId;
END


