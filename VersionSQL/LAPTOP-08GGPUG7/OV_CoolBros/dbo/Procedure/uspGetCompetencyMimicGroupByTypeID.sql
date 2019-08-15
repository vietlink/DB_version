/****** Object:  Procedure [dbo].[uspGetCompetencyMimicGroupByTypeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompetencyMimicGroupByTypeID](@typeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 cg.* FROM CompetencyTypes ct
	INNER JOIN
	CompetencyGroups cg
	ON cg.TypeId = ct.Id AND cg.[Description] = ct.[Description]
	WHERE ct.Id = @typeId
END


