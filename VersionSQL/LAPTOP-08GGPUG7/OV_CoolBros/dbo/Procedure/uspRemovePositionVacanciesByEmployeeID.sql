/****** Object:  Procedure [dbo].[uspRemovePositionVacanciesByEmployeeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspRemovePositionVacanciesByEmployeeID](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @positionId int = 0;
	DECLARE @vacantId int = 0;
	SELECT @positionId = positionid FROM EmployeePosition WHERE EmployeeID = @empId AND IsDeleted = 0 AND primaryposition = 'Y';

	SELECT @vacantId = id FROM Employee WHERE identifier = 'Vacant';

	IF @positionId > 0 BEGIN
		DECLARE @epId int = 0;
		SELECT TOP 1 @epId = id FROM EmployeePosition WHERE EmployeeID = @vacantId AND PositionID = @positionId;
		PRINT @positionId
		print @vacantId;
		IF @epId > 0 BEGIN
			UPDATE EmployeePosition SET IsDeleted = 1 WHERE id = @epId;
			UPDATE EmployeePositionInfo SET IsVisible = 0 WHERE id = @epId;
			EXEC uspRunUpdatePreference @epId, @vacantId, @positionId
		END
	END
END


