/****** Object:  Procedure [dbo].[uspRemovePositionRequirementsForEmployee]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspRemovePositionRequirementsForEmployee](@empId int, @posId int, @updatedBy varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @idList TABLE(listid int);

	INSERT INTO @idList
		SELECT pcl.CompetencyListID FROM PositionCompetencyList pcl
		INNER JOIN
		CompetencyList cl
		ON
		cl.id = pcl.CompetencyListId
		INNER JOIN
		Competencies c
		ON
		c.id = cl.CompetencyId
		WHERE pcl.PositionId = @posId AND c.[type] = 2

	DECLARE @count int;
	SELECT @count = count(*) FROM @idList;

	DECLARE @isMandatory bit;

	WHILE @count > 0 BEGIN
		DECLARE @listId int;
		SELECT TOP 1 @listId = listid FROM @idList;
		
	--	SELECT @isMandatory = isMandatory FROM PositionCompetencyList WHERE competencylistid = @listid AND positionid = @posid;
	--	DECLARE @dateTimeNow datetime = GETDATE();
		EXEC uspRemoveEmployeeComplianceRequirement @empId, @posId, @listId
		DELETE TOP (1) FROM @idList;
		SELECT @count = count(*) FROM @idList;
	END
END


