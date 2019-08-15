/****** Object:  Function [dbo].[uspGetEmployeeStatusVisible]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[uspGetEmployeeStatusVisible](@desc varchar(100), @positionid int = 0, @empPosId int = 0)
RETURNS bit
AS
BEGIN
	DECLARE @posVisible bit;
	DECLARE @posDeleted bit;
	SELECT @posVisible = IsVisibleChart, @posDeleted = IsDeleted FROM Position WHERE id = @positionid;
	IF @posVisible = 0 OR @posDeleted = 1
		RETURN 0;
	DECLARE @empPosDeleted bit;
	SELECT @empPosDeleted = IsDeleted FROM EmployeePosition WHERE id = @empPosId
	IF @empPosDeleted = 1
		RETURN 0;
	IF EXISTS(SELECT IsVisibleChart FROM [Status] WHERE [Description] LIKE @desc AND [Type] LIKE 'Employee') BEGIN
		DECLARE @resultVal bit;
		SELECT @resultVal = IsVisibleChart FROM [Status] WHERE [Description] LIKE @desc AND [Type] LIKE 'Employee';
		RETURN @resultVal;
	END
	RETURN 1;
END


