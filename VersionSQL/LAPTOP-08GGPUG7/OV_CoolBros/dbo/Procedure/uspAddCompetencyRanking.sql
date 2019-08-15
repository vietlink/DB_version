/****** Object:  Procedure [dbo].[uspAddCompetencyRanking]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddCompetencyRanking] 
	-- Add the parameters for the stored procedure here
	@description varchar(50), @rankingIndex int, @status bit, @excludeFromPosition bit, @ReturnValue int output
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@status=0) begin
		update EmployeeCompetencyRankings
		set 		
		ExclFromPosition=@excludeFromPosition,
		RankingIndex=@rankingIndex,
		IsDeleted=@status
		where ShortDescription=@description
		set @ReturnValue=1;
	end
	else begin
		insert into EmployeeCompetencyRankings(ShortDescription, RankingIndex, ExclFromPosition)
		values
		(@description, 
		@rankingIndex,	
		@excludeFromPosition
		)
		set @ReturnValue= @@IDENTITY
	end

	
END

