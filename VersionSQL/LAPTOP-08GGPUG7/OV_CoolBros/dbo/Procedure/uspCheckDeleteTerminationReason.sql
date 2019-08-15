/****** Object:  Procedure [dbo].[uspCheckDeleteTerminationReason]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckDeleteTerminationReason] 
	-- Add the parameters for the stored procedure here
	@value varchar(80) , 
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @countEmp int;
	declare @countStatus int;
    -- Insert statements for procedure here
	set @countEmp= (select count(n.id)
	from Employee n
	where n.TerminationReason=@value)
	set @countStatus = (SELECT COUNT (s.id)
	FROM EmployeeStatusHistory s 
	WHERE s.TerminationReason = @value)
	if (@countEmp+@countStatus>0) begin
		set @ReturnValue=0;
	end
	else begin
		set @ReturnValue =1;
	end
END
