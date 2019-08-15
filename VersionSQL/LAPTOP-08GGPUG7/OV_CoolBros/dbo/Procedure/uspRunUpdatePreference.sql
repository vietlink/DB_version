/****** Object:  Procedure [dbo].[uspRunUpdatePreference]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspRunUpdatePreference] (@empPosId int = -1, @empId int = -1, @posId int = -1, @dontRunBuildPosition int = 0)
AS  
BEGIN   
declare @SQL nvarchar(max)  
declare @CopySQL nvarchar(500)  
declare @ParamDefinition nvarchar(3000)  
declare @TypeofIcon varchar(100)  
DECLARE @IndexofSelect int  
  
declare @CustomFieldname1 varchar(100)  
declare @CustomFieldHead1 varchar(100)  
declare @CustomFieldId1 varchar(100)  
declare @CustomTablename1 varchar(100)  
declare @CustomField1Condn varchar(100)  
  
declare @CustomFieldname2 varchar(100)  
declare @CustomFieldHead2 varchar(100)  
declare @CustomFieldId2 varchar(100)  
declare @CustomTablename2 varchar(100)  
declare @CustomField2Condn varchar(100)  
  
  
declare @CustomFieldname3 varchar(100)  
declare @CustomFieldHead3 varchar(100)  
declare @CustomFieldId3 varchar(100)  
declare @CustomTablename3 varchar(100)  
declare @CustomField3Condn varchar(100)  
  
declare @CustomFieldname4 varchar(100)  
declare @CustomFieldHead4 varchar(100)  
declare @CustomFieldId4 varchar(100)  
declare @CustomTablename4 varchar(100)  
declare @CustomField4Condn varchar(100)  
  
declare @CustomIcon1Id varchar(100)  
declare @CustomIcon1ImageURL varchar(100)  
declare @CustomIcon1Tooltip varchar(100)  
declare @CustomNavigate1URL varchar(100)  
  
declare @CustomIcon2Id varchar(100)  
declare @CustomIcon2ImageURL varchar(100)  
declare @CustomIcon2Tooltip varchar(100)  
declare @CustomNavigate2URL varchar(100)  
  
declare @CustomIcon3Id varchar(100)  
declare @CustomIcon3ImageURL varchar(100)  
declare @CustomIcon3Tooltip varchar(100)  
declare @CustomNavigate3URL varchar(100)  
  
  
declare @CustomIcon4Id varchar(100)  
declare @CustomIcon4ImageURL varchar(100)  
declare @CustomIcon4Tooltip varchar(100)  
declare @CustomNavigate4URL varchar(100)  
  
declare @CustomIcon5Id varchar(100)  
declare @CustomIcon5ImageURL varchar(100)  
declare @CustomIcon5Tooltip varchar(100)  
declare @CustomNavigate5URL varchar(100)  
  
exec uspUpdateUnassignedParent

if @dontRunBuildPosition = 0
	exec uspBuildPositionGrouplessHierarchy

update employee set firstnamepreferred = firstname where firstnamepreferred is null or firstnamepreferred = ''
update Employee set age=datediff(hour,dob,GETDATE ()) / 8766 WHERE dob is not null and dob < GETDATE()
update Employee set age=null where dob is null;
update Employee set companyserviceyears=datediff(dd,commencement,GETDATE ())/365.0 WHERE commencement is not null and commencement < GETDATE() AND (termination IS NULL OR termination > GETDATE())
update employee set picture = 'no_pic.gif' where picture is null
update employee set picture = 'no_pic_group.gif' where picture = 'no_pic.gif' and isplaceholder = 1
                
SET  @ParamDefinition = ' @CustomTablename1 nvarchar(100),    
                          @CustomFieldname1 nvarchar(100),    
                          @CustomFieldId1 nvarchar(100),  
                          @CustomField1Condn nvarchar(1000),  
                          @CustomTablename2 nvarchar(100),    
                          @CustomFieldname2 nvarchar(100),    
                          @CustomFieldId2 nvarchar(100),  
                          @CustomField2Condn nvarchar(1000),  
                          @CustomTablename3 nvarchar(100),    
                          @CustomFieldname3 nvarchar(100),    
                          @CustomFieldId3 nvarchar(100),  
                          @CustomField3Condn nvarchar(1000),  
                          @CustomTablename4 nvarchar(100),    
                          @CustomFieldname4 nvarchar(100),    
                          @CustomFieldId4 nvarchar(100),  
                          @CustomField4Condn nvarchar(1000),  
                          @CustomIcon1Id nvarchar(100),  
        @CustomIcon1ImageURL nvarchar(100),  
        @CustomIcon1Tooltip nvarchar(100),  
        @CustomNavigate1URL nvarchar(100),  
        @CustomIcon2Id nvarchar(100),  
        @CustomIcon2ImageURL nvarchar(100),  
        @CustomIcon2Tooltip nvarchar(100),  
        @CustomNavigate2URL nvarchar(100),  
        @CustomIcon3Id nvarchar(100),  
        @CustomIcon3ImageURL nvarchar(100),  
        @CustomIcon3Tooltip nvarchar(100),  
        @CustomNavigate3URL nvarchar(100),  
        @CustomIcon4Id nvarchar(100),  
        @CustomIcon4ImageURL nvarchar(100),  
        @CustomIcon4Tooltip nvarchar(100),  
        @CustomNavigate4URL nvarchar(100),  
        @CustomIcon5Id nvarchar(100),  
        @CustomIcon5ImageURL nvarchar(100),  
        @CustomIcon5Tooltip nvarchar(100),  
        @CustomNavigate5URL nvarchar(100)'  
BEGIN TRY    
BEGIN TRANSACTION runUpdatePreferenceProcess         
  
/**********************************CUSTOM FIELD VALUES RETREIVING**********************************************************************************************/  
/*Custom Field 1 Values Retrieving */                            
SET @CustomTablename1 =(select E.tablename   from Attribute A inner join entity E on e.id =A.entityid where A. id=  
      (select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield1id')))  
SET @CustomFieldname1 =(select columnname  from Attribute A inner join entity E on e.id =A.entityid where A. id=  
      (select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield1id')))  
SET @CustomFieldHead1 =(select A.shortname   from Attribute A inner join entity E on e.id =A.entityid where A. id=  
      (select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield1id')))  
        
        
SET @CustomFieldId1 =(select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield1id'))  
        
--PRINT @CustomFieldname1   
--PRINT @CustomTablename1   
--PRINT @CustomField1Condn  
/*Custom Field 2 Values Retrieving */          
SET @CustomTablename2 =(select E.tablename   from Attribute A inner join entity E on e.id =A.entityid where A. id=  
      (select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield2id')))  
SET @CustomFieldname2 =(select columnname  from Attribute A inner join entity E on e.id =A.entityid where A. id=  
      (select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield2id')))  
SET @CustomFieldHead2 =(select A.shortname    from Attribute A inner join entity E on e.id =A.entityid where A. id=  
      (select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield2id')))  
        
SET @CustomFieldId2 =(select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield2id'))  
        
  
/*Custom Field 3 Values Retrieving */            
SET @CustomTablename3 =(select E.tablename   from Attribute A inner join entity E on e.id =A.entityid where A. id=  
      (select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield3id')))  
SET @CustomFieldname3 =(select columnname  from Attribute A inner join entity E on e.id =A.entityid where A. id=  
      (select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield3id')))  
SET @CustomFieldHead3 =(select A.shortname   from Attribute A inner join entity E on e.id =A.entityid where A. id=  
      (select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield3id')))  
        
SET @CustomFieldId3 =(select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield3id'))  
    
  
/*Custom Field 4 Values Retrieving */          
SET @CustomTablename4 =(select E.tablename   from Attribute A inner join entity E on e.id =A.entityid where A. id=  
      (select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield4id')))  
SET @CustomFieldname4 =(select columnname  from Attribute A inner join entity E on e.id =A.entityid where A. id=  
      (select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield4id')))  
SET @CustomFieldHead4 =(select A.shortname   from Attribute A inner join entity E on e.id =A.entityid where A. id=  
      (select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield4id')))  
        
SET @CustomFieldId4 =(select value  
      from ApplicationPreference where preferenceid in(select id from Preference where code ='customfield4id'))  
        
/****************************************MAKING CUTOM FIELD CONDITIONS****************************************************************************************/  
  
--PRINT @CustomTablename1  
/*Custom Field 1 Condition making */   
if(@CustomTablename1='Employee')       
   SET @CustomField1Condn=' id=EP.employeeid'  
else if(@CustomTablename1='EmployeeContact' )--or @CustomTablename1='EmployeeReference')  
   SET @CustomField1Condn=' employeeid=EP.employeeid'   
else if(@CustomTablename1='EmployeePosition')       
   SET @CustomField1Condn=' employeeid=EP.employeeid and Positionid=EP.Positionid'   
/*else if(@CustomTablename1='PositionReference')       
   SET @CustomField1Condn=' positionid=EP.positionid'*/        
else if(@CustomTablename1='Position')       
   SET @CustomField1Condn=' id=EP.positionid'   
  
/*Custom Field 2 Condition making */   
     
if(@CustomTablename2='Employee')       
   SET @CustomField2Condn=' id=EP.employeeid'  
else if(@CustomTablename2='EmployeeContact')-- or @CustomTablename2='EmployeeReference')       
   SET @CustomField2Condn=' employeeid=EP.employeeid'  
else if  (@CustomTablename2='EmployeePosition')   
   SET @CustomField2Condn=' employeeid=EP.employeeid and Positionid=EP.Positionid'   
/*else if(@CustomTablename2='PositionReference')       
   SET @CustomField2Condn=' positionid=EP.positionid'        */
else if(@CustomTablename2='Position')       
   SET @CustomField2Condn=' id=EP.positionid'   
     
/*Custom Field 3 Condition making */   
     
if(@CustomTablename3='Employee')       
   SET @CustomField3Condn=' id=EP.employeeid'  
else if(@CustomTablename3='EmployeeContact' )--or @CustomTablename3='EmployeeReference')  
   SET @CustomField3Condn=' employeeid=EP.employeeid'  
else if  (@CustomTablename3='EmployeePosition')   
   SET @CustomField3Condn=' employeeid=EP.employeeid and Positionid=EP.Positionid'    
/*else if(@CustomTablename3='PositionReference')       
   SET @CustomField3Condn=' positionid=EP.positionid'        */
else if(@CustomTablename3='Position')       
   SET @CustomField3Condn=' id=EP.positionid'   
     
/*Custom Field 2 Condition making */   
     
if(@CustomTablename4='Employee')       
   SET @CustomField4Condn=' id=EP.employeeid'  
else if(@CustomTablename4='EmployeeContact')-- or @CustomTablename4='EmployeeReference')  
   SET @CustomField4Condn=' employeeid=EP.employeeid'   
else if  (@CustomTablename4='EmployeePosition')   
   SET @CustomField4Condn=' employeeid=EP.employeeid and Positionid=EP.Positionid'   
/*else if(@CustomTablename4='PositionReference')       
   SET @CustomField4Condn=' positionid=EP.positionid'        */
else if(@CustomTablename4='Position')       
   SET @CustomField4Condn=' id=EP.positionid'  
/********************************CUSTOM ICON VALUES RETREIVING******************************************************************************/  
CREATE TABLE #TEMPTAB1(  
   CustomIconId nvarchar(100),  
   CustomIconImageURL nvarchar(150) NULL,   
   CustomIconImageTooltip nvarchar(150) NULL,   
         CustomNavigateURL nvarchar(150) NULL)  
      
INSERT INTO #TEMPTAB1 select * from dbo.uspGetIconDetails('CustomIcon1','1')   
  
SET @CustomIcon1Id =(select CustomIconId from #TEMPTAB1 )  
SET @CustomIcon1ImageURL =(select CustomIconImageURL from #TEMPTAB1 )  
SET @CustomIcon1Tooltip =(select CustomIconImageTooltip from #TEMPTAB1 )  
SET @CustomNavigate1URL =(select CustomNavigateURL from #TEMPTAB1 )  
  
  
  
DELETE FROM #TEMPTAB1  
  
INSERT INTO #TEMPTAB1 select * from dbo.uspGetIconDetails('CustomIcon2','2')   
  
SET @CustomIcon2Id =(select CustomIconId from #TEMPTAB1 )  
SET @CustomIcon2ImageURL =(select CustomIconImageURL from #TEMPTAB1 )  
SET @CustomIcon2Tooltip =(select CustomIconImageTooltip from #TEMPTAB1 )  
SET @CustomNavigate2URL =(select CustomNavigateURL from #TEMPTAB1 )  
  
DELETE FROM #TEMPTAB1  
  
INSERT INTO #TEMPTAB1 select * from dbo.uspGetIconDetails('CustomIcon3','3')   
  
SET @CustomIcon3Id =(select CustomIconId from #TEMPTAB1 )  
SET @CustomIcon3ImageURL =(select CustomIconImageURL from #TEMPTAB1 )  
SET @CustomIcon3Tooltip =(select CustomIconImageTooltip from #TEMPTAB1 )  
SET @CustomNavigate3URL =(select CustomNavigateURL from #TEMPTAB1 )  
  
DELETE FROM #TEMPTAB1  
  
INSERT INTO #TEMPTAB1 select * from dbo.uspGetIconDetails('CustomIcon4','4')   
  
SET @CustomIcon4Id =(select CustomIconId from #TEMPTAB1 )  
SET @CustomIcon4ImageURL =(select CustomIconImageURL from #TEMPTAB1 )  
SET @CustomIcon4Tooltip =(select CustomIconImageTooltip from #TEMPTAB1 )  
SET @CustomNavigate4URL =(select CustomNavigateURL from #TEMPTAB1 )  
  
--PRINT isnull(@CustomIcon1Id,0)  
--PRINT @CustomIcon4ImageURL  
--PRINT @CustomIcon4Tooltip  
--PRINT @CustomNavigate4URL  
  
DELETE FROM #TEMPTAB1  
  
INSERT INTO #TEMPTAB1 select * from dbo.uspGetIconDetails('CustomIcon5','5')   
  
SET @CustomIcon5Id =(select CustomIconId from #TEMPTAB1 )  
SET @CustomIcon5ImageURL =(select CustomIconImageURL from #TEMPTAB1 )  
SET @CustomIcon5Tooltip =(select CustomIconImageTooltip from #TEMPTAB1 )  
SET @CustomNavigate5URL =(select CustomNavigateURL from #TEMPTAB1 )  

--PRINT isnull(@CustomIcon5Id,0)  
--PRINT @CustomIcon5ImageURL  
--PRINT @CustomIcon5Tooltip  
--PRINT 'Hereupdate Raji'  
/**************************************************************************************************************/  
DECLARE @tableInsert varchar(100);
IF @empId < 1 OR @empId IS NULL BEGIN
	SET @tableInsert = 'EmployeePositionInfo';
END
IF @empId > 0 BEGIN
	SET @tableInsert = 'EmployeePositionInfo2';
	truncate table EmployeePositionInfo2;
END

SET @SQL ='INSERT INTO ' + @tableInsert + ' (id,employeeid,positionid,displaynameid,displayname,employeeimageurlid,employeeimageurl,positiontitleid,positiontitle,customfield1id,customfield1,customfield1value,customfield2id,  
customfield2,customfield2value,customfield3id,customfield3,customfield3value,customfield4id,customfield4,customfield4value,customicon1id,customicon1url,customicon1tooltip,customicon2id,customicon2url,  
customicon2tooltip,customicon3id,customicon3url,customicon3tooltip,customicon4id,customicon4url,customicon4tooltip,customicon5id,customicon5url,customicon5tooltip,customnavigate1url,customnavigate2url,customnavigate3url,customnavigate4url,customnavigate5url,  
emailid,email,haschildren,childcount,positionparentid,availabilitystatus,availabilitymessage,availabilityiconurl,directheadcount,totalheadcount,ActualChildCount,ActualTotalCount,directftecount,totalftecount,IsVisible,[IsAssistant])  
select ep.id,employeeid,positionid,(select top 1 id from Attribute where code=''displayname'') as displaynameid,  
 (select isnull(displayname,'''') from Employee E where E.id=Ep.employeeid ) as displayname,0,  
 (select picture from Employee E where E.id=Ep.employeeid ) employeeimageurl,  
 (select top 1 A.id from Attribute A where A.code=''postitle'') as positiontitleid,  
 (select title from Position P where P.id=Ep.Positionid) as positiontitleid,  
 '''+isnull(@CustomFieldId1,0) +''' as CustomField1Id,  
 '''+isnull(@CustomFieldHead1,'NULL') +''' as CustomField1,'  
   
IF(@CustomFieldname1 is NULL or @CustomFieldname1 ='')  
 SET @SQL=@SQL+''''' as  CustomField1Value,'  
ELSE  
 SET @SQL=@SQL+'(select '+@CustomFieldname1+' from '+ @CustomTablename1+ ' where '+@CustomField1Condn +')as CustomField1Value,'   
  
SET @SQL=@SQL+''''+isnull(@CustomFieldId2,0) +''' as CustomField2Id,  
 '''+isnull(@CustomFieldHead2,'NULL') +''' as CustomField2,'  
  
IF(@CustomFieldname2 is NULL or @CustomFieldname2 ='')  
 SET @SQL=@SQL+''''' as  CustomField2Value,'  
ELSE  
 SET @SQL=@SQL+'(select '+@CustomFieldname2+' from '+ @CustomTablename2+ ' where '+@CustomField2Condn +')as CustomField2Value,'  
  
SET @SQL=@SQL+''''+isnull(@CustomFieldId3,0) +''' as CustomField3Id,  
 '''+isnull(@CustomFieldHead3,'NULL') +''' as CustomField3,'  
   
IF(@CustomFieldname3 is NULL or @CustomFieldname3 ='')  
 SET @SQL=@SQL+''''' as  CustomField3Value,'  
ELSE  
 SET @SQL=@SQL+'(select '+@CustomFieldname3+' from '+ @CustomTablename3+ ' where '+@CustomField3Condn +')as CustomField3Value,'  
  
SET @SQL=@SQL+''''+isnull(@CustomFieldId4,0) +''' as CustomField4Id,  
 '''+isnull(@CustomFieldHead4,'NULL') +''' as CustomField4,'  
  
IF(@CustomFieldname4 is NULL or @CustomFieldname4 ='')  
 SET @SQL=@SQL+''''' as  CustomField4Value,'  
ELSE  
 SET @SQL=@SQL+'(select '+@CustomFieldname4+' from '+ @CustomTablename4+ ' where '+@CustomField4Condn +')as CustomField3Value,'  
/*Custom Icons :Icon1*/   
  
SET @SQL=@SQL+''''+isnull(@CustomIcon1Id,'0') +''' as CustomIcon1Id,'  
if(@CustomIcon1ImageURL is null or @CustomIcon1ImageURL ='')  
 SET @SQL=@SQL+''''' as CustomIcon1ImageURL,'  
else  
 SET @SQL=@SQL+''''+@CustomIcon1ImageURL+''' as CustomIcon1ImageURL,'  
if(@CustomIcon1Tooltip is null or @CustomIcon1Tooltip ='')  
 SET @SQL=@SQL+''''' as CustomIcon1Tooltip,'  
else  
 SET @SQL=@SQL+''''+@CustomIcon1Tooltip+''' as CustomIcon1Tooltip,'  
   
/*Custom Icons :Icon2*/  
    
SET @SQL=@SQL+''''+isnull(@CustomIcon2Id,'0') +''' as CustomIcon2Id,'  
  
if(@CustomIcon2ImageURL is null or @CustomIcon2ImageURL ='')  
 SET @SQL=@SQL+''''' as CustomIcon2ImageURL,'  
else  
 SET @SQL=@SQL+''''+@CustomIcon2ImageURL+''' as CustomIcon2ImageURL,'  
if(@CustomIcon2Tooltip is null or @CustomIcon2Tooltip ='')  
 SET @SQL=@SQL+''''' as CustomIcon2Tooltip,'  
else  
 SET @SQL=@SQL+''''+@CustomIcon2Tooltip+''' as CustomIcon2Tooltip,'  
   
/*Custom Icons :Icon3*/   
  
SET @SQL=@SQL+''''+isnull(@CustomIcon3Id,'0') +''' as CustomIcon3Id,'  
  
if(@CustomIcon3ImageURL is null or @CustomIcon3ImageURL ='')  
 SET @SQL=@SQL+''''' as CustomIcon3ImageURL,'  
else  
 SET @SQL=@SQL+''''+@CustomIcon3ImageURL+''' as CustomIcon3ImageURL,'  
if(@CustomIcon3Tooltip is null or @CustomIcon3Tooltip ='')  
 SET @SQL=@SQL+''''' as CustomIcon3Tooltip,'  
else  
 SET @SQL=@SQL+''''+@CustomIcon3Tooltip+''' as CustomIcon3Tooltip,'  
   
/*Custom Icons :Icon4*/    
  
SET @SQL=@SQL+''''+isnull(@CustomIcon4Id,'0') +''' as CustomIcon4Id,'  
  
if(@CustomIcon4ImageURL is null or @CustomIcon4ImageURL ='')  
 SET @SQL=@SQL+''''' as CustomIcon4ImageURL,'  
else  
 SET @SQL=@SQL+''''+@CustomIcon4ImageURL+''' as CustomIcon4ImageURL,'  
if(@CustomIcon4Tooltip is null or @CustomIcon4Tooltip ='')  
 SET @SQL=@SQL+''''' as CustomIcon4Tooltip,'  
else  
 SET @SQL=@SQL+''''+@CustomIcon4Tooltip+''' as CustomIcon4Tooltip,'  
   
/*Custom Icons :Icon5*/    
  
SET @SQL=@SQL+''''+isnull(@CustomIcon5Id,'0') +''' as CustomIcon5Id,'  
if(@CustomIcon5ImageURL is null or @CustomIcon5ImageURL ='')  
 SET @SQL=@SQL+''''' as CustomIcon5ImageURL,'  
else  
 SET @SQL=@SQL+''''+@CustomIcon5ImageURL+''' as CustomIcon5ImageURL,'  
if(@CustomIcon5Tooltip is null or @CustomIcon5Tooltip ='')  
 SET @SQL=@SQL+''''' as CustomIcon5Tooltip,'  
else  
 SET @SQL=@SQL+''''+@CustomIcon5Tooltip+''' as CustomIcon5Tooltip,'  
   
  
  
   
SET @IndexofSelect =0  
SET @IndexofSelect =(select CHARINDEX('select',@CustomNavigate1URL,0))  
--Custom Icon1 NavigateURL  
   
IF(@CustomNavigate1URL IS NULL or @CustomNavigate1URL ='')/* or @IndexofSelect =0)*/  
BEGIN  
SET @SQL =@SQL + ''''' as CustomNavigate1URL,'  
END  
ELSE  
BEGIN  
 IF(@IndexofSelect > 0 )  
 SET @SQL =@SQL + @CustomNavigate1URL+' as CustomNavigate1URL,'  
 else  
 SET @SQL =@SQL + ''''+@CustomNavigate1URL+''' as CustomNavigate1URL,'  
END  
SET @IndexofSelect =(select CHARINDEX('select',@CustomNavigate2URL,0))  
  
--Custom Icon2 NavigateURL  
IF(@CustomNavigate2URL is NULL or @CustomNavigate2URL ='' )/* or @IndexofSelect =0)*/  
SET @SQL =@SQL + ''''' as CustomNavigate2URL,'  
ELSE  
BEGIN  
 IF(@IndexofSelect > 0 )  
 SET @SQL =@SQL + @CustomNavigate2URL+' as CustomNavigate2URL,'  
 else  
 SET @SQL =@SQL + ''''+@CustomNavigate2URL+''' as CustomNavigate2URL,'  
END  
SET @IndexofSelect =(select CHARINDEX('select',@CustomNavigate3URL,0))  
  
--Custom Icon3 NavigateURL  
IF(@CustomNavigate3URL is NULL or @CustomNavigate3URL ='')-- or @IndexofSelect =0)  
SET @SQL =@SQL + ''''' as CustomNavigate3URL,'  
ELSE  
BEGIN  
 IF(@IndexofSelect > 0 )  
 SET @SQL =@SQL + @CustomNavigate3URL+' as CustomNavigate3URL,'  
 else  
 SET @SQL =@SQL + ''''+@CustomNavigate3URL+''' as CustomNavigate3URL,'  
END  
SET @IndexofSelect =(select CHARINDEX('select',@CustomNavigate4URL,0))  
  
  
--Custom Icon4 NavigateURL  
IF(@CustomNavigate4URL is NULL or @CustomNavigate4URL ='')-- or @IndexofSelect =0 )  
  
SET @SQL =@SQL + ''''' as CustomNavigate4URL,'  
ELSE  
BEGIN  
 IF(@IndexofSelect > 0 )  
 SET @SQL =@SQL + @CustomNavigate4URL+' as CustomNavigate4URL,'  
 else  
 SET @SQL =@SQL + ''''+@CustomNavigate4URL+''' as CustomNavigate4URL,'  
END  
SET @IndexofSelect =(select CHARINDEX('select',@CustomNavigate5URL,0))  
  
--Custom Icon5 NavigateURL  
IF(@CustomNavigate5URL is NULL or @CustomNavigate5URL ='')-- or @IndexofSelect =0 )  
SET @SQL =@SQL + ''''' as CustomNavigate5URL,'  
ELSE  
BEGIN  
 IF(@IndexofSelect > 0 )  
 SET @SQL =@SQL + @CustomNavigate5URL+' as CustomNavigate5URL,'  
 else  
 SET @SQL =@SQL + ''''+@CustomNavigate5URL+''' as CustomNavigate5URL,'  
END  
  
SET @SQL =@SQL +' (select id  from Attribute where entityid =(select id from Entity where tablename =''EmployeeContact'') and code=''workemail'') as EmailId,  
       (select workemail  from EmployeeContact EC where EC.employeeid =EP.EmployeeId) as Email,  
       (case (select dbo.uspCheckHasChildren(EP.Id)) when ''0'' then ''0'' else ''1'' end) as HasChildren,  
       (select dbo.uspCheckHasChildren(EP.Id)) as childCount,       
       (select dbo.uspGetPositionParentId(EP.Positionid)) as PositionParentId,  
       isnull((select top 1 e.availabilitystatusid from Employee e where e.id=EP.employeeId),1) as availabilitystatusid,  
       (select top 1 e.availabilitymessage from Employee e where e.id=EP.employeeId) as availabilitymessage,  
       isnull((select top 1 a.icon from Employee e inner join [AvailabilityStatus] a on a.id = e.availabilitystatusid where e.id=ep.employeeid),''imnon.gif'') as availabilityiconurl,  
       (select dbo.uspCheckHasChildren(EP.Id)) as Directheadcount,  
       (select dbo.uspGetTotalHeadCountRecursive(EP.Positionid)) as TotalHeadCount,
	   (select dbo.uspGetTotalHeadCountRecursive2(EP.Positionid)) as ActualChildCount,
	   (select dbo.uspGetTotalHeadCountRecursive3(EP.Positionid)) as ActualTotalCount,0,0,
	   (select dbo.uspGetEmployeeStatusVisible(e.status, EP.Positionid, EP.id)),
	   (select case when p.isassistant = ''Y'' then 1 else 0 end from Position p where p.id = EP.positionid) 
	   '  
         
  
  
  
SET @SQL =@SQL +'  from EmployeePosition EP LEFT OUTER JOIN Employee e ON e.Id = EP.employeeid WHERE ep.IsDeleted = 0 '  

IF @empId > 0 BEGIN
	SET @SQL = @SQL + ' AND ep.id = ' + cast(@empPosId as varchar) + '';
END

/*********************** Copying the values from EMPLOYEEPOSITIONINFO to EMPLOYEEPOSITIONINFO2 *****************************************************************/  
declare @RowCountE2 int  
SET @RowCountE2=(select COUNT(Id) from EmployeePositionInfo2)  
  
declare @RowCountE1 int  
SET @RowCountE1=(select COUNT(Id) from EmployeePositionInfo)  
--PRINT @RowCountE1  
DELETE FROM EmployeePositionInfo2;

if(@RowCountE1 > 0 AND (@empId < 1 OR @empId IS NULL))  
BEGIN  
   

 
 BEGIN TRY  
 BEGIN TRANSACTION tabCopy  
  truncate table  EmployeePositionInfo2  
  
  SET @CopySQL ='insert into EmployeePositionInfo2 select * from EmployeePositionInfo'  
          
  Execute sp_Executesql @CopySQL  
  
  truncate table  EmployeePositionInfo  
    
  COMMIT TRANSACTION tabCopy  
 END TRY  
 BEGIN CATCH   
  ROLLBACK TRANSACTION tabCopy  
  Insert into errortab(errordescription,errornumber) values(ERROR_MESSAGE(), ERROR_NUMBER())  
  
 END CATCH    
   
END  
     /*PRINT @ParamDefinition
     PRINT  @CustomTablename1     
     PRINT  @CustomFieldname1   
     PRINT  @CustomFieldId1  
     PRINT  @CustomField1Condn  
       
     PRINT  @CustomTablename2     
     PRINT  @CustomFieldname2     
     PRINT  @CustomFieldId2  
     PRINT  @CustomField2Condn  
       
     PRINT  @CustomTablename3     
     PRINT  @CustomFieldname3     
     PRINT  @CustomFieldId3  
     PRINT  @CustomField3Condn  
       
     PRINT  @CustomTablename4     
     PRINT  @CustomFieldname4     
     PRINT  @CustomFieldId4  
     PRINT  @CustomField4Condn  
       
     PRINT  @CustomIcon1Id  
     PRINT  @CustomIcon1ImageURL  
     PRINT  @CustomIcon1Tooltip  
     PRINT  @CustomNavigate1URL  
       
     PRINT  @CustomIcon2Id  
     PRINT  @CustomIcon2ImageURL  
     PRINT  @CustomIcon2Tooltip  
     PRINT  @CustomNavigate2URL  
       
     PRINT  @CustomIcon3Id  
     PRINT  @CustomIcon3ImageURL  
     PRINT  @CustomIcon3Tooltip  
     PRINT  @CustomNavigate3URL  
       
     PRINT  @CustomIcon4Id  
     PRINT  @CustomIcon4ImageURL  
     PRINT  @CustomIcon4Tooltip  
     PRINT  @CustomNavigate4URL  
       
     PRINT  @CustomIcon5Id  
     PRINT  @CustomIcon5ImageURL  
     PRINT  @CustomIcon5Tooltip  
     PRINT  @CustomNavigate5URL */
 --PRINT @SQL 
 
 IF @empId < 1 OR @empId IS NULL BEGIN
	DELETE FROM EmployeePositionInfo;
 END
 
 Execute sp_Executesql @SQL 
/*Execute sp_Executesql @ParamDefinition,     
       @CustomTablename1 ,    
       @CustomFieldname1 ,    
       @CustomFieldId1,  
       @CustomField1Condn,  
       @CustomTablename2 ,    
       @CustomFieldname2 ,    
       @CustomFieldId2,  
       @CustomField2Condn,  
       @CustomTablename3 ,    
       @CustomFieldname3 ,    
       @CustomFieldId3,  
       @CustomField3Condn,  
       @CustomTablename4 ,    
       @CustomFieldname4 ,    
       @CustomFieldId4,  
       @CustomField4Condn,  
       @CustomIcon1Id,  
       @CustomIcon1ImageURL,  
       @CustomIcon1Tooltip,  
       @CustomNavigate1URL,  
       @CustomIcon2Id,  
       @CustomIcon2ImageURL,  
       @CustomIcon2Tooltip,  
       @CustomNavigate2URL,  
       @CustomIcon3Id,  
       @CustomIcon3ImageURL,  
       @CustomIcon3Tooltip,  
       @CustomNavigate3URL,  
       @CustomIcon4Id,  
       @CustomIcon4ImageURL,  
       @CustomIcon4Tooltip,  
       @CustomNavigate4URL,  
       @CustomIcon5Id,  
       @CustomIcon5ImageURL,  
       @CustomIcon5Tooltip,  
       @CustomNavigate5URL    */
         
         
--PRINT 'I reached Herer'         
         
SET @RowCountE1=(select COUNT(Id) from EmployeePositionInfo)  
--PRINT @RowCountE1   
     
if(@RowCountE1 > 0 AND (@empId < 1 OR @empId IS NULL))  
BEGIN  
INSERT INTO EmployeePositionInfo2 select * from EmployeePositionInfo  
END  
/*Update Employee Group icons */        
 CREATE TABLE #TEMP(Id int identity(1,1) not null,CustomIconId varchar(100),EmpGrpId int)  
 insert into #TEMP select SUBSTRING (P.code,0,CHARINDEX ('url',P.code)) CustomIconId,SUBSTRING(AP.value,charindex('=',AP.value)+1,LEN(AP.value)-charindex('=',AP.value)) as EmpGrpId from ApplicationPreference AP inner join Preference P on P.id =AP.preferenceid where  AP.type ='Membership' and p.code like 'customIcon%url'  
 DECLARE @Count int  
 DECLARE @I int  
 SET @Count =0  
 SET @Count =(select COUNT(Id) from #TEMP)  
 SET @I =1  
 DECLARE @SUBSQL nvarchar(2000)  
 DECLARE @EMPGRPID int  
 DECLARE @CUSTOMICONID Varchar(100)  
 DECLARE @EMPGRPURL varchar(100)  
 DECLARE @EMPGroupTooltip varchar(100)  
 declare @ParamDefinitionSUB nvarchar(2000)  
 SET @ParamDefinitionSUB ='@CUSTOMICONID nvarchar(100),@EMPGRPURL nvarchar(100),@EMPGroupTooltip nvarchar(100),@EMPGRPID int'  
 WHILE @I <= @Count   
 BEGIN  
  SET @EMPGRPID =(select EmpGrpId from #TEMP  where id=@I)   
  SET @CUSTOMICONID =(select CustomIconId from #TEMP  where id=@I)   
  SET @EMPGRPURL =(select icon from EmployeeGroup where id=@EMPGRPID )  
  SET @EMPGroupTooltip =(select name from EmployeeGroup where id=@EMPGRPID )  
    
    
  SET @SUBSQL ='UPDATE ' + @tableInsert + ' SET '+@CUSTOMICONID+'id='+convert(varchar(10),@EMPGRPID)+', '+@CUSTOMICONID+'url =''Employee Group/'+@EMPGRPURL+''', '+@CUSTOMICONID+'tooltip='''+@EMPGroupTooltip+''' where employeeid in (select employeeid from EmployeeGroupEmployee where employeegroupid='+convert(varchar(10),@EMPGRPID)+')'  
  --PRINT @SUBSQL  
  EXECUTE sp_executesql @SUBSQL,@ParamDefinitionSUB,@CUSTOMICONID,@EMPGRPURL,@EMPGroupTooltip,@EMPGRPID  
    
  SET @SUBSQL ='UPDATE ' + @tableInsert + ' SET '+@CUSTOMICONID+'id=NULL, '+@CUSTOMICONID+'url ='''', '+@CUSTOMICONID+'tooltip='''' where employeeid not in (select employeeid from EmployeeGroupEmployee where employeegroupid='+convert(varchar(10),@EMPGRPID)+')'  
  --PRINT @SUBSQL  
  EXECUTE sp_executesql @SUBSQL,@ParamDefinitionSUB,@CUSTOMICONID,@EMPGRPURL,@EMPGroupTooltip,@EMPGRPID  
  
  SET @I =@I +1  
 END
 DROP table #TEMP  
  
COMMIT TRANSACTION runUpdatePreferenceProcess    
END TRY  
BEGIN CATCH  
ROLLBACK TRANSACTION runUpdatePreferenceProcess  
Insert into errortab(errordescription,errornumber) values(ERROR_MESSAGE(), ERROR_NUMBER())  
END CATCH   

IF @empId > 0 BEGIN
	DECLARE @singleUpdateSql nvarchar(max) =
	'
		UPDATE epi
		SET
		epi.directftecount = epi2.directftecount,
		epi.totalftecount = epi2.totalftecount,
		epi.displayname = epi2.displayname,
		epi.directheadcount = epi2.directheadcount,
		epi.totalheadcount = epi2.totalheadcount,
		epi.positionparentid = epi2.positionparentid,
		epi.childcount = epi2.childcount,
		epi.haschildren = epi2.haschildren,
		epi.emailid = epi2.emailid,
		epi.employeeimageurlid = epi2.employeeimageurlid,
		epi.employeeimageurl = epi2.employeeimageurl,
		epi.positiontitleid = epi2.positiontitleid,
		epi.positiontitle = epi2.positiontitle,
		epi.customfield1 = epi2.customfield1,
		epi.customfield1value = epi2.customfield1value,
		epi.customfield2 = epi2.customfield2,
		epi.customfield3 = epi2.customfield3,
		epi.customfield4 = epi2.customfield4,
		epi.customfield1id = epi2.customfield1id,
		epi.customfield2id = epi2.customfield2id,
		epi.customfield3id = epi2.customfield3id,
		epi.customfield4id = epi2.customfield4id,
		epi.customfield2value = epi2.customfield2value,
		epi.customfield3value = epi2.customfield3value,
		epi.customfield4value = epi2.customfield4value,
		epi.availabilitymessage = epi2.availabilitymessage,
		epi.availabilitystatus = epi2.availabilitystatus,
		epi.availabilityiconurl = epi2.availabilityiconurl,
		epi.email = epi2.email,
		epi.customicon1id = epi2.customicon1id,
		epi.customicon1url = epi2.customicon1url,
		epi.customicon1tooltip = epi2.customicon1tooltip,
		epi.customnavigate1url = epi2.customnavigate1url,
		epi.customicon2id = epi2.customicon2id,
		epi.customicon2url = epi2.customicon2url,
		epi.customicon2tooltip = epi2.customicon2tooltip,
		epi.customnavigate2url = epi2.customnavigate2url,
		epi.customicon3id = epi2.customicon3id,
		epi.customicon3url = epi2.customicon3url,
		epi.customicon3tooltip = epi2.customicon3tooltip,
		epi.customnavigate3url = epi2.customnavigate3url,
		epi.customicon4id = epi2.customicon4id,
		epi.customicon4url = epi2.customicon4url,
		epi.customicon4tooltip = epi2.customicon4tooltip,
		epi.customnavigate4url = epi2.customnavigate4url,
		epi.customicon5id = epi2.customicon5id,
		epi.customicon5url = epi2.customicon5url,
		epi.customicon5tooltip = epi2.customicon5tooltip,
		epi.customnavigate5url = epi2.customnavigate5url,
		epi.IsVisible = epi2.IsVisible,
		epi.IsAssistant = epi2.IsAssistant,
		epi.ActualChildCount = epi2.ActualChildCount,
		epi.ActualTotalCount = epi2.ActualTotalCount
		FROM EmployeePositionInfo epi
		INNER JOIN
		EmployeePositionInfo2 epi2
		ON epi.id = epi2.id
		WHERE epi.employeeid = ' + cast(@empId as varchar) + ' AND epi.positionid = ' + cast(@posId as varchar) + ' AND epi.id = ' + cast(@empPosId as varchar) + '';
--	print @singleUpdateSql
	EXECUTE sp_executesql @singleUpdateSql
END
END
