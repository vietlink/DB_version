/****** Object:  Procedure [dbo].[uspDeleteempPositionRows]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[uspDeleteempPositionRows]    
as    
begin     
    
update Employeeposition set isdeleted = 1 where id in
 (select ep.id from Employeeposition ep left outer join employee e on e.id = ep.employeeid where e.accountname <> 'vacant' and ep.iflag=0)    
    
end

