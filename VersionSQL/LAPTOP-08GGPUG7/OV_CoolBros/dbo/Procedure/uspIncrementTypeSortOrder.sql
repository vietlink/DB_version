/****** Object:  Procedure [dbo].[uspIncrementTypeSortOrder]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspIncrementTypeSortOrder](@typeid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Inrement = reduce from sort order
    DECLARE @currentSortOrder int = 0;
    SELECT @currentSortOrder = SortOrder FROM CompetencyTypes WHERE Id = @typeid;
    
    IF @currentSortOrder > 1 BEGIN
		DECLARE @previousMaxSort int = 0;
		DECLARE @previousId int = 0;
		
		SELECT 
			@previousMaxSort = MAX(SortOrder)
		FROM 
			CompetencyTypes
		WHERE 
			SortOrder < @currentSortOrder
							
		IF @previousMaxSort > 0 BEGIN
			-- the one above
			UPDATE t SET t.SortOrder = @currentSortOrder FROM CompetencyTypes t WHERE t.SortOrder = @previousMaxSort;
			-- the one being changed
			UPDATE t SET t.SortOrder = @previousMaxSort FROM CompetencyTypes t WHERE t.Id = @typeid;
		END
	END

END

