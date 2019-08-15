/****** Object:  Procedure [dbo].[uspDeleteAllUsersForaRole]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  <Raji Prasad>      
-- Create date: <19-11-2013>      
-- Description: <Delete all users defined for  role>      
-- =============================================      
CREATE PROCEDURE [dbo].[uspDeleteAllUsersForaRole]     
 (  
  @RoleId int
 )
     
AS    
BEGIN    

delete from RoleUser where roleid =@RoleId
END 
