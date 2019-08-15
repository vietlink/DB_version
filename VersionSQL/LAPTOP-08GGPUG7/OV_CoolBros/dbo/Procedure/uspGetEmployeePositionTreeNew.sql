/****** Object:  Procedure [dbo].[uspGetEmployeePositionTreeNew]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  
    procedure [dbo].[uspGetEmployeePositionTreeNew] (@parentid int)     
as      
      
create table #tree      
( node  int not null identity(1,1),      
 parentnode int,      
 id  int,      
 parentid int,      
 employeeid int,      
 depth  int,      
 lineage  varchar(255),      
 displayname varchar(1000)      
)      
      
insert into #tree      
( id, parentid, employeeid, displayname      
)      
SELECT distinct      
 p.id,      
 p.parentid,      
 e.id,      
 e.displayname      
FROM Position p,      
 Employee e,      
 EmployeePosition ep      
where p.id = ep.positionid      
and e.id = ep.employeeid      
and e.IsDeleted = 0 and ep.IsDeleted = 0 and p.IsUnassigned = 0
      
update t      
set t.parentnode = tp.node      
from #Tree t,      
 Position p,      
 Position pp,      
 #Tree tp      
where t.id = p.id      
and p.parentid = pp.id      
and pp.id = tp.id     
and pp.IsDeleted = 0
and p.IsDeleted = 0 
      
update #Tree      
set lineage = '/',      
 depth = 0      
where parentnode is null      
      
while exists (select * from #tree where depth is null)      
begin      
 update  t      
 set t.depth = p.depth + 1,      
  --t.lineage = p.lineage + ltrim(str(t.parentid, 6, 0)) + '/'      
  t.lineage = p.lineage + ltrim(str(t.parentnode, 6, 0)) + '/'      
 from #tree t,      
  #tree p      
 where t.parentnode = p.node      
 and p.depth >= 0      
 and p.lineage is not null      
 and t.depth is null      
end      
      
/*select *      
from #tree*/      
  
if( @parentid <>  0)  
begin   
  
select ep.id  'id',      
 e.id  'employeeid',    
 picture as 'pic',     
 t.displayname,      
 p.id  'positionid',      
 p.parentid 'positionparentid',      
 p.title,      
 p.orgunit1,      
 t.node,      
 t.parentnode,      
 t.depth,      
 t.lineage,      
 t.lineage + ltrim(str(t.node, 6, 0))      
from Employee e
inner join
 EmployeePosition ep
on e.id = ep.employeeid  
inner join
 Position p
 on p.id = ep.positionid    
inner join
 #tree t
on p.id = t.id and e.id = t.employeeid  and  p.parentid=@parentid
inner join [status] s on s.[Description] = e.[status]
where e.isdeleted = 0
and ep.isdeleted = 0
and p.isdeleted = 0
and p.IsUnassigned = 0
and s.IsVisibleChart = 1
order by p.parentid  
  
end   
else  
begin   
select ep.id  'id',      
 e.id  'employeeid',    
 picture as 'pic',     
 t.displayname,      
 p.id  'positionid',      
 p.parentid 'positionparentid',      
 p.title,      
 p.orgunit1,      
 t.node,      
 t.parentnode,      
 t.depth,      
 t.lineage,      
 t.lineage + ltrim(str(t.node, 6, 0))      
from Employee e
inner join
 EmployeePosition ep
on e.id = ep.employeeid  
inner join
 Position p
 on p.id = ep.positionid    
inner join
 #tree t
on p.id = t.id and e.id = t.employeeid  and p.parentid is NULL
inner join [status] s on s.[Description] = e.[status]
WHERE
e.IsDeleted = 0
and ep.isdeleted = 0
and p.isdeleted = 0
and p.IsUnassigned = 0
and s.IsVisibleChart = 1
order by p.parentid  
  
end


