/****** Object:  Procedure [dbo].[uspGetCurrentStatusByDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCurrentStatusByDate](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT TOP 1 esh.*, s.[Description] as [Status], s.DoSoftDelete, s.IsVisibleChart FROM EmployeeStatusHistory esh
	INNER JOIN [Status] s
	ON
	s.id = esh.StatusID
	WHERE EmployeeID = @empId AND
	((s.code = 'T' AND StartDate < GETDATE()) OR
	(s.code <> 'T' AND CONVERT(DATETIME, CONVERT(varchar(11),StartDate, 111 ) + ' 00:00:00', 111) < GETDATE()))
	ORDER BY StartDate DESC
    
END

