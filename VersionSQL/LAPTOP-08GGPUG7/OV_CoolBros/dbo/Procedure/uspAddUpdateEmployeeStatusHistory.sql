/****** Object:  Procedure [dbo].[uspAddUpdateEmployeeStatusHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateEmployeeStatusHistory](@id int, @employeeId int, @statusId int, @startDate datetime, @endDate datetime,
	@terminationReason varchar(255), @regrettableLoss varchar(50), @lastUpdatedBy varchar(255), @lastUpdatedDate datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @code varchar(50);
	SELECT @code = code FROM [status] WHERE id = @statusid;

	IF @code <> 't' BEGIN
		SET @terminationReason = '';
		SET @regrettableLoss = '';
	END

    IF @id = 0 BEGIN -- add new
		INSERT INTO EmployeeStatusHistory(EmployeeID, StatusID, StartDate, EndDate, TerminationReason, RegrettableLoss, LastUpdatedBy, LastUpdatedDate)
			VALUES(@employeeId, @statusId, @startDate, @endDate, @terminationReason, @regrettableLoss, @lastUpdatedBy, @lastUpdatedDate)
	END
	ELSE BEGIN -- edit
		UPDATE EmployeeStatusHistory
			SET StatusID = @statusId,
			StartDate = @startDate,
			EndDate = @endDate,
			TerminationReason = @terminationReason,
			RegrettableLoss = @regrettableLoss,
			LastUpdatedBy = @lastUpdatedBy,
			LastUpdatedDate = @lastUpdatedDate
		WHERE
			ID = @id;
	END
END


