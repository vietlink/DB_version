/****** Object:  Procedure [dbo].[uspGetUserProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================        
-- Author:  <Raji Prasad>        
-- Create date: <20-12-2013>        
-- Description: <Get User Profile>        
-- =============================================        
CREATE PROCEDURE [dbo].[uspGetUserProfile]          
(        
           
 @LoginName varchar(50)          
)          
AS          
BEGIN          
       
          
 SELECT          
  U.[Id],   
  RU.roleid,          
  U.accountname ,          
  U.[Password],              
  U.DisplayName,          
  U.[type],
  U.enabled      ,
  (select top 1 id from employeepositioninfo epi where epi.employeeid = e.id AND epi.positionid = ep.positionid and ep.isdeleted = 0 and ep.primaryposition = 'y') as EmployeePositionInfoID     ,
    e.id as employeeid,
  ep.positionid as positionid,
  ep.Managerial,
  r.[enabled] as RoleEnabled,
  U.IsDeleted
 FROM          
  [User] U left outer join RoleUser RU on U.id=RU.userid    
  left outer join [Role] r on RU.roleid = r.id
  left outer join employee e on e.accountname = u.accountname
  left outer join employeeposition ep on ep.employeeid = e.id and primaryposition = 'Y' and ep.isdeleted = 0
  left outer join position p on p.id = ep.positionid
 WHERE          
 -- [enabled] = 'Y'      
 --AND    
 U.IsDeleted = 0 AND
 ISNULL(e.IsDeleted, 0) = 0
 AND ISNULL(ep.IsDeleted, 0) = 0     
 AND ISNULL(p.IsDeleted,0) = 0
 AND 
  LOWER(U.accountname ) = @LoginName          
          
 SET NOCOUNT OFF;          
END

