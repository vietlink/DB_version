/****** Object:  Procedure [dbo].[uspGetEmployeePositionInfoNe]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetEmployeePositionInfoNe](@SelectedColumns varchar(max),@Tables varchar(1000),@EmpPosInfoId int)        
AS        
BEGIN        
DECLARE @SQL nvarchar(max)        
declare @Employeeid int         
declare @PositionId int        
declare @EmpPosId int        
DECLARE @PARAMS nvarchar(1000)        
SET @Employeeid =(select employeeid from EmployeePositionInfo where id=@EmpPosInfoId)        
SET @PositionId =(select positionid from EmployeePositionInfo where id=@EmpPosInfoId)        
        
SET @EmpPosId =(select Id from EmployeePosition where employeeid=@Employeeid and positionid=@PositionId)        
    
if(@EmpPosId > 0)    
BEGIN      
SET @PARAMS ='@SelectedColumns varchar(max),@Tables varchar(1000),@EmpPosId int'      
SET @SQL ='select '+@SelectedColumns + ' from '+@Tables+' where EPI.Id='+Convert(varchar,@EmpPosInfoId) + 'order by E.firstname'        
EXECUTE sp_executesql @SQL,@PARAMS,@SelectedColumns,@Tables,@EmpPosId         
    
END    
else    
BEGIN    
    
SET @PARAMS ='@SelectedColumns varchar(max),@Tables varchar(1000)'        
SET @SQL ='select '+@SelectedColumns + ' from '+@Tables+''    
EXECUTE sp_executesql @SQL,@PARAMS,@SelectedColumns,@Tables       
      
END    
     
    
        
END

