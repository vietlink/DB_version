/****** Object:  Procedure [dbo].[uspUpdateUserPassword]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdateUserPassword](@OldPassword varchar(100),@NewPassword varchar(100),@UserId int,@ReturnValue int output)
AS
BEGIN

	--declare @lOldPassword varchar(100)
	--SET @lOldPassword =(select [password] from [User] where id=@UserId)
	--if(@lOldPassword = @OldPassword)
	--BEGIN
		update [User] set password =@NewPassword, RequiresPasswordReset = 0  where id=@UserId 
		SET @ReturnValue =1
		EXEC uspClearBanByUserID @userId
	--END
	--ELSE
	--BEGIN
	--	SET @ReturnValue =0
	--END
END

