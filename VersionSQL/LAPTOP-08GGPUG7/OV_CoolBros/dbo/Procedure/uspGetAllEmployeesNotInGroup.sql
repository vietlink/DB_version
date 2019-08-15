/****** Object:  Procedure [dbo].[uspGetAllEmployeesNotInGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllEmployeesNotInGroup](@groupid int, @search varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT *
	FROM [dbo].[Employee]
	WHERE isdeleted = 0 and firstname <> 'vacant' and isplaceholder=0 and id not in (select employeeid from EmployeeGroupEmployee where employeegroupid = @groupid) AND (displayname like '%'+@search +'%' or accountname  like '%'+@search +'%' or firstname like '%'+@search +'%' or surname  like '%'+@search +'%' or secondname like '%'+@search +'%' or thirdname like '%'+@search +'%')
	ORDER By surname 
END

