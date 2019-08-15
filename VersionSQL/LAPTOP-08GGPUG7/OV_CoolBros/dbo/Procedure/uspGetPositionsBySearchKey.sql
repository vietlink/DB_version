/****** Object:  Procedure [dbo].[uspGetPositionsBySearchKey]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetPositionsBySearchKey](@Param_1 varchar(200))    
/* ----------------------------------------------------------------------------------------------------------------    
 Name:  : $FunctionName    
 Description : Retrieve all records in the Position table matching the key with Title, Description, Identifier.   
 Author(s) : Raji    
 Date  : 29-June-2012  
 Notes  :    
-------------------------------------------------------------------------------------------------------------------    
 REVISIONS :    
 $Author  : $    
 $Date  : $    
 $History : $    
 $Revision  : $    
------------------------------------------------------------------------------------------------------------------- */    
     
     
AS    
    
     
     
 SELECT  distinct title  
  --[id]    
  --,     
  --[title]    
  --,     
  --[description]    
  --,     
  --[occupancystatus]    
  --,     
  --[type]    
  --,     
  --[startdate]    
  --,     
  --[enddate]    
  --,     
  --[isassistant]    
  --,     
  --[orgunit1]    
  --,     
  --[orgunit2]    
  --,     
  --[orgunit3]    
  --,     
  --[orgunit4]    
  --,     
  --[orgunit5]    
  --,     
  --[orgunit6]    
  --,     
  --[orgunit7]    
  --,     
  --[orgunit8]    
  --,     
  --[orgunit9]    
  --,     
  --[orgunit10]    
  --,     
  --[location]    
  --,     
  --[parentid]    
  --,    
  --[identifier]    
 FROM [dbo].[Position]   
  
where title like '%' +@Param_1+ '%' or description like '%' +@Param_1+ '%' or identifier like '%' +@Param_1+ '%' or type like '%' +@Param_1+ '%'  
     
 IF @@error != 0    
 BEGIN    
      
RAISERROR ('General Error', 18, 1)    
    
  RETURN 1      
 END    
     
 RETURN 0
