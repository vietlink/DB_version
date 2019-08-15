/****** Object:  Procedure [dbo].[uspGetMasterTableValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Raji Prasad>  
-- Create date: <13-11-2013>  
-- Description: <Getting Admin Master Table Values>  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetMasterTableValue](@sqlTable varchar(50))  
AS  
BEGIN  
  
DECLARE @SQL VARCHAR(200)  
SET @sql = 'select Id,name from '+@sqlTable+' order by name'  
EXEC(@sql)  
  
END  
