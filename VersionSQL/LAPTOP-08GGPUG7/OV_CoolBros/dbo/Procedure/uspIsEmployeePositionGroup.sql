/****** Object:  Procedure [dbo].[uspIsEmployeePositionGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspIsEmployeePositionGroup](@empPosId int, @result bit output)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
		@result = p.isplaceholder
	FROM
		EmployeePosition ep
	INNER JOIN
		Position p
	ON
		p.id = ep.positionid
	WHERE ep.id = @empPosId

	IF @result IS NULL
		SET @result = 0;
    
END


