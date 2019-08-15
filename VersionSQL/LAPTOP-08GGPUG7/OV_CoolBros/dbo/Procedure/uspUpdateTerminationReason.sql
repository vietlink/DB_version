/****** Object:  Procedure [dbo].[uspUpdateTerminationReason]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateTerminationReason] 
	-- Add the parameters for the stored procedure here
	@id int , 
	@name varchar(80),
	@group varchar(50),
	@ReturnValue int output 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @currentValue varchar(80);
	set @currentValue=( select t.Value from TerminationReasons t where t.ID=@id);

	update TerminationReasons
	set Value= @name,
	Grouping=@group
	where ID=@id

	update Employee
	set TerminationReason=@name
	where TerminationReason=@currentValue;

	update EmployeeStatusHistory
	set TerminationReason=@name
	where TerminationReason= @currentValue
	IF @@error != 0
	BEGIN
		SET @ReturnValue =0
	
	END
	
	ELSE
	BEGIN
	
		SET @ReturnValue =@id 
	END
END
