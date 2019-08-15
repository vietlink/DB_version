/****** Object:  Procedure [dbo].[uspUpdateAppPreferenceCustomIcons]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdateAppPreferenceCustomIcons]
				(@CustomIconNo varchar(10),
				 @type varchar(100),
				 @CustomField varchar(50),
				 @CustomIconImageURL varchar(250),
				 @CustomIconImageToolTip varchar(100),
				 @CustimIconId varchar(100),
				 @CustomNavigateURL varchar(100),
				 @ReturnValue int output)
AS
BEGIN
declare @Count int
SET @Count =0
declare @AppPrefId int
declare @lCustomNavigateURL varchar(100)
if(@type <> 'None')
BEGIN
			/*Update CustomIcon ImageURL*/
			SET @AppPrefId =(select ID from ApplicationPreference  where preferenceid in (select id from Preference where code =''+@CustomField+'url'))
			UPDATE ApplicationPreference SET
					[type] =@type,value =@CustomIconImageURL WHERE ID=@AppPrefId

			SET @Count =@Count +1
			SET @AppPrefId =0
			/*Update CustomIcon Tooltip*/
			SET @AppPrefId =(select ID from ApplicationPreference  where preferenceid in (select id from Preference where code =''+@CustomField+'tooltip'))
			UPDATE ApplicationPreference SET
					[type] =@type,value =@CustomIconImageToolTip  WHERE ID=@AppPrefId
					
			SET @Count =@Count +1		
			SET @AppPrefId =0
			/*Update CustomIcon Id -This applicable only when the Icon selected as a Dynamic Link*/
			if(@type ='Attribute' )
			BEGIN
				SET @AppPrefId =(select ID from ApplicationPreference  where preferenceid in (select id from Preference where code =''+@CustomField+'id'))
				UPDATE ApplicationPreference SET
						[type] ='Value',value =@CustimIconId  WHERE ID=@AppPrefId
				SET @Count =@Count +1
			END

			/*Update CustomIcon Navigate URL -This applicable only when the Icon selected as a Dynamic Link or a Static Link*/
			if(@type ='Attribute' or @type ='Value' )
			BEGIN
				SET @lCustomNavigateURL ='customnavigate'+@CustomIconNo+'url'
				SET @AppPrefId =(select ID from ApplicationPreference  where preferenceid in (select id from Preference where code =@lCustomNavigateURL))
				if(@type ='Attribute')
				BEGIN
						UPDATE ApplicationPreference SET
								[type] ='Lookup',value =@CustomNavigateURL  WHERE ID=@AppPrefId
						SET @Count =@Count +1
				END
				ELSE
				BEGIN 
						UPDATE ApplicationPreference SET
								[type] ='Value',value =@CustomNavigateURL  WHERE ID=@AppPrefId
								
						SET @Count =@Count +1
				END
			END
			ELSE
			BEGIN
				SET @lCustomNavigateURL ='customnavigate'+@CustomIconNo+'url'
				SET @AppPrefId =(select ID from ApplicationPreference  where preferenceid in (select id from Preference where code =@lCustomNavigateURL))
				UPDATE ApplicationPreference SET
								[type] ='None',value =NULL  WHERE ID=@AppPrefId
			END
END
/*None Selected as Type*/
ELSE
BEGIN
	SET @AppPrefId =(select ID from ApplicationPreference  where preferenceid in (select id from Preference where code =''+@CustomField+'id'))
	UPDATE ApplicationPreference SET
			[type] ='None',value =NULL  WHERE ID=@AppPrefId
	SET @Count =@Count +1
	
	SET @lCustomNavigateURL ='customnavigate'+@CustomIconNo+'url'
	SET @AppPrefId =0
	SET @AppPrefId =(select ID from ApplicationPreference  where preferenceid in (select id from Preference where code =@lCustomNavigateURL))
	
	UPDATE ApplicationPreference SET
			[type] ='None',value =NULL  WHERE ID=@AppPrefId
	SET @Count =@Count +1
	
	SET @AppPrefId =0
	SET @AppPrefId =(select ID from ApplicationPreference  where preferenceid in (select id from Preference where code =''+@CustomField+'url'))
	UPDATE ApplicationPreference SET
					[type] =@type,value =NULL WHERE ID=@AppPrefId

	SET @Count =@Count +1
	SET @AppPrefId =0
			/*Update CustomIcon Tooltip*/
	SET @AppPrefId =(select ID from ApplicationPreference  where preferenceid in (select id from Preference where code =''+@CustomField+'tooltip'))
	UPDATE ApplicationPreference SET
			[type] =@type,value =NULL  WHERE ID=@AppPrefId
			
	SET @Count =@Count +1	
ENd
SET @ReturnValue =@Count 
RETURN @ReturnValue

END
