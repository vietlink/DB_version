/****** Object:  Procedure [dbo].[uspGetSettings]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetSettings]  
/* ----------------------------------------------------------------------------------------------------------------  
 Name:  : $FunctionName  
 Description : Retrieve all records in the Setting table.  
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
  
   
   
 SELECT   
  [id]  
  ,   
  [code]  
  ,   
  [name]  
  ,   
  [description]  
  ,   
  [value]  
  ,   
  [datatype]  
  ,   
  [usereditable]  
    
 FROM [dbo].[Setting]    
   
 WHERE usereditable ='Y'   
   
 ORDER BY ordering  
   
   
 IF @@error != 0  
 BEGIN  
    
RAISERROR ('General Error', 18, 1)  
  
  RETURN 1    
 END  
   
 RETURN 0  
