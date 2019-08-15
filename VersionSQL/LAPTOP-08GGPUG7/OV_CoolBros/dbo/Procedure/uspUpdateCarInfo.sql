/****** Object:  Procedure [dbo].[uspUpdateCarInfo]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateCarInfo] 
	-- Add the parameters for the stored procedure here
	@id int, 
	@name varchar(50),
	@typeid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update car
	set Name= @name,
	CarTypeID= @typeid
	where ID= @id
END

