/****** Object:  Procedure [dbo].[uspAddOrUpdateExpenseCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddOrUpdateExpenseCode] 
	-- Add the parameters for the stored procedure here
	@id int, @description varchar(50), @code varchar(10), @ReturnValue int output
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@id!=0) begin
		update ExpenseCode
		set 		
		Description=@description,
		Code= @code	
		where ID= @id
		set @ReturnValue=@id;
	end
	else begin
		insert into ExpenseCode(Description, Code)
		values
		(
		@description,
		@code		
		)
		set @ReturnValue= @@IDENTITY
	end
	
END

