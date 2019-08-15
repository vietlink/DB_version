/****** Object:  Procedure [dbo].[uspGetOrgviewSearchResult]    Committed by VersionSQL https://www.versionsql.com ******/

/*OrgView1.1 Script Changes*/
/*OrgView1.1 Script Changes*/
CREATE PROCEDURE [dbo].[uspGetOrgviewSearchResult](@Name varchar(100),@Positiontitle varchar(100),@NOTFLag int,@EmployeeGroupId int,@Condition nvarchar(4000), @loggedInPosID int, @userId int, @iAmManager bit, @locationList varchar(max))                                    
AS                                    
BEGIN                                    
                
DECLARE @POSFound int                        
DECLARE @SQL nvarchar(MAX)                  
                        
DECLARE @WHERESQL nvarchar(max)                          
SET @WHERESQL=''                
SET @POSFound =0                        
                        
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
DECLARE @ViewEmailId int = dbo.fnGetAttributeIdByCode('workemail');      
DECLARE @AvailMsgViewId int = dbo.fnGetAttributeIdByCode('availmessage-view');
              
SET @sortorderColumns ='EPI.displayname,positiontitle,customfield1value,customfield2value,customfield3value,customfield4value'                              
SET @POSFound =(select count(Id) from Position where title =  @Positiontitle)                
if(@POSFound is null)                
 SET @POSFound =0                
SET @SQL ='SELECT  distinct EPI.[id], 
E.Surname as EmpSurname,                             
 EPI.[employeeid],                                         
 EPI.[positionid],                                         
 EPI.[displaynameid],                                        
 EPI.[displayname],                                      
 E.picture,                                          
 EPI.[employeeimageurlid],                                         
 EPI.[employeeimageurl],                                         
 EPI.[positiontitleid],                                         
 EPI.[positiontitle],                                         
 isnull(EPI.[customfield1id],0) as customfield1id,                                         
 EPI.[customfield1],                                         
 dbo.fnCheckPermissionValue(EPI.[customfield1value], ' + cast(@loggedInPosID as varchar) + ', ' + cast(@userId as varchar) + ', EPI.customfield1id, EPI.employeeid, EPI.positionid, ' + cast(@iAmManager as varchar) + ') as customfield1value,
 (select longname from Attribute where id=EPI.displaynameid)as  DisplaynameLongname,
 (select longname from Attribute where id=EPI.positiontitleid)as PositionTitleLongname,
 (select columnname from Attribute where id=EPI.CustomField1id)as CustomField1Columnname,            
 (select columnname from Attribute where id=EPI.CustomField2id)as CustomField2Columnname,            
 (select columnname from Attribute where id=EPI.CustomField3id)as CustomField3Columnname,            
 (select columnname from Attribute where id=EPI.CustomField4id)as CustomField4Columnname,            
  isnull(EPI.[customfield2id],0) as customfield2id,                                         
 EPI.[customfield2],                                         
 dbo.fnCheckPermissionValue(EPI.[customfield2value], ' + cast(@loggedInPosID as varchar) + ', ' + cast(@userId as varchar) + ', EPI.customfield2id, EPI.employeeid, EPI.positionid, ' + cast(@iAmManager as varchar) + ') as customfield2value,
 isnull(EPI.[customfield3id],0) as customfield3id,                                         
 EPI.[customfield3],                                         
 dbo.fnCheckPermissionValue(EPI.[customfield3value], ' + cast(@loggedInPosID as varchar) + ', ' + cast(@userId as varchar) + ', EPI.customfield3id, EPI.employeeid, EPI.positionid, ' + cast(@iAmManager as varchar) + ') as customfield3value,
 EPI.[customfield4],                                         
 isnull(EPI.[customfield4id],0) as customfield4id,                                         
 dbo.fnCheckPermissionValue(EPI.[customfield4value], ' + cast(@loggedInPosID as varchar) + ', ' + cast(@userId as varchar) + ', EPI.customfield4id, EPI.employeeid, EPI.positionid, ' + cast(@iAmManager as varchar) + ') as customfield4value,
 isnull(EPI.[customicon1id],0) as customicon1id,                                         
 EPI.[customicon1url],                                         
 EPI.[customicon1tooltip],                                         
 EPI.[customnavigate1url],                                         
 isnull(EPI.[customicon2id],0) as customicon2id,                                         
 EPI.[customicon2url],                                         
 EPI.[customicon2tooltip],                                         
 EPI.[customnavigate2url],                                         
 isnull(EPI.[customicon3id],0) as customicon3id,                                         
 EPI.[customicon3url],                                         
 EPI.[customicon3tooltip],                                         
 EPI.[customnavigate3url],                                         
 isnull(EPI.[customicon4id],0) as customicon4id,               
 EPI.[customicon4url],                                         
 EPI.[customicon4tooltip],                                         
 EPI.[customnavigate4url],                          
 isnull(EPI.[customicon5id],0) as customicon5id,                                         
 EPI.[customicon5url],                    
 EPI.[customicon5tooltip],                                         
 EPI.[customnavigate5url],                                         
 EPI.[emailid],                                         
