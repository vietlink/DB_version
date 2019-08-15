/****** Object:  Procedure [dbo].[uspGetManagerialPermission]    Committed by VersionSQL https://www.versionsql.com ******/


CREATE PROCEDURE [dbo].[uspGetManagerialPermission](@EMPID int,@POSID int)
AS
BEGIN
select ISNULL(managerial,0) as Mangerial from EmployeePosition where employeeid =@EMPID and positionid =@POSID 
END
