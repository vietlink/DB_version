/****** Object:  Procedure [dbo].[uspDeleteAllEmployeesForaEmployeeGrp]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  <Raji Prasad>      
-- Create date: <21-11-2013>      
-- Description: <Delete all employees defined for  employeegrp>      
-- =============================================      
CREATE PROCEDURE [dbo].[uspDeleteAllEmployeesForaEmployeeGrp]     
 (  
  @EmployeeGrpId int
 )
     
AS    
BEGIN    

delete from EmployeeGroupEmployee where employeegroupid =@EmployeeGrpId
END 
