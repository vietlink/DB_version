/****** Object:  Procedure [dbo].[uspIsDeletedPayrollCycleGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspIsDeletedPayrollCycleGroup] 
	-- Add the parameters for the stored procedure here
	@description varchar(300) , 
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @ReturnValue= (select IsDeleted 
	from PayrollCycleGroups
	where Description = @description)
END

