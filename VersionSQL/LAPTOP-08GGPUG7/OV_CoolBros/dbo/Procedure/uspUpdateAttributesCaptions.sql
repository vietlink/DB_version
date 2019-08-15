/****** Object:  Procedure [dbo].[uspUpdateAttributesCaptions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdateAttributesCaptions]
(@Id int,
@entityId int,
@ShortName varchar(20),
@LongName varchar(50),
@Tab varchar(20),
@AttributeSourceID int = null,
@FieldValueListID int = null,
@IsOrgChartGroupField bit = 0
)
AS
BEGIN

	IF @FieldValueListID <> -1 BEGIN
		Update Attribute 
		set 
			shortname =@ShortName,
			longname =@LongName,
			tab =@Tab,
			AttributeSourceID = @AttributeSourceID,
			FieldValueListID = case when @fieldvaluelistid = 0 then null else @FieldValueListID end,
			IsOrgChartGroupField = @IsOrgChartGroupField
		where Id=@Id and entityid =@entityId 
	END
	ELSE BEGIN
		Update Attribute 
		set 
			shortname =@ShortName,
			longname =@LongName,
			tab =@Tab,
			AttributeSourceID = @AttributeSourceID,
			IsOrgChartGroupField = @IsOrgChartGroupField
		where Id=@Id and entityid =@entityId 
	END


END

