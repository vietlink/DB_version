/****** Object:  Procedure [dbo].[uspGetEmployeePositionReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeePositionReport] 
	-- Add the parameters for the stored procedure here
	@empID int, @depth int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @managerPosID int 
	if (@empID !=0) begin
		set @managerPosID= isnull((select p.id from EmployeePosition ep 
		inner join Position p on ep.positionid= p.id
		where ep.primaryposition='Y' and ep.IsDeleted=0 and ep.employeeid=@empID),0)
	end else begin
		set @managerPosID= isnull((select p.id from EmployeePosition ep 
		inner join Position p on ep.positionid= p.id
		where ep.primaryposition='Y' and ep.IsDeleted=0 and p.parentid is null and p.IsDeleted=0 and p.iFlag=0),0)
	end
	;WITH EmpCTE (empID, empPosID, displayname, posID, title, fte, parentid, depth) AS
	(SELECT e.id as empID,
		ep.id as empPosID,
		e.displayname, 
		p.id as posID,
		p.title,
		ep.fte,
		isnull(p.parentid,0) as parentid,
		1 as depth
	FROM Employee e 
	INNER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' and ep.IsDeleted=0
	INNER JOIN Position p ON ep.positionid= p.id
	WHERE e.IsDeleted = 0 and p.IsUnassigned = 0 and p.parentid=@managerPosID
	and e.IsPlaceholder=0
	
	UNION ALL
	SELECT e.id as empID,
		ep.id as empPosID,
		e.displayname, 
		p.id as posID,
		p.title,
		ep.fte,
		isnull(p.parentid,0) as parentid,
		depth + 1 as depth
	FROM Employee e 
	INNER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' and ep.IsDeleted=0
	INNER JOIN Position p ON ep.positionid= p.id
	INNER JOIN EmpCTE ec ON p.parentid= ec.posID
	WHERE e.IsDeleted = 0 and p.IsUnassigned = 0 and e.IsPlaceholder=0 
)
select * from EmpCTE  where depth<=@depth
UNION
SELECT e.id as empID,
		ep.id as empPosID,
		e.displayname, 
		p.id as posID,
		p.title,
		ep.fte,
		isnull(p.parentid,0) as parentid,
		0 as depth
	FROM Employee e 
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' and ep.IsDeleted=0
	LEFT OUTER JOIN Position p ON ep.positionid= p.id
	where (e.id= @empID)
	or (@empID=0 and p.id= @managerPosID)
order by parentid

END

