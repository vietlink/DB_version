/****** Object:  Procedure [dbo].[uspUpdateDefaultWorkHour]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateDefaultWorkHour] 
	-- Add the parameters for the stored procedure here
	@id int , 
	@startTime varchar(8),
	@endTime varchar(8),
	@hour decimal (5,2),
	@extraHour decimal (5,2),
	@overtimeHour decimal (5,2),
	@enable bit,
	@ReturnValue int output 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@enable=0) begin
		set @startTime=null;
		set @endTime=null;
		set @hour=null;
		set @extraHour=null;
		set @overtimeHour=null;
	end
	update DefaultWorkHours
	set StartTime=@startTime,
	EndTime=@endTime,
	Hours= @hour,
	ExtraHours= @extraHour,
	OvertimeStartsAfter=@overtimeHour,
	IsEnabled=@enable	
	where ID=@id
	IF @@error != 0
	BEGIN
		SET @ReturnValue =0
	
	END
	
	ELSE
	BEGIN
	
		SET @ReturnValue =@id 
	END
END
