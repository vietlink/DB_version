/****** Object:  Procedure [dbo].[uspGetCompetencySearchList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetCompetencySearchList](@competencylistidMandatory varchar(1000),@competencylistiddesirable varchar(1000))  
as  
begin  
CREATE TABLE #Temp1(Id int IDENTITY(1,1) not null,competencylistidMandatory varchar(100) not null)    
CREATE TABLE #Temp2(Id int IDENTITY(1,1) not null,competencylistidMandatorydesirable varchar(100) not null)    
  
DECLARE @SEP varchar(1)    
SET @SEP =','    
DECLARE @SP INT    
DECLARE @VALUE varchar(100)    
DECLARE @SQL1 nvarchar(4000)
DECLARE @SQL2 nvarchar(4000)
declare @MainSQL nvarchar(4000)
DECLARE @PARAMS nvarchar(1000) 
DECLARE @MandatoryCount int
SET @SQL1=''
SET @SQL2=''
SET @MandatoryCount=0;
SET @PARAMS ='@MandatoryCount int'      

------------------Mandatory Fields --------------------------------------------
if(CHARINDEX (',',@competencylistidMandatory)> 0)    
BEGIN    
    
  WHILE PATINDEX('%'+@SEP+'%',@competencylistidMandatory) <> 0    
  BEGIN 
	 PRINT @competencylistidMandatory
     SELECT  @SP = PATINDEX('%' + @SEP + '%',@competencylistidMandatory)    
     SELECT  @VALUE = LEFT(@competencylistidMandatory , @SP - 1)    
     SELECT  @competencylistidMandatory = STUFF(@competencylistidMandatory, 1, @SP, '')    
     INSERT INTO #Temp1 (competencylistidMandatory) VALUES (@VALUE) 
     --if(@SQL1='')
     --SET @SQL1='(competencylistid = '+@VALUE +')'
     --else
     --SET @SQL1=@SQL1+' AND (competencylistid = '+@VALUE +')'
     SET @MandatoryCount=@MandatoryCount+1;
  END    
    
  if(@competencylistidMandatory <>'')    
  BEGIN
  INSERT INTO #Temp1 (competencylistidMandatory) VALUES (@competencylistidMandatory)   
   --if(@SQL1='')
   --  SET @SQL1='(competencylistid = '+@competencylistidMandatory +')'
   --  else
   --  SET @SQL1=@SQL1+' AND (competencylistid = '+@competencylistidMandatory +')'
   SET @MandatoryCount=@MandatoryCount+1;
  END
END    
ELSE    
BEGIN    
  
  if(@competencylistidMandatory <>'')    
  BEGIN
  INSERT INTO #Temp1 (competencylistidMandatory) VALUES (@competencylistidMandatory)  
  SET @MandatoryCount=@MandatoryCount+1;  
	 --  if(@SQL1='')
		-- SET @SQL1='(competencylistid = '+@competencylistidMandatory +')'
		-- else
		-- SET @SQL1=@SQL1+' AND (competencylistid = '+@competencylistidMandatory +')'
  END
END    
----------------------Desirable fields--------------------------------------------------- 
if(@competencylistiddesirable<>'')
BEGIN
if(CHARINDEX (',',@competencylistiddesirable)> 0)    
BEGIN    
    
  WHILE PATINDEX('%'+@SEP+'%',@competencylistiddesirable) <> 0    
  BEGIN    
     SELECT  @SP = PATINDEX('%' + @SEP + '%',@competencylistiddesirable)    
     SELECT  @VALUE = LEFT(@competencylistiddesirable , @SP - 1)    
     SELECT  @competencylistiddesirable = STUFF(@competencylistiddesirable, 1, @SP, '')    
     INSERT INTO #Temp2 (competencylistidMandatorydesirable) VALUES (@VALUE)  
     --if(@SQL2='')
     --SET @SQL2='(competencylistid = '+@VALUE +')'
     --else
     --SET @SQL2=@SQL2+' OR (competencylistid = '+@VALUE +')'
     
  END    
    
  if(@competencylistiddesirable <>'')    
  BEGIN
  INSERT INTO #Temp2 (competencylistidMandatorydesirable) VALUES (@competencylistiddesirable)  
		 --if(@SQL2='')
		 --SET @SQL2='(competencylistid = '+@competencylistiddesirable +')'
		 --else
		 --SET @SQL2=@SQL2+' OR (competencylistid = '+@competencylistiddesirable +')'
  END
END    
ELSE    
BEGIN   
		 INSERT INTO #Temp2 (competencylistidMandatorydesirable) VALUES (@competencylistiddesirable)  
		 --if (@competencylistiddesirable <>'')
		 --BEGIN
			-- --if(@SQL2='')
			-- --SET @SQL2='(competencylistid = '+@competencylistiddesirable +')'
			-- --else
			-- --SET @SQL2=@SQL2+' OR (competencylistid = '+@competencylistiddesirable +')'
		 --END
END 
END
   

if(@MandatoryCount > 0)
BEGIN 

SET @MainSQL='select EPI.id,EPI.positionid,C.Description as Competency,EC.Employeeid,EC.CompetencyListId,E.Displayname,''Mandatory'' as Type,EPI.Email
from EmployeeCompetencyList EC inner join Employee E on E.Id=EC.Employeeid   
inner join CompetencyList CL on CL.Id=Ec.CompetencyListId   
inner join Competencies C on C.Id=CL.CompetencyId  
inner join EmployeePositioninfo EPI on EPI.employeeid=EC.Employeeid  
where EC.Employeeid in (select employeeid from EmployeeCompetencyList where CompetencyListId in (select competencylistidMandatory from #Temp1) 
group by Employeeid having count(employeeid)='''+convert(varchar,@MandatoryCount) +''') and EC.CompetencyListId in (select competencylistidMandatory from #Temp1)'
END
PRINT @MainSQL

if(@competencylistiddesirable<>'')
BEGIN 
	if(@MainSQL<>'')
	BEGIN
	
			SET @MainSQL=@MainSQL+' UNION  ALL
		select EPI.id,EPI.positionid,C.Description as Competency,EC.Employeeid,EC.CompetencyListId,E.Displayname,''Desirable'' as Type,EPI.Email from EmployeeCompetencyList EC inner join Employee E on E.Id=EC.Employeeid   
		inner join CompetencyList CL on CL.Id=Ec.CompetencyListId   
		inner join Competencies C on C.Id=CL.CompetencyId  
		inner join EmployeePositioninfo EPI on EPI.employeeid=EC.Employeeid  
		where competencylistid in (select competencylistidMandatorydesirable from #Temp2) and EC.Employeeid in (select employeeid from EmployeeCompetencyList where CompetencyListId in (select competencylistidMandatory from #Temp1) 
		group by Employeeid having count(employeeid)='''+convert(varchar,@MandatoryCount) +''') ORDER by EC.employeeid'
	END
	ELSE 
	BEGIN

		
		SET @MainSQL='select EPI.id,EPI.positionid,C.Description as Competency,EC.Employeeid,EC.CompetencyListId,E.Displayname,''Desirable'' as Type,EPI.Email from EmployeeCompetencyList EC inner join Employee E on E.Id=EC.Employeeid   
		inner join CompetencyList CL on CL.Id=Ec.CompetencyListId   
		inner join Competencies C on C.Id=CL.CompetencyId  
		inner join EmployeePositioninfo EPI on EPI.employeeid=EC.Employeeid  
		where competencylistid in (select competencylistidMandatorydesirable from #Temp2)'
	END

END
 PRINT @MainSQL
EXECUTE sp_executesql @MainSQL,@PARAMS,@MandatoryCount
end 
