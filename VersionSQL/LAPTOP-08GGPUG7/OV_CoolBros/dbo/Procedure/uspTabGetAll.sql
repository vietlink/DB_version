/****** Object:  Procedure [dbo].[uspTabGetAll]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspTabGetAll]  
  
AS  
  
SELECT  
 Id,   
 [Name],  
 [Enable],  
 TabOrder,
 Usereditable,
 [ProfileTab]
FROM  
 [dbo].[Tab]  
ORDER BY  
 TabOrder  
   
IF @@error != 0  
BEGIN  
 RAISERROR ('uspTabGetAll: Error reading record from [orgview].[dbo].[uspTabGetAll]', 18, 1)  
 RETURN 1    
END  
  
RETURN 0

