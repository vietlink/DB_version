/****** Object:  Procedure [dbo].[uspIsManager]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspIsManager](@parentEmpId int, @childEmpId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @id int;

	SELECT
		@id = childEP.ManagerID
	FROM
		Employee childE
	INNER JOIN
		EmployeePosition childEP
	ON
		childE.id = childEP.EmployeeID
	INNER JOIN
		Employee parentE
	ON
		parentE.id = @parentEmpId
	INNER JOIN
		EmployeePosition parentEP
	ON
		parentE.id = parentEP.employeeid
	WHERE
		childEP.ManagerID = parentEP.ID AND childE.id = @childEmpId

	RETURN ISNULL(@id, 0);
END

