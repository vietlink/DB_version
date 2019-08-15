/****** Object:  Procedure [dbo].[uspAddCar]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddCar] 
	-- Add the parameters for the stored procedure here
	@name varchar(50), @type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into Car (Name, CarTypeID)
	values 
	(@name, @type)
END

