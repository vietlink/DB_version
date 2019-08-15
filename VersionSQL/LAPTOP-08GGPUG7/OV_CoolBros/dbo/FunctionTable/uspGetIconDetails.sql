/****** Object:  Function [dbo].[uspGetIconDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE function [dbo].[uspGetIconDetails](@CustimIconname varchar(100),@IconNo varchar(1))
RETURNS @retCustIconDetails TABLE 
(
   
    CustomIconId nvarchar(50),
    CustomIconImageURL nvarchar(150) NULL, 
    CustomIconImageTooltip nvarchar(150) NULL, 
    CustomNavigateURL nvarchar(150) NULL
    
)
AS 
BEGIN
		
		declare @TypeofIcon varchar(100)
		declare @SUBSQL varchar(500)
		declare @CustomIconId varchar(100)
		declare @CustomIconImageURL varchar(100)
		declare @CustomIconTooltip varchar(100)
		declare @CustomNavigateURL varchar(100)
		declare @CustomNavigateURLName varchar(100)
		
		SET @CustomNavigateURL=NULL;
		SET @TypeofIcon =(select [TYPE] from ApplicationPreference
					where preferenceid in(
					select id from Preference where code  = @CustimIconname+'url'))
					
		
		if(@TypeofIcon ='Membership') --Custom Icon  is an Employee Group Icon
		BEGIN
		   SET @CustomIconId =NULL;
		   SET @CustomIconImageURL =(select icon from EmployeeGroup where id=
									(select Convert(int,substring(value,charindex('=',value)+1,2)) from ApplicationPreference
									where preferenceid =(select id from Preference where code like @CustimIconname+'url')))
		  SET @CustomIconTooltip  =(select name from EmployeeGroup where id=
									(select Convert(int,substring(value,charindex('=',value)+1,2)) from ApplicationPreference
									where preferenceid =(select id from Preference where code like @CustimIconname+'tooltip')))
		  SET @CustomNavigateURL=NULL
		  if(@CustomIconImageURL is NULL)
			SET @CustomIconImageURL=NULL;
		  if(@CustomIconTooltip is null)
			set @CustomIconTooltip=NULL;

		END
		ELSE if(@TypeofIcon ='Attribute') --Custom Icon  is a dynamic link
		BEGIN
		   SET @CustomIconId =(select Value from ApplicationPreference
								where preferenceid in(
								select id from Preference where code  = @CustimIconname+'id'))						
		   SET @CustomIconImageURL =(select value from ApplicationPreference
									where preferenceid =(select id from Preference where code like @CustimIconname+'url'))
		  
		  --/* dynamic data retrieving*/
		  DECLARE @EntityId varchar(100)
		  DECLARE @TableName varchar(100)
		  DECLARE @Columnname varchar(100)
		  
		  
				SET @TableName =(select substring(value,0,CHARINDEX('.',value)) as Entity 
									from ApplicationPreference where preferenceid =(select id from Preference where code like @CustimIconname+'tooltip'))		
				SET @EntityId =	(select id from Entity where tablename =(select substring(value,0,CHARINDEX('.',value)) as Entity 
									from ApplicationPreference where preferenceid =(select id from Preference where code like @CustimIconname+'tooltip')))
				SET @Columnname = (select substring(substring(value,CHARINDEX('.',value)+1,LEN(value)-CHARINDEX('.',value)),0,CHARINDEX('.',substring(value,CHARINDEX('.',value)+1,LEN(value)-CHARINDEX('.',value))))
										from ApplicationPreference where preferenceid =(select id from Preference where code like @CustimIconname+'tooltip'))
				
		   
				SET @CustomIconTooltip  =(select shortname from Attribute where entityid =@EntityId and columnname=@Columnname)
				
				if(@TableName='Employee' )					
					SELECT @CustomNavigateURL=' (select '+@Columnname+' from '+@TableName +' T1 WHERE T1.id=EP.employeeid)'	
				if(@TableName='EmployeeContact' or @TableName='EmployeeReference' or @TableName='EmployeePosition')	
					SELECT @CustomNavigateURL=' (select '+@Columnname+' from '+@TableName +' T1 WHERE T1.employeeid=EP.employeeid)'
				else if(@TableName='PositionReference')					
					SELECT @CustomNavigateURL=' (select '+@Columnname+' from '+@TableName +' T1 WHERE T1.positionid=EP.positionid)'					
				else if(@TableName='Position')					
					SELECT @CustomNavigateURL=' (select '+@Columnname+' from '+@TableName +' T1 WHERE T1.id=EP.positionid)'	
		
			  
		 
		END
		ELSE if(@TypeofIcon ='Value') --Custom Icon  is a static link or not
		BEGIN
			SET @CustomNavigateURLName ='customnavigate'+@IconNo+'url'
			SET @CustomIconId =(select value from ApplicationPreference  where preferenceid =(select id from Preference where code like @CustimIconname+'id'))
			SET @CustomIconImageURL =(select value from ApplicationPreference  where preferenceid =(select id from Preference where code like @CustimIconname+'url'))
			SET @CustomIconTooltip  =(select value from ApplicationPreference  where preferenceid =(select id from Preference where code like @CustimIconname+'tooltip'))
			SET @CustomNavigateURL  =(select value from ApplicationPreference  where preferenceid =(select id from Preference where code like @CustomNavigateURLName))
		 

		END
		
		INSERT @retCustIconDetails
        SELECT @CustomIconId,@CustomIconImageURL,@CustomIconTooltip,@CustomNavigateURL
		RETURN;

END


