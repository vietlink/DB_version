/****** Object:  Function [dbo].[uspGetTotalHeadCountRecursive3]    Committed by VersionSQL https://www.versionsql.com ******/


CREATE FUNCTION [dbo].[uspGetTotalHeadCountRecursive3](@PositionId int)
RETURNS int
AS

BEGIN

--DECLARE @unassignedId int = 0;
--SELECT @unassignedId = id FROM position WHERE IsUnassigned = 1

--Actual count for drill down
DECLARE @EmpCount int = 0
DECLARE @VacantCount int = 0;

 WITH RPL (Id, ParentId, EmpPosId,employeeid,ExclFromSubordCount,EpIsDeleted,PIsDeleted,IsPlaceHolder) AS
  (  select P.id,P.parentid,EP.id,EP.employeeid,EP.ExclFromSubordCount, ep.isdeleted, p.isdeleted, p.isplaceholder    from EmployeePosition EP inner join employee e on e.id = ep.employeeid inner join Position  P on P.id=EP.positionid Where e.isdeleted = 0 and p.isdeleted = 0 and ep.isdeleted = 0 and p.IsUnassigned = 0 and P.parentid =@PositionId 

     UNION ALL
       select P.id,P.parentid,EP.id,EP.employeeid,EP.ExclFromSubordCount, ep.isdeleted, p.isdeleted, p.isplaceholder    from EmployeePosition EP, Employee e, Position P, RPL PARENT  WHERE (P.id=EP.positionid and p.isdeleted = 0 and ep.isdeleted = 0) and e.id = ep.employeeid and e.isdeleted = 0 and p.IsUnassigned = 0 and PARENT.Id=P.parentid
  )
  SELECT @EmpCount =(select count(distinct RPL.employeeid) FROM RPL INNER JOIN Employee e ON e.isdeleted = 0 and e.id = RPL.employeeid INNER JOIN [Status] s on s.[Description] = e.[status] and s.IsVisibleChart = 1 WHERE RPL.IsPlaceHolder = 0 AND e.Identifier <> 'Vacant' AND RPL.EpIsDeleted = 0 AND RPL.PIsDeleted = 0),
	@VacantCount =(select count(distinct RPL.EmpPosId) FROM RPL INNER JOIN Employee e ON e.isdeleted = 0 and e.id = RPL.employeeid WHERE RPL.IsPlaceHolder = 0 AND e.identifier = 'Vacant' AND RPL.EpIsDeleted = 0 AND RPL.PIsDeleted = 0);
  RETURN @EmpCount + @VacantCount
END
