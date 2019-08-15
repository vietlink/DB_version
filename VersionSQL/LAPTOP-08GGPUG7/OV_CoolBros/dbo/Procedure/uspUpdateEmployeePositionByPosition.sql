/****** Object:  Procedure [dbo].[uspUpdateEmployeePositionByPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmployeePositionByPosition](@posId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @_empId int = 0;
	DECLARE @_posId int = 0;
	DECLARE @_empPosId int = 0;

	DECLARE scan CURSOR FOR
		SELECT
			id,
			employeeid,
			positionid
		FROM
			EmployeePosition
		WHERE
			positionid = @posId AND IsDeleted = 0
	OPEN scan
	FETCH NEXT FROM scan INTO
		@_empPosId, @_empId, @_posId;
	--EXEC dbo.uspRunUpdatePreference @_empPosId, @_empId, @_posId;
	WHILE @@FETCH_STATUS = 0 BEGIN
		EXEC dbo.uspRunUpdatePreference @_empPosId, @_empId, @_posId;	
		FETCH NEXT FROM scan INTO
			@_empPosId, @_empId, @_posId;
	END

	CLOSE scan;
	DEALLOCATE scan;		
END

