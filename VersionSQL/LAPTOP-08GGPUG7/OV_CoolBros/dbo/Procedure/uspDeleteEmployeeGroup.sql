/****** Object:  Procedure [dbo].[uspDeleteEmployeeGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspDeleteEmployeeGroup]  
   
(  
 @id udtId  
)  
  
  
/* ----------------------------------------------------------------------------------------------------------------  
 Name:  : uspDeleteEmployeeGroup  
 Description : Delete a record from the EmployeeGroup table.  
 Author(s) : Clark Sayers  
 Date  : 01-October-2004  
 Notes  :  
-------------------------------------------------------------------------------------------------------------------  
 REVISIONS :  
 $Author  : $  
 $Date  : $  
 $History : $  
 $Revision  : $  
------------------------------------------------------------------------------------------------------------------- */  
   
   
AS  
  
  
  
SET NOCOUNT ON  

 DELETE from EmployeeGroupEmployee where employeegroupid =@id 
  
   
 DELETE  
 FROM [dbo].[EmployeeGroup] WHERE id = @id   
 IF @@error != 0  
 BEGIN  
    
RAISERROR ('uspDeleteEmployeeGroup: Error deleting record from [orgview].[dbo].[EmployeeGroup]', 18, 1)  
  
  RETURN 1    
 END  
   
  
   
SET NOCOUNT OFF  
  
RETURN 0
