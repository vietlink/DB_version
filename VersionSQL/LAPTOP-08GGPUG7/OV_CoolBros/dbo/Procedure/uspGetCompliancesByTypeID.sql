/****** Object:  Procedure [dbo].[uspGetCompliancesByTypeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompliancesByTypeID](@typeid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @groupid int = 0;
	DECLARE @code varchar(50);
	SELECT @code = code FROM CompetencyTypes WHERE id = @typeid;
	SELECT @groupid = id FROM CompetencyGroups WHERE Code = @code;

    SELECT cl.id as listid, c.*
	FROM Competencies c
	INNER JOIN
	CompetencyList cl
	ON cl.CompetencyId = c.id
	INNER JOIN
	CompetencyGroups cg
	ON cg.id = cl.CompetencyGroupId
	WHERE c.[Type] = 2 AND cg.ID = @groupId
END


