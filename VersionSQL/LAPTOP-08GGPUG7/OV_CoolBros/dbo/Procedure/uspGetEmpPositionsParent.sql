/****** Object:  Procedure [dbo].[uspGetEmpPositionsParent]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetEmpPositionsParent]         
 (      
  @EmpPosId int,    
  @ParentEmpPosId int output        
 )        
         
AS        
BEGIN        
        
set @ParentEmpPosId =(select top 1 id  from EmployeePositionInfo where positionid  =(select positionparentid from EmployeePositionInfo where id=@EmpPosId)  )      
if(@ParentEmpPosId is null)        
 set @ParentEmpPosId =0        
return @ParentEmpPosId        
        
END 

