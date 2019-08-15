/****** Object:  Procedure [dbo].[uspGetLogedInUserEmpInfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetLogedInUserEmpInfo](@ADLogin int,@Accountname nvarchar(100),@PositionParentId int,@AssistantFlag int,@EmpPosId int)                          
AS                          
BEGIN                          
PRINT @Accountname                          
DECLARE @SQL nvarchar(4000)                
DECLARE @SortOrderFields nvarchar(1000)                 
declare @sortorderColumns nvarchar(1000)                
DECLARE @SortOrder nvarchar(100)                          
CREATE TABLE #Temp1(sortname varchar(100),columnname varchar(100))                      
DECLARE @SEP varchar(1)                    
SET @SEP =','                  
DECLARE @SP INT                 
DECLARE @SP1 INT                    
DECLARE @VALUE varchar(100)                 
DECLARE @VALUE1 varchar(100)        
        
DECLARE @CheckPositionIsAssistant int        
declare @OtherAssistantsCount int        
SET @OtherAssistantsCount=0        
DECLARE @TopAssistantEmployeePosid int        
        
--If the Assistant position having more than one Employees then this query will pick up the top 1       
set @TopAssistantEmployeePosid =(select top 1 id from employeepositioninfo where positionid in(select id from Position where parentid =@PositionParentId and isassistant ='Y'))        
--If the Assistant position having more than one Employees then this query will count the number of employees under assistant position except the top one   
     
SET @OtherAssistantsCount =(select COUNT(id) from employeepositioninfo where positionid in(select id from Position where parentid =@PositionParentId and isassistant ='Y')  and id <> @TopAssistantEmployeePosid )        
PRINT isnull(@TopAssistantEmployeePosid  ,123)      
PRINT isnull(@OtherAssistantsCount,456)      
      
      
SET @sortorderColumns ='EP.displayname,positiontitle,customfield1value,customfield2value,customfield3value,customfield4value'                    
        
if(@AssistantFlag =1)        
SET @SQL ='SELECT TOP 1'        
else        
SET @SQL ='SELECT '                    
        
                         
SET @SQL =@SQL +' EP.[id],
 isnull([employeeid], 0) as employeeid,
 isnull([positionid], 0) as positionid,
 isnull([displaynameid], 0) as displaynameid,
 isnull(EP.[displayname], '''') as displayname,
 isnull(E.picture, '''') as picture,
 isnull([employeeimageurlid], 0) as employeeimageurlid,
 isnull([employeeimageurl], '''') as employeeimageurl,
 isnull([positiontitleid], 0) as positiontitleid,
 isnull([positiontitle], '''') as positiontitle,
 isnull([customfield1id], 0) as customfield1id,
 isnull([customfield1], '''') as customfield1,
 isnull([customfield1value], '''') as customfield1value,
 isnull([customfield2id], 0) as customfield2id,
 isnull([customfield2], '''') as customfield2,
 isnull([customfield2value], '''') as customfield2value,
 isnull([customfield3id], 0) as customfield3id,
 isnull([customfield3], '''') as customfield3,
 isnull([customfield3value], '''') as customfield3value,
 isnull([customfield4id], 0) as customfield4id,
 isnull([customfield4], '''') as customfield4,
 isnull([customfield4value], '''') as customfield4value,
 isnull([customicon1id], 0) as customicon1id,
 isnull([customicon1url], '''') as customicon1url,
 isnull([customicon1tooltip], '''') as customicon1tooltip,
 isnull([customnavigate1url], '''') as customnavigate1url,
 isnull([customicon2id], 0) as customicon2id,
 isnull([customicon2url], '''') as customicon2url,
 isnull([customicon2tooltip], '''') as customicon2tooltip,
 isnull([customnavigate2url], '''') as customnavigate2url,
 isnull([customicon3id], 0) as customicon3id,
 isnull([customicon3url], '''') as customicon3url,
 isnull([customicon3tooltip], '''') as customicon3tooltip,
 isnull([customnavigate3url], '''') as customnavigate3url,
 isnull([customicon4id], 0) as customicon4id,
 isnull([customicon4url], '''') as customicon4url,
 isnull([customicon4tooltip], '''') as customicon4tooltip,
 isnull([customnavigate4url], '''') as customnavigate4url,
 isnull([customicon5id], 0) as customicon5id,
 isnull([customicon5url], '''') as customicon5url,
 isnull([customicon5tooltip], '''') as customicon5tooltip,
 isnull([customnavigate5url], '''') as customnavigate5url,
 isnull([emailid], 0) as emailid,
 isnull([email], '''') as email,
 isnull([haschildren], 0) as haschildren,
 isnull([childcount], 0) as childcount,
 isnull([directheadcount], 0) as directheadcount,
 isnull([totalheadcount], 0) as [totalheadcount],
 isnull([directftecount], 0) as [directftecount],
 isnull([totalftecount], 0) as [totalftecount],
 isnull([positionparentid], 0) as positionparentid,
 isnull(EP.[availabilitymessage], '''') as availabilitymessage,
 isnull([availabilityiconurl], '''') as availabilityiconurl,
 isnull(AvS.name, '''') as availabilitystatus
 FROM [dbo].[EmployeePositionInfo] EP INNER JOIN Employee E on E.id =EP.employeeid INNER JOIN Position P on P.Id=EP.PositionId LEFT OUTER JOIN AvailabilityStatus AvS on AvS.id=EP.availabilitystatus'                        

 If(@ADLogin =1)                      
 BEGIN                      
  if(@Accountname <> '')                               
   SET @SQL =@SQL +' WHERE E.accountname  = '''+@Accountname +''''                          
  if(@PositionParentId <> 0)                      
   SET @SQL =@SQL +' WHERE EP.positionparentid  = '''+convert(varchar,@PositionParentId)+''''                          
  if(@EmpPosId <> 0)                               
   SET @SQL =@SQL +' WHERE EP.Id  = '''+convert(varchar,@EmpPosId ) +''''                          
  if(@AssistantFlag=1)                        
   SET @SQL =@SQL +' and P.isassistant  = ''Y'''                          
  else                        
     SET @SQL =@SQL +' and P.isassistant  = ''N'''                           
END                      
ELSE                      
BEGIN                      
  if(@PositionParentId <> 0)                      
   SET @SQL =@SQL +' WHERE EP.positionparentid  = '''+convert(varchar,@PositionParentId)+''''                          
  if(@EmpPosId <> 0)                               
   SET @SQL =@SQL +' WHERE EP.Id  = '''+convert(varchar,@EmpPosId) +''''                       
                       
                        
  if(@AssistantFlag=1)                        
   SET @SQL =@SQL +' and P.isassistant  = ''Y'''   
  else if(@AssistantFlag=2)                   
   SET @SQL =@SQL -- required for later where add                  
 else              
 BEGIN                  
  if(@OtherAssistantsCount=0)        
  SET @SQL =@SQL +' and (P.isassistant <>''Y'' or  P.isassistant is NULL or  P.isassistant is NULL)'          
     else        
  SET @SQL =@SQL +' and (P.isassistant  =''Y'' or  P.isassistant is NULL or P.Isassistant=''N'') and (EP.id <> '+convert(varchar,@TopAssistantEmployeePosid)+')'                
 END                
END   
IF (SELECT CHARINDEX('WHERE', @SQL)) < 1                   
	SET @SQL = @SQL + ' where (EP.IsVisible = 1)'                 
ELSE
	SET @SQL = @SQL + ' and (EP.IsVisible = 1)'                 
SET @SortOrder =(select value from Setting where code='SOF')                
if(@sortorder <> '0')              
BEGIN               
SET @SortOrderFields =(select convert(varchar,displaynameid)+','+convert(varchar,positiontitleid)+','+convert(varchar,customfield1id)+','+convert(varchar,customfield2id)+','+convert(varchar,customfield3id)+','+convert(varchar,customfield4id) as namei from  EmployeePositionInfo where id=1)                  
                
PRINT @SortOrderFields                
if(CHARINDEX (',',@SortOrderFields)> 0)                    
 BEGIN                    
                    
  WHILE PATINDEX('%'+@SEP+'%',@SortOrderFields) <> 0                    
  BEGIN                    
     SELECT  @SP = PATINDEX('%' + @SEP + '%',@SortOrderFields)                    
     SELECT  @VALUE = LEFT(@SortOrderFields , @SP - 1)                    
                     
     SELECT  @SP1 = PATINDEX('%' + @SEP + '%',@sortorderColumns )                    
     SELECT  @VALUE1 = LEFT(@sortorderColumns , @SP1 - 1)                    
                     
     SELECT  @SortOrderFields = STUFF(@SortOrderFields, 1, @SP, '')               
     SELECT  @sortorderColumns = STUFF(@sortorderColumns, 1, @SP1, '')                    
     INSERT INTO #Temp1(sortname,columnname) VALUES (@VALUE,@VALUE1)                    
  END                    
 END                  
                
 if(@SortOrderFields <>'')                    
     INSERT INTO #Temp1(sortname,columnname) VALUES (@SortOrderFields,@sortorderColumns)               
                       
       
SET @SortOrder =(Select top 1 columnname from #Temp1 where sortname =@SortOrder)                
if(@SortOrder <>'' and @AssistantFlag <> 1)                
    SET @SQL =@SQL +' ORDER BY '+@SortOrder                 
END    
 print '---------------------------'   
 PRINT @SQL;
 print '---------------------------'    
EXECUTE sp_executesql @SQL                          
                
drop table #Temp1                
                
                        
END

