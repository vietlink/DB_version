/****** Object:  Procedure [dbo].[uspUpdatePayrollCycleGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdatePayrollCycleGroup] 
	-- Add the parameters for the stored procedure here
	@id int , 
	@description varchar(300),
	@PayrollCyclePeriodsID int,
	@startID int,
	@isNull int,
	@accountsSystemID int,
	@ReturnValue int output 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
	if (@isNull=0) begin
		set @startID=1;
	end
	update PayrollCycleGroups
	set PayrollCyclePeriodsID = @PayrollCyclePeriodsID,
	Description=@description, StartDayIndex= @startID,
	AccountsSystemID= @accountsSystemID
	where ID=@id
-- update related table needed
	
	IF @@error != 0
	BEGIN
		SET @ReturnValue =0
	
	END
	
	ELSE
	BEGIN
	
		SET @ReturnValue =@id 
	END
END

