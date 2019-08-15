/****** Object:  Procedure [dbo].[uspUpdateAttributesOrder]    Committed by VersionSQL https://www.versionsql.com ******/

------------------------------------------------------------
CREATE PROCEDURE [dbo].[uspUpdateAttributesOrder]  
(@AttributeId int,  
@SortOrder int  
)  
AS  
BEGIN  
  
 Update Attribute   
 set   
  TabBasedSort  =@SortOrder   
 where Id=@AttributeId  
  
END  
