/****** Object:  Procedure [dbo].[uspUpdateEmployeeProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmployeeProfile](@id int, @profile varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF EXISTS(SELECT id FROM EmployeeProfile WHERE EmployeeID = @id) BEGIN
		UPDATE EmployeeProfile SET [Profile] = @profile WHERE EmployeeID = @id;
	END
	ELSE
		INSERT INTO EmployeeProfile(EmployeeID, [Profile]) VALUES(@id, @profile)
END


