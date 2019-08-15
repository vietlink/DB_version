/****** Object:  Procedure [dbo].[uspCheckEmployeeAccountNameExists]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckEmployeeAccountNameExists](@accountName varchar(255), @employeeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT id FROM Employee WHERE accountname = @accountName AND id <> @employeeId
END


