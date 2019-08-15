/****** Object:  Procedure [dbo].[uspGetPosByEmployeeid]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[uspGetPosByEmployeeid](@employeeid int,@posid int )  
as  
begin  
  
declare @Parentcheck int   
declare @Position int   
declare @Parent int  
set @Position = (select positionId from employeeposition  where employeeid=@employeeid and positionid=@posid)  
select parentid from position  where id=@Position  
end
