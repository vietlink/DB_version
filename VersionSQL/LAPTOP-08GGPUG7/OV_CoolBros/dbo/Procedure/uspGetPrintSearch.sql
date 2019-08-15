/****** Object:  Procedure [dbo].[uspGetPrintSearch]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[uspGetPrintSearch](@name varchar(100))    
as begin    
    
select e.id as employeeid,p.id as positionid,e.displayname as displayname,p.title as position    
from employee e inner join employeeposition ep on e.id=ep.employeeid     
inner join position p on p.id=ep.positionid    
where e.isdeleted = 0 and p.IsUnassigned = 0 and p.isdeleted = 0 and ep.isdeleted = 0 and (e.displayname like '%'+@name+'%' or  e.firstname like '%'+@name+'%'or e.surname like '%'+@name+'%' or p.title like '%'+@name+'%' or p.description like '%'+@name+'%')    
    
end

