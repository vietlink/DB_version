/****** Object:  Procedure [dbo].[uspGetParentPosition]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[uspGetParentPosition]    
as    
begin    
    
select ID,positionid  from EmployeePositionInfo where positionid =(select ID from Position where parentid is NULL  )  
end
