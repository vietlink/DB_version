/****** Object:  Procedure [dbo].[uspDeleteSecurityGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspDeleteSecurityGroup]  
   
(  
 @id udtId  
)  
  
  
/* ----------------------------------------------------------------------------------------------------------------  
 Name:  : uspDeleteSecurityGroup  
 Description : Delete a record from the SecurityGroup table.  
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
 DELETE from RoleSecurityGroup where securitygroupid =@id 
  
   
 DELETE  
 FROM [dbo].[SecurityGroup] WHERE id = @id   
 IF @@error != 0  
 BEGIN  
    
RAISERROR ('uspDeleteSecurityGroup: Error deleting record from [orgview].[dbo].[SecurityGroup]', 18, 1)  
  
  RETURN 1    
 END  
   
  
   
SET NOCOUNT OFF  
  
RETURN 0
