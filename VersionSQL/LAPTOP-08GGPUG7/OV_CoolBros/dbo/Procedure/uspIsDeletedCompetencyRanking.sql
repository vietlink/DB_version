/****** Object:  Procedure [dbo].[uspIsDeletedCompetencyRanking]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspIsDeletedCompetencyRanking] 
	-- Add the parameters for the stored procedure here
	@value varchar(50) , 
	@index int,
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @ReturnValue= (select IsDeleted
	from EmployeeCompetencyRankings
	where ShortDescription= @value or RankingIndex= @index)
END