ISNULL(dbo.fnCheckPermissionValue(EPI.[email],' + cast(@loggedInPosID as varchar) + ', ' + cast(@userId as varchar) + ', ' + cast(@ViewEmailId as varchar) + ', EPI.employeeid, EPI.positionid, ' + cast(@iAmManager as varchar) + '), '''') as Email,                                       
 EPI.[haschildren],                                         
 EPI.[childcount],                                         
 isnull(EPI.[directheadcount], 0) as directheadcount,                                      
 isnull(EPI.[totalheadcount], 0) as [totalheadcount],                                      
 isnull(EPI.[directftecount], 0) as [directftecount],                                      
 isnull(EPI.[totalftecount], 0) as [totalftecount],                     
 EPI.[positionparentid],  
 EPI.IsVisible,    
 e.isplaceholder,                                    
 dbo.fnCheckPermissionValue(isnull(EPI.[availabilitymessage],''''), ' + cast(@loggedInPosID as varchar) + ', ' + cast(@userId as varchar) + ', ' + cast(@AvailMsgViewId as varchar) + ', EPI.employeeid, EPI.positionid, ' + cast(@iAmManager as varchar) + ') as availabilitymessage,                                         
 EPI.[availabilityiconurl],                            
 dbo.fnCheckPermissionValue(isnull(avs.Name,''''), ' + cast(@loggedInPosID as varchar) + ', ' + cast(@userId as varchar) + ', ' + cast(@AvailMsgViewId as varchar) + ', EPI.employeeid, EPI.positionid, ' + cast(@iAmManager as varchar) + ') as availabilitystatus,
 dbo.fnCheckPermissionAttCode(''workemail'', ' + cast(@loggedInPosID as varchar) + ', ' + cast(@userId as varchar) + ', EPI.employeeid, EPI.positionid, ' + cast(@iAmManager as varchar) + ') as emailpermission'
            
if(@EmployeeGroupId >=0)                
 SET @SQL=@SQL+', EG.Name as EmpGroupname,isnull(EG.icon,'''') as EmpGroupIcon FROM [dbo].[EmployeePositionInfo] EPI INNER JOIN EmployeePosition EP ON EP.ID = EPI.ID INNER JOIN Employee E on E.id =EPI.employeeid INNER JOIN Position P on P.Id=EPI.PositionId LEFT OUTER JOIN AvailabilityStatus AvS on AvS.id=EPI.availabilitystatus'            
  
   
     
else            
 SET @SQL=@SQL+' ,'''' as EmpGroupname,'''' as  EmpGroupIcon FROM [dbo].[EmployeePositionInfo] EPI INNER JOIN EmployeePosition EP ON EP.ID = EPI.ID INNER JOIN Employee E on E.id =EPI.employeeid INNER JOIN Position P on P.Id=EPI.PositionId LEFT OUTER JOIN AvailabilityStatus AvS on AvS.id=EPI.availabilitystatus'               
 
             
                                   
                
                
if(@EmployeeGroupId > 0)                      
BEGIN                 
                 
 SET @SQL=@SQL+' INNER JOIN EmployeeGroupEmployee EGE on EGE.employeeid=E.Id INNER JOIN EmployeeGroup EG on EG.id=EGE.EmployeeGroupId and EGE.employeegroupid='+Convert(varchar,@EmployeeGroupId) +''                      
END                 
ELSE if(@EmployeeGroupId = 0)                   
              
BEGIN                
 SET @SQL=@SQL+'  INNER JOIN EmployeeGroupEmployee EGE on EGE.employeeid=E.Id LEFT OUTER JOIN EmployeeGroup EG on EG.id=EGE.EmployeeGroupId'                
                                 
END                     
                      
--PRINT @SQL                      
                      
                      
if(@Name <> '')                        
BEGIN                        
                         
 SET @WHERESQL ='(E.firstname like ''%'+@Name +'%'' OR E.surname like ''%'+@Name +'%'' OR E.firstnamepreferred like ''%'+@Name +'%'' OR E.displayname like ''%'+@Name +'%'' )'                        
END                        
if(@Positiontitle <> '')                        
BEGIN                        
PRINT @WHERESQL                        
                        
 if(@WHERESQL ='')                        
 BEGIN                 
                        
   if(@NOTFLag=1)                
   BEGIN                 
  if(@POSFound <>0)                              
   SET @WHERESQL =@WHERESQL + ' (P.title <> '''+@Positiontitle +''' AND p.description <> ''' + @Positiontitle + ''')'                   
  else                
   SET @WHERESQL =@WHERESQL + ' (P.title not like ''%'+@Positiontitle +'%'' AND P.description not like ''%' + @Positiontitle + '%'')'                     
   END                
   else                
   BEGIN                 
  if(@POSFound <>0)                         
   SET @WHERESQL =@WHERESQL + ' (P.title ='''+@Positiontitle +''' OR P.description = ''' + @Positiontitle + ''')'                        
  else                
   SET @WHERESQL =@WHERESQL + ' (P.title like ''%'+@Positiontitle +'%'' OR P.description like ''%' +  @Positiontitle + '%'')'                 
   END                
                          
 END                        
 else                        
 BEGIN                        
  if(@NOTFLag=1)                  
   BEGIN                 
 if(@POSFound <>0)                        
  SET @WHERESQL =@WHERESQL + ' AND (P.title <> '''+@Positiontitle +''' AND p.description <> ''' + @Positiontitle + ''')'                
 else                
  SET @WHERESQL =@WHERESQL + ' AND (P.title not like ''%'+@Positiontitle +'%'' AND p.description not like ''%' + @Positiontitle + '%'')'                  
  END           
  else                 
  BEGIN                
  if(@POSFound <>0)                         
  SET @WHERESQL =@WHERESQL + ' AND (P.title = '''+@Positiontitle +''' OR P.description = ''' + @Positiontitle + ''')'                
  else                
  SET @WHERESQL =@WHERESQL + ' AND (P.title like ''%'+@Positiontitle +'%'' OR P.description like ''%' + @Positiontitle + '%'')'                     
  END                      
 END                        
                         
END                   
          
if(@Condition <> '')                    
BEGIN                  
	SET @SQL =@SQL + ' LEFT OUTER JOIN EmployeeContact EC on EC.Employeeid=E.Id '    
	IF(@WHERESQL = '')
		SET @WHERESQL =@WHERESQL + @Condition                        
	ELSE
		SET @WHERESQL =@WHERESQL + ' AND ' + @Condition  
END

IF(@locationList <> '')
BEGIN
	IF(@WHERESQL <> '') BEGIN
	SET @WHERESQL = @WHERESQL + ' AND (case when e.location is null or e.location = '''' then ''(Blank)'' else e.location end) IN (' + @locationList + ')';
	END
	ELSE
	SET @WHERESQL = @WHERESQL + ' (case when e.location is null or e.location = '''' then ''(Blank)'' else e.location end) IN (' + @locationList + ')';
END                     
                        
IF(@WHERESQL <> '')          
 SET @SQL =@SQL +' WHERE (ep.IsDeleted = 0 AND p.IsDeleted = 0 AND e.IsDeleted = 0) AND ' +@WHERESQL     
ELSE
 SET @SQL = @SQL + ' WHERE (ep.IsDeleted = 0 AND p.IsDeleted = 0 AND e.IsDeleted = 0)'
     exec dbo.longprint @sql                                        
EXECUTE sp_executesql @SQL              
                          
                                  
END 
----------

