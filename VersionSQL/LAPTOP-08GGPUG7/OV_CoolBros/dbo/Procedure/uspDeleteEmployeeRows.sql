/****** Object:  Procedure [dbo].[uspDeleteEmployeeRows]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[uspDeleteEmployeeRows]        
as        
begin        
        
delete from employeepositioninfo  where employeeid in (select id from employee where iflag=0)                 
delete from employeeposition  where employeeid in (select id from employee where iflag=0)           
--delete from employeeReference where employeeid in (select id from employee where iflag=0)          
delete from employeecontact where employeeid in(select id from employee where iflag=0)          
          
delete from employee where id in (select id from employee where iflag=0)       
        
end
