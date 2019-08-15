/****** Object:  Procedure [dbo].[uspGetNewPeopleForManager]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetNewPeopleForManager](@managerId int, @search varchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @empId int = 0;
	SELECT @empId = EmployeeID FROM EmployeePosition WHERE id = @managerId;
	
	SELECT 
		ep.id, e.id as employeeid, p.id as positionid, e.displayname, p.title as position, ep.primaryposition
	FROM
		Employee e		    
	INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id
	INNER JOIN
		Position p
	ON
		ep.positionid = p.id AND ep.IsDeleted = 0
	WHERE (ep.managerid IS NULL or ep.managerid <> @managerid) AND @empId <> e.id AND e.identifier <> 'Vacant' AND e.isplaceholder = 0 AND p.IsUnassigned = 0 AND e.IsDeleted = 0 AND
	(e.displayname like '%' + @search + '%' or p.title like '%' + @search + '%')

END


