/****** Object:  Procedure [dbo].[uspCheckUpdateOriginalCommencement]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckUpdateOriginalCommencement](@empId int, @date datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @deleteCount int = 0;
	DECLARE @activeCount int = 0;
	SELECT
		@deleteCount = COUNT(case when s.DoSoftDelete = 1 THEN 1 ELSE NULL END),
		@activeCount = COUNT(case when s.DoSoftDelete = 0 THEN 1 ELSE NULL END)
	FROM
		EmployeeStatusHistory esh
	INNER JOIN
		[Status] s
	ON
		esh.StatusID = s.Id
	WHERE esh.EmployeeID = @empId

	IF @deleteCount = 0 AND @activeCount = 1 BEGIN
		UPDATE Employee SET originalcommencement = @date WHERE id = @empId;
	END
END


