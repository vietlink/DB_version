/****** Object:  Procedure [dbo].[uspDeleteAllPoliciesForaRole]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  <Raji Prasad>      
-- Create date: <18-11-2013>      
-- Description: <Delete all polcies defined for  role>      
-- =============================================      
CREATE PROCEDURE [dbo].[uspDeleteAllPoliciesForaRole]     
 (  
  @RoleId int
 )
     
AS    
BEGIN    

delete from RolePolicy where roleid =@RoleId
END 
