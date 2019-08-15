/****** Object:  Procedure [dbo].[uspUpdateCompetencyRanking]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateCompetencyRanking] 
	-- Add the parameters for the stored procedure here
	@id int , 
	@description varchar(50), @rankingIndex int, @excludeFromPosition bit, @ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	

	update EmployeeCompetencyRankings
	set ShortDescription=@description,
	RankingIndex=@rankingIndex,	
	ExclFromPosition=@excludeFromPosition
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

