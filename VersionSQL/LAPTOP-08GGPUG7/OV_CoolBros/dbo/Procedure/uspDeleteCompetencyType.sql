/****** Object:  Procedure [dbo].[uspDeleteCompetencyType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteCompetencyType](@typeid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @desc VARCHAR(50);
	SELECT @desc = [Description] FROM CompetencyTypes WHERE Id = @typeid;
	DELETE FROM CompetencyGroups WHERE TypeId = @typeid AND [Description] LIKE @desc
	DELETE FROM CompetencyTypes WHERE Id = @typeid;
END

