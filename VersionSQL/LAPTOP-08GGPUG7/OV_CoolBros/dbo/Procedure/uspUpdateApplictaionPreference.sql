/****** Object:  Procedure [dbo].[uspUpdateApplictaionPreference]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdateApplictaionPreference](@CustomField varchar(50),@Attribute varchar(100),@LookUp varchar(100),@Value varchar(100),@ReturnValue int output)  
AS  
BEGIN  
declare @Count int  
SET @Count =0  
declare @AppPrefId int  
  
SET @AppPrefId =(select id from ApplicationPreference where preferenceid in (select id from Preference where code like ''+@CustomField+''))  

UPDATE ApplicationPreference SET  
  value =@Attribute,[type]='Attribute' WHERE ID=@AppPrefId  
SET @Count =@Count +1  
   
SET @AppPrefId =0  
SET @AppPrefId =(select id from ApplicationPreference where preferenceid in (select id from Preference where code like ''+@CustomField+'Value'  
))  
PRINT @AppPrefId  
UPDATE ApplicationPreference SET  
  value =@LookUp,[type]='Lookup'  WHERE ID=@AppPrefId  
SET @Count =@Count +1   
  
SET @AppPrefId =0   
SET @AppPrefId =(select id from ApplicationPreference where preferenceid in (select id from Preference where code like ''+@CustomField+'id'  
))  
PRINT @AppPrefId  
UPDATE ApplicationPreference SET  
  value =@Value,[type]='Value' WHERE ID=@AppPrefId  
SET @Count =@Count +1  
  
SET @ReturnValue =@Count   
return @ReturnValue     
END  
