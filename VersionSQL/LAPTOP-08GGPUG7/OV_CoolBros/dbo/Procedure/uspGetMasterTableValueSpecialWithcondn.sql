/****** Object:  Procedure [dbo].[uspGetMasterTableValueSpecialWithcondn]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  <Raji Prasad>      
-- Create date: <22-11-2013>      
-- Description: <Getting Admin Master Table Special >      
-- =============================================      
CREATE PROCEDURE [dbo].[uspGetMasterTableValueSpecialWithcondn](@sqlTable varchar(100),@SelectFields varchar(300),@condn varchar(1000))      
AS      
BEGIN      
      
DECLARE @SQL VARCHAR(3000)  
if(@condn<>'')      
SET @sql = 'select '+@SelectFields+' from '+@sqlTable +' where '+@condn     
else  
SET @sql = 'select '+@SelectFields+' from '+@sqlTable   
print @sql
EXEC(@sql)      
      
END

