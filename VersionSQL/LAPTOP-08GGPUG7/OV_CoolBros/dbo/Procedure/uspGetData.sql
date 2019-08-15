/****** Object:  Procedure [dbo].[uspGetData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetData](@FromDate varchar(100),@ToDate varchar(100),@Eventtype int,@EventSource varchar(50), @LoadID int)      
AS      
BEGIN      
declare @SQL nvarchar(1000)      
declare @subSQL nvarchar(1000)      
SET @subSQL =''    
Declare @ParamDefinition AS NVarchar(2000)       
SET  @ParamDefinition = ' @FromDate nvarchar(100),      
                          @ToDate nvarchar(100),      
                          @Eventtype int,      
                          @EventSource varchar(50)'      
                      
SET @SQL = 'select E.id,E.type,E.source,message,createuser,createdatetime,RowNumber,Action,ET.type_description from EventLog E JOIN eventlogtype ET on ET.Id=E.type  '    
    
if(convert(varchar,@FromDate) <> '')    
BEGIN     
 SET @subSQL =@subSQL + ' Createdatetime >='''+@FromDate +''''    
END    
    
if(convert(varchar,@ToDate) <> '')    
BEGIN    
    
    
 if(@subSQL = '')    
  SET @subSQL =@subSQL + ' Createdatetime <='''+@ToDate+''''    
 else    
 SET @subSQL =@subSQL + ' AND Createdatetime <='''+@ToDate +''''    
END    
    
if(@subSQL = '')    
	SET @subSQL =@subSQL + ' DataFileID = ' + cast(@LoadID as varchar) + ''
else    
	SET @subSQL =@subSQL + ' AND DataFileID = ' + cast(@LoadID as varchar) + ''
	print @subsql
if(convert(varchar,@Eventtype ) <> '0')    
BEGIN    
 if(@subSQL = '')    
  SET @subSQL =@subSQL + ' type ='''+convert(varchar,@Eventtype ) +''''    
 else    
 SET @subSQL =@subSQL + ' AND type ='''+convert(varchar,@Eventtype ) +''''    
END    
if(convert(varchar,@EventSource ) <> '0')    
BEGIN    
 if(@subSQL = '')    
  SET @subSQL =@subSQL + ' [source] ='''+convert(varchar,@EventSource ) +''''    
 else    
 SET @subSQL =@subSQL + ' AND [source] ='''+convert(varchar,@EventSource ) +''''    
END    
if(@subSQL <> '')    
 SET @SQL=@SQL+' where' +@subSQL     
     
if(@SQL <>'')  
SET @SQL =@SQL +' ORDER BY createdatetime ASC'  
  
PRINT @SQL  
Execute sp_Executesql @SQL,      
    @ParamDefinition,       
                @FromDate ,      
                @ToDate ,      
                @Eventtype,       
                @EventSource      
END

