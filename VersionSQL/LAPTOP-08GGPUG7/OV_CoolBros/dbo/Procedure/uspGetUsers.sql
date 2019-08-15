/****** Object:  Procedure [dbo].[uspGetUsers]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetUsers](@Id int,@search varchar(100),@Condition varchar(100))     
/* ----------------------------------------------------------------------------------------------------------------      
 Name:  : $FunctionName      
 Description : Retrieve all records in the User table.      
 Author(s) : Clark Sayers      
 Date  : 01-October-2004      
 Notes  :      
-------------------------------------------------------------------------------------------------------------------      
 REVISIONS :      
 $Author  : $      
 $Date  : $      
 $History : $      
 $Revision  : $      
------------------------------------------------------------------------------------------------------------------- */      
       
       
AS  
if(@Condition ='')

BEGIN    
PRINT 'HERE'
		if(@Id=0)     
		  SELECT U.[id],       
			U.[authenticationmethodid],       
			U.[accountname],       
			U.[password],       
			U.[displayname],       
			U.[enabled],      
			U.[usereditable],      
			case when u.[type] = 'BuiltIn' THEN 'System' ELSE u.[Type] END as type,    
			AM.name as [authentication],
			U.RequiresPasswordReset,
			U.WorkEmail,
			U.EmployeeIdentifier,
			U.EmployeeIdentifier
		         
		  FROM [dbo].[User] U     
		  INNER JOIN [dbo].[AuthenticationMethod] AM ON AM.id=U.authenticationmethodid     
		  WHERE U.displayname like '%'+@search +'%' or U.accountname  like '%'+@search +'%'  
		  ORDER BY U.accountname    
		else    
			SELECT U.[id],       
			U.[authenticationmethodid],       
			U.[accountname],       
			U.[password],       
			U.[displayname],       
			U.[enabled],      
			U.[usereditable],      
			U.[type],    
			AM.name as [authentication],
			u.RequiresPasswordReset,
			U.EmployeeIdentifier
		         
		  FROM [dbo].[User] U     
		  INNER JOIN [dbo].[AuthenticationMethod] AM ON AM.id=U.authenticationmethodid     
		  WHERE U.id =@Id    
 END
 ELSE
 BEGIN
 PRINT 'HereP'
 if(@Id=0)     
  SELECT U.[id],       
    U.[authenticationmethodid],       
    U.[accountname],       
    U.[password],       
    U.[displayname],       
    U.[enabled],      
    U.[usereditable],      
    U.[type],    
    AM.name as [authentication]    ,
	u.RequiresPasswordReset,
	U.EmployeeIdentifier
         
  FROM [dbo].[User] U     
  INNER JOIN [dbo].[AuthenticationMethod] AM ON AM.id=U.authenticationmethodid     
  WHERE U.[enabled] =''+@Condition+'' and (U.displayname like '%'+@search +'%' or U.accountname  like '%'+@search +'%')
  ORDER BY U.accountname    
else    
    SELECT U.[id],       
    U.[authenticationmethodid],       
    U.[accountname],       
    U.[password],       
    U.[displayname],       
    U.[enabled],      
    U.[usereditable],      
    U.[type],    
    AM.name as [authentication]   ,
	u.RequiresPasswordReset,
	U.EmployeeIdentifier
         
  FROM [dbo].[User] U     
  INNER JOIN [dbo].[AuthenticationMethod] AM ON AM.id=U.authenticationmethodid   
  WHERE U.id =@Id      
 END
IF @@error != 0      
BEGIN      
 RAISERROR ('General Error', 18, 1)      
 RETURN 1        
END      
       
RETURN 0

