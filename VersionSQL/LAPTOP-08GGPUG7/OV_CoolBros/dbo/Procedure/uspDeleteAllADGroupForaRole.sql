/****** Object:  Procedure [dbo].[uspDeleteAllADGroupForaRole]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  <Raji Prasad>      
-- Create date: <19-11-2013>      
-- Description: <Delete all AD group defined for  role>      
-- =============================================      
CREATE PROCEDURE [dbo].[uspDeleteAllADGroupForaRole]     
 (  
  @RoleId int
 )
     
AS    
BEGIN    

delete from RoleSecurityGroup where roleid =@RoleId
END 
