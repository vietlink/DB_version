/****** Object:  Procedure [dbo].[uspUpdateAttributeDefaultNames]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[uspUpdateAttributeDefaultNames]
as
BEGIN

update attribute set shortname='Account Name',longname='Account Name'  where id='1'  and entityid=2
update attribute set shortname='Age',longname='Age'  where id='2'  and entityid=2
update attribute set shortname='Annual Leave Due',longname='Annual Leave Due'  where id='3'  and entityid=2
update attribute set shortname='Avail Msg',longname='Availability Message'  where id='4'  and entityid=2
update attribute set shortname='Status',longname='Availability Status'  where id='5'  and entityid=2
update attribute set shortname='Commencement Date',longname='Commencement Date'  where id='6'  and entityid=2
update attribute set shortname='Company Service Years',longname='Company Service Years'  where id='7'  and entityid=2
update attribute set shortname='Display Name',longname='Display Name'  where id='8'  and entityid=2
update attribute set shortname='Date of Birth',longname='Date of Birth'  where id='9'  and entityid=2
update attribute set shortname='Ethnicity',longname='Ethnicity'  where id='10'  and entityid=2
update attribute set shortname='First Name',longname='First Name'  where id='11'  and entityid=2
update attribute set shortname='Preferred Name',longname='Preferred Name'  where id='12'  and entityid=2
update attribute set shortname='Gender',longname='Gender'  where id='13'  and entityid=2
update attribute set shortname='id',longname='id'  where id='14'  and entityid=2
update attribute set shortname='Employee Location',longname='Employee Location'  where id='15'  and entityid=2
update attribute set shortname='LSL Due',longname='Long Service Leave Due'  where id='16'  and entityid=2
update attribute set shortname='Marital Status',longname='Marital Status'  where id='17'  and entityid=2
update attribute set shortname='Nationality',longname='Nationality'  where id='18'  and entityid=2
update attribute set shortname='Image Location',longname='Image Location'  where id='19'  and entityid=2
update attribute set shortname='Second Name',longname='Second Name'  where id='20'  and entityid=2
update attribute set shortname='Employee Status',longname='Employee Status'  where id='21'  and entityid=2
update attribute set shortname='Surname',longname='Surname'  where id='22'  and entityid=2
update attribute set shortname='Date Suspended',longname='Date Suspended'  where id='23'  and entityid=2
update attribute set shortname='Date of Termination',longname='Date of Termination'  where id='24'  and entityid=2
update attribute set shortname='Third Name',longname='Third Name'  where id='25'  and entityid=2
update attribute set shortname='Title',longname='Title'  where id='26'  and entityid=2
update attribute set shortname='Employee Type',longname='Employee Type'  where id='27'  and entityid=2
update attribute set shortname='Employee ID',longname='Employee ID'  where id='28'  and entityid=2
update attribute set shortname='Position Desc',longname='Position Description'  where id='29'  and entityid=3
update attribute set shortname='Position End Date',longname='Position End Date'  where id='30'  and entityid=3
update attribute set shortname='id',longname='id'  where id='31'  and entityid=3
update attribute set shortname='Pos Is Assistant',longname='Position Is Assistant'  where id='32'  and entityid=3
update attribute set shortname='Position Location',longname='Position Location'  where id='33'  and entityid=3
update attribute set shortname='Occupany Status',longname='Occupany Status'  where id='34'  and entityid=3
update attribute set shortname='OrgUnit 1',longname='Organisation Unit 1'  where id='35'  and entityid=3
update attribute set shortname='OrgUnit 2',longname='Organisation Unit 2'  where id='36'  and entityid=3
update attribute set shortname='OrgUnit 3',longname='Organisation Unit 3'  where id='37'  and entityid=3
update attribute set shortname='OrgUnit 4',longname='Organisation Unit 4'  where id='38'  and entityid=3
update attribute set shortname='OrgUnit 5',longname='Organisation Unit 5'  where id='39'  and entityid=3
update attribute set shortname='OrgUnit 6',longname='Organisation Unit 6'  where id='40'  and entityid=3
update attribute set shortname='OrgUnit 7',longname='Organisation Unit 7'  where id='41'  and entityid=3
update attribute set shortname='OrgUnit 8',longname='Organisation Unit 8'  where id='42'  and entityid=3
update attribute set shortname='OrgUnit 9',longname='Organisation Unit 9'  where id='43'  and entityid=3
update attribute set shortname='OrgUnit 10',longname='Organisation Unit 10'  where id='44'  and entityid=3
update attribute set shortname='parentid',longname='parentid'  where id='45'  and entityid=3
update attribute set shortname='Position Start Date',longname='Position Start Date'  where id='46'  and entityid=3
update attribute set shortname='Position Title',longname='Position Title'  where id='47'  and entityid=3
update attribute set shortname='Position Type',longname='Position Type'  where id='48'  and entityid=3
update attribute set shortname='Position ID',longname='Position ID'  where id='49'  and entityid=3
update attribute set shortname='employeeid',longname='employeeid'  where id='50'  and entityid=1
update attribute set shortname='Emp Pos End Date',longname='Employee Position End Date'  where id='51'  and entityid=1
update attribute set shortname='FTE',longname='Full Time Equivalent'  where id='52'  and entityid=1
update attribute set shortname='id',longname='id'  where id='53'  and entityid=1
update attribute set shortname='positionid',longname='positionid'  where id='54'  and entityid=1
update attribute set shortname='Is Primary Pos',longname='Is Primary Position'  where id='55'  and entityid=1
update attribute set shortname='Emp Pos Start Date',longname='Employee Position Start Date'  where id='56'  and entityid=1
update attribute set shortname='Vacant',longname='Vacant'  where id='57'  and entityid=1
update attribute set shortname='Home Line 1',longname='Home Line 1'  where id='58'  and entityid=4
update attribute set shortname='Home Line2',longname='Home Line 2'  where id='59'  and entityid=4
update attribute set shortname='Home Line3',longname='Home Line 3'  where id='60'  and entityid=4
update attribute set shortname='Home City',longname='Home City'  where id='61'  and entityid=4
update attribute set shortname='Home State',longname='Home State'  where id='62'  and entityid=4
update attribute set shortname='Home Post Code',longname='Home Post Code'  where id='63'  and entityid=4
update attribute set shortname='Home Country',longname='Home Country'  where id='64'  and entityid=4
update attribute set shortname='Home Phone',longname='Home Phone'  where id='65'  and entityid=4
update attribute set shortname='Home Mobile',longname='Home Mobile'  where id='66'  and entityid=4
update attribute set shortname='Home Email',longname='Home Email'  where id='67'  and entityid=4
update attribute set shortname='Postal Line1',longname='Postal Line 1'  where id='68'  and entityid=4
update attribute set shortname='Postal Line2',longname='Postal Line 2'  where id='69'  and entityid=4
update attribute set shortname='Postal Line3',longname='Postal Line 3'  where id='70'  and entityid=4
update attribute set shortname='Postal City',longname='Postal City'  where id='71'  and entityid=4
update attribute set shortname='Postal State',longname='Postal State'  where id='72'  and entityid=4
update attribute set shortname='Postal Post Code',longname='Postal Post Code'  where id='73'  and entityid=4
update attribute set shortname='Postal Country',longname='Postal Country'  where id='74'  and entityid=4
update attribute set shortname='Work Line1',longname='Work Line 1'  where id='75'  and entityid=4
update attribute set shortname='Work Line2',longname='Work Line 2'  where id='76'  and entityid=4
update attribute set shortname='Work Line3',longname='Work Line 3'  where id='77'  and entityid=4
update attribute set shortname='Work City',longname='Work City'  where id='78'  and entityid=4
update attribute set shortname='Work State',longname='Work State'  where id='79'  and entityid=4
update attribute set shortname='Work Post Code',longname='Work Post Code'  where id='80'  and entityid=4
update attribute set shortname='Work Country',longname='Work Country'  where id='81'  and entityid=4
update attribute set shortname='Work Phone',longname='Work Phone'  where id='82'  and entityid=4
update attribute set shortname='Work Extension',longname='Work Extension'  where id='83'  and entityid=4
update attribute set shortname='Work Fax',longname='Work Fax'  where id='84'  and entityid=4
update attribute set shortname='Work Mobile',longname='Work Mobile'  where id='85'  and entityid=4
update attribute set shortname='Work Pager',longname='Work Pager'  where id='86'  and entityid=4
update attribute set shortname='Work Email',longname='Work Email'  where id='87'  and entityid=4
update attribute set shortname='Work Website',longname='Work Website'  where id='88'  and entityid=4
update attribute set shortname='NOK Name',longname='NOK Name'  where id='89'  and entityid=4
update attribute set shortname='NOK Relationship',longname='NOK Relationship'  where id='90'  and entityid=4
update attribute set shortname='NOK Line 1',longname='NOK Line1'  where id='91'  and entityid=4
update attribute set shortname='NOK Line 2',longname='NOK Line2'  where id='92'  and entityid=4
update attribute set shortname='NOK Line 3',longname='NOK Line3'  where id='93'  and entityid=4
update attribute set shortname='NOK City',longname='NOK City'  where id='94'  and entityid=4
update attribute set shortname='NOK State',longname='NOK State'  where id='95'  and entityid=4
update attribute set shortname='NOK Post Code',longname='NOK Post Code'  where id='96'  and entityid=4
update attribute set shortname='NOK Country',longname='NOK Country'  where id='97'  and entityid=4
update attribute set shortname='NOK Phone',longname='NOK Phone'  where id='98'  and entityid=4
update attribute set shortname='NOK Extension',longname='NOK Extension'  where id='99'  and entityid=4
update attribute set shortname='NOK Mobile',longname='NOK Mobile'  where id='100'  and entityid=4
update attribute set shortname='NOK Email',longname='NOK Email'  where id='101'  and entityid=4
update attribute set shortname='Employee Date1',longname='Employee Date1'  where id='102'  and entityid=2
update attribute set shortname='Employee Date2',longname='Employee Date2'  where id='103'  and entityid=2
update attribute set shortname='Employee Date3',longname='Employee Date3'  where id='104'  and entityid=2
update attribute set shortname='Employee Date4',longname='Employee Date4'  where id='105'  and entityid=2
update attribute set shortname='Employee Date5',longname='Employee Date5'  where id='106'  and entityid=2
update attribute set shortname='Employee Date6',longname='Employee Date6'  where id='107'  and entityid=2
update attribute set shortname='Employee Date7',longname='Employee Date7'  where id='108'  and entityid=2
update attribute set shortname='Employee Date8',longname='Employee Date8'  where id='109'  and entityid=2
update attribute set shortname='Employee Date9',longname='Employee Date9'  where id='110'  and entityid=2
update attribute set shortname='Employee Date10',longname='Employee Date10'  where id='111'  and entityid=2
update attribute set shortname='Employee Decimal1',longname='Employee Decimal1'  where id='112'  and entityid=2
update attribute set shortname='Employee Decimal2',longname='Employee Decimal2'  where id='113'  and entityid=2
update attribute set shortname='Employee Decimal3',longname='Employee Decimal3'  where id='114'  and entityid=2
update attribute set shortname='Employee Decimal4',longname='Employee Decimal4'  where id='115'  and entityid=2
update attribute set shortname='Employee Decimal5',longname='Employee Decimal5'  where id='116'  and entityid=2
update attribute set shortname='Employee Decimal6',longname='Employee Decimal6'  where id='117'  and entityid=2
update attribute set shortname='Employee Decimal7',longname='Employee Decimal7'  where id='118'  and entityid=2
update attribute set shortname='Employee Decimal8',longname='Employee Decimal8'  where id='119'  and entityid=2
update attribute set shortname='Employee Decimal9',longname='Employee Decimal9'  where id='120'  and entityid=2
update attribute set shortname='Employee Decimal10',longname='Employee Decimal10'  where id='121'  and entityid=2
update attribute set shortname='Employee Integer1',longname='Employee Integer1'  where id='122'  and entityid=2
update attribute set shortname='Employee Integer2',longname='Employee Integer2'  where id='123'  and entityid=2
update attribute set shortname='Employee Integer3',longname='Employee Integer3'  where id='124'  and entityid=2
update attribute set shortname='Employee Integer4',longname='Employee Integer4'  where id='125'  and entityid=2
update attribute set shortname='Employee Integer5',longname='Employee Integer5'  where id='126'  and entityid=2
update attribute set shortname='Employee Integer6',longname='Employee Integer6'  where id='127'  and entityid=2
update attribute set shortname='Employee Integer7',longname='Employee Integer7'  where id='128'  and entityid=2
update attribute set shortname='Employee Integer8',longname='Employee Integer8'  where id='129'  and entityid=2
update attribute set shortname='Employee Integer9',longname='Employee Integer9'  where id='130'  and entityid=2
update attribute set shortname='Employee Integer10',longname='Employee Integer10'  where id='131'  and entityid=2
update attribute set shortname='Employee Text1',longname='Employee Text1'  where id='132'  and entityid=2
update attribute set shortname='Employee Text2',longname='Employee Text2'  where id='133'  and entityid=2
update attribute set shortname='Employee Text3',longname='Employee Text3'  where id='134'  and entityid=2
update attribute set shortname='Employee Text4',longname='Employee Text4'  where id='135'  and entityid=2
update attribute set shortname='Employee Text5',longname='Employee Text5'  where id='136'  and entityid=2
update attribute set shortname='Employee Text6',longname='Employee Text6'  where id='137'  and entityid=2
update attribute set shortname='Employee Text7',longname='Employee Text7'  where id='138'  and entityid=2
update attribute set shortname='Employee Text8',longname='Employee Text8'  where id='139'  and entityid=2
update attribute set shortname='Employee Text9',longname='Employee Text9'  where id='140'  and entityid=2
update attribute set shortname='Employee Text10',longname='Employee Text10'  where id='141'  and entityid=2
update attribute set shortname='Employee Url1',longname='Employee Url1'  where id='142'  and entityid=2
update attribute set shortname='Employee Url2',longname='Employee Url2'  where id='143'  and entityid=2
update attribute set shortname='Employee Url3',longname='Employee Url3'  where id='144'  and entityid=2
update attribute set shortname='Employee Url4',longname='Employee Url4'  where id='145'  and entityid=2
update attribute set shortname='Employee Url5',longname='Employee Url5'  where id='146'  and entityid=2
update attribute set shortname='code',longname='code'  where id='147'  and entityid=6
update attribute set shortname='icon',longname='icon'  where id='148'  and entityid=6
update attribute set shortname='id',longname='id'  where id='149'  and entityid=6
update attribute set shortname='interfaceid',longname='interfaceid'  where id='150'  and entityid=6
update attribute set shortname='name',longname='name'  where id='151'  and entityid=6
update attribute set shortname='code',longname='code'  where id='152'  and entityid=8
update attribute set shortname='icon',longname='icon'  where id='153'  and entityid=8
update attribute set shortname='id',longname='id'  where id='154'  and entityid=8
update attribute set shortname='name',longname='name'  where id='155'  and entityid=8
update attribute set shortname='Position Date1',longname='Position Date1'  where id='156'  and entityid=3
update attribute set shortname='Position Date2',longname='Position Date2'  where id='157'  and entityid=3
update attribute set shortname='Position Date3',longname='Position Date3'  where id='158'  and entityid=3
update attribute set shortname='Position Date4',longname='Position Date4'  where id='159'  and entityid=3
update attribute set shortname='Position Date5',longname='Position Date5'  where id='160'  and entityid=3
update attribute set shortname='Position Date6',longname='Position Date6'  where id='161'  and entityid=3
update attribute set shortname='Position Date7',longname='Position Date7'  where id='162'  and entityid=3
update attribute set shortname='Position Date8',longname='Position Date8'  where id='163'  and entityid=3
update attribute set shortname='Position Date9',longname='Position Date9'  where id='164'  and entityid=3
update attribute set shortname='Position Date10',longname='Position Date10'  where id='165'  and entityid=3
update attribute set shortname='Position Decimal1',longname='Position Decimal1'  where id='166'  and entityid=3
update attribute set shortname='Position Decimal2',longname='Position Decimal2'  where id='167'  and entityid=3
update attribute set shortname='Position Decimal3',longname='Position Decimal3'  where id='168'  and entityid=3
update attribute set shortname='Position Decimal4',longname='Position Decimal4'  where id='169'  and entityid=3
update attribute set shortname='Position Decimal5',longname='Position Decimal5'  where id='170'  and entityid=3
update attribute set shortname='Position Decimal6',longname='Position Decimal6'  where id='171'  and entityid=3
update attribute set shortname='Position Decimal7',longname='Position Decimal7'  where id='172'  and entityid=3
update attribute set shortname='Position Decimal8',longname='Position Decimal8'  where id='173'  and entityid=3
update attribute set shortname='Position Decimal9',longname='Position Decimal9'  where id='174'  and entityid=3
update attribute set shortname='Position Decimal10',longname='Position Decimal10'  where id='175'  and entityid=3
update attribute set shortname='Position Integer1',longname='Position Integer1'  where id='176'  and entityid=3
update attribute set shortname='Position Integer2',longname='Position Integer2'  where id='177'  and entityid=3
update attribute set shortname='Position Integer3',longname='Position Integer3'  where id='178'  and entityid=3
update attribute set shortname='Position Integer4',longname='Position Integer4'  where id='179'  and entityid=3
update attribute set shortname='Position Integer5',longname='Position Integer5'  where id='180'  and entityid=3
update attribute set shortname='Position Integer6',longname='Position Integer6'  where id='181'  and entityid=3
update attribute set shortname='Position Integer7',longname='Position Integer7'  where id='182'  and entityid=3
update attribute set shortname='Position Integer8',longname='Position Integer8'  where id='183'  and entityid=3
update attribute set shortname='Position Integer9',longname='Position Integer9'  where id='184'  and entityid=3
update attribute set shortname='Position Integer10',longname='Position Integer10'  where id='185'  and entityid=3
update attribute set shortname='Position Text1',longname='Position Text1'  where id='186'  and entityid=3
update attribute set shortname='Position Text2',longname='Position Text2'  where id='187'  and entityid=3
update attribute set shortname='Position Text3',longname='Position Text3'  where id='188'  and entityid=3
update attribute set shortname='Position Text4',longname='Position Text4'  where id='189'  and entityid=3
update attribute set shortname='Position Text5',longname='Position Text5'  where id='190'  and entityid=3
update attribute set shortname='Position Text6',longname='Position Text6'  where id='191'  and entityid=3
update attribute set shortname='Position Text7',longname='Position Text7'  where id='192'  and entityid=3
update attribute set shortname='Position Text8',longname='Position Text8'  where id='193'  and entityid=3
update attribute set shortname='Position Text9',longname='Position Text9'  where id='194'  and entityid=3
update attribute set shortname='Position Text10',longname='Position Text10'  where id='195'  and entityid=3
update attribute set shortname='Position Url1',longname='Position Url1'  where id='196'  and entityid=3
update attribute set shortname='Position Url2',longname='Position Url2'  where id='197'  and entityid=3
update attribute set shortname='Position Url3',longname='Position Url3'  where id='198'  and entityid=3
update attribute set shortname='Position Url4',longname='Position Url4'  where id='199'  and entityid=3
update attribute set shortname='Position Url5',longname='Position Url5'  where id='200'  and entityid=3
update attribute set shortname='availabilityiconurl',longname='availabilityiconurl'  where id='201'  and entityid=10
update attribute set shortname='availabilitymessage',longname='availabilitymessage'  where id='202'  and entityid=10
update attribute set shortname='availabilitystatus',longname='availabilitystatus'  where id='203'  and entityid=10
update attribute set shortname='childcount',longname='childcount'  where id='204'  and entityid=10
update attribute set shortname='customfield1',longname='customfield1'  where id='205'  and entityid=10
update attribute set shortname='customfield1value',longname='customfield1value'  where id='206'  and entityid=10
update attribute set shortname='customfield2',longname='customfield2'  where id='207'  and entityid=10
update attribute set shortname='customfield2value',longname='customfield2value'  where id='208'  and entityid=10
update attribute set shortname='customfield3',longname='customfield3'  where id='209'  and entityid=10
update attribute set shortname='customfield3value',longname='customfield3value'  where id='210'  and entityid=10
update attribute set shortname='customfield4',longname='customfield4'  where id='211'  and entityid=10
update attribute set shortname='customfield4value',longname='customfield4value'  where id='212'  and entityid=10
update attribute set shortname='customicon1tooltip',longname='customicon1tooltip'  where id='213'  and entityid=10
update attribute set shortname='customicon1url',longname='customicon1url'  where id='214'  and entityid=10
update attribute set shortname='customicon2tooltip',longname='customicon2tooltip'  where id='215'  and entityid=10
update attribute set shortname='customicon2url',longname='customicon2url'  where id='216'  and entityid=10
update attribute set shortname='customicon3tooltip',longname='customicon3tooltip'  where id='217'  and entityid=10
update attribute set shortname='customicon3url',longname='customicon3url'  where id='218'  and entityid=10
update attribute set shortname='customicon4tooltip',longname='customicon4tooltip'  where id='219'  and entityid=10
update attribute set shortname='customicon4url',longname='customicon4url'  where id='220'  and entityid=10
update attribute set shortname='customicon5tooltip',longname='customicon5tooltip'  where id='221'  and entityid=10
update attribute set shortname='customicon5url',longname='customicon5url'  where id='222'  and entityid=10
update attribute set shortname='customnavigate1url',longname='customnavigate1url'  where id='223'  and entityid=10
update attribute set shortname='customnavigate2url',longname='customnavigate2url'  where id='224'  and entityid=10
update attribute set shortname='customnavigate3url',longname='customnavigate3url'  where id='225'  and entityid=10
update attribute set shortname='customnavigate4url',longname='customnavigate4url'  where id='226'  and entityid=10
update attribute set shortname='customnavigate5url',longname='customnavigate5url'  where id='227'  and entityid=10
update attribute set shortname='displayname',longname='displayname'  where id='228'  and entityid=10
update attribute set shortname='email',longname='email'  where id='229'  and entityid=10
update attribute set shortname='employeeid',longname='employeeid'  where id='230'  and entityid=10
update attribute set shortname='employeeimageurl',longname='employeeimageurl'  where id='231'  and entityid=10
update attribute set shortname='haschildren',longname='haschildren'  where id='232'  and entityid=10
update attribute set shortname='id',longname='id'  where id='233'  and entityid=10
update attribute set shortname='positionid',longname='positionid'  where id='234'  and entityid=10
update attribute set shortname='positionparentid',longname='positionparentid'  where id='235'  and entityid=10
update attribute set shortname='positiontitle',longname='positiontitle'  where id='236'  and entityid=10
update attribute set shortname='Excl From Sub Count',longname='Exclude From Subordinate Count'  where id='237'  and entityid=1
update attribute set shortname='Avail Msg Edit',longname='Availability Message Edit'  where id='238'  and entityid=2
update attribute set shortname='LinkedIn Id',longname='LinkedIn Id'  where id='239'  and entityid=4
update attribute set shortname='Is Managerial',longname='Is Managerial'  where id='240'  and entityid=1
update attribute set shortname='Twitter',longname='Twitter Account'  where id='241'  and entityid=4
update attribute set shortname='Annual Salary',longname='Annual Salary'  where id='242'  and entityid=2
update attribute set shortname='Primary Skills',longname='Primary Skills'  where id='243'  and entityid=2
update attribute set shortname='Secondary Skills',longname='Secondary Skills'  where id='244'  and entityid=2
update attribute set shortname='Education',longname='Education'  where id='245'  and entityid=2
update attribute set shortname='Employee Url6',longname='Employee Url6'  where id='246'  and entityid=2
update attribute set shortname='Employee Url7',longname='Employee Url7'  where id='247'  and entityid=2
update attribute set shortname='Employee Url8',longname='Employee Url8'  where id='248'  and entityid=2
update attribute set shortname='Employee Url9',longname='Employee Url9'  where id='249'  and entityid=2
update attribute set shortname='Employee Url10',longname='Employee Url10'  where id='250'  and entityid=2
update attribute set shortname='Skype',longname='Skype Account'  where id='251'  and entityid=4
update attribute set shortname='FaceBook',longname='FaceBook Account'  where id='252'  and entityid=4
update attribute set shortname='Planned FTE',longname='Planned FTE'  where id='253'  and entityid=3
update attribute set shortname='Position Url6',longname='Position Url6'  where id='254'  and entityid=3
update attribute set shortname='Position Url7',longname='Position Url7'  where id='255'  and entityid=3
update attribute set shortname='Position Url8',longname='Position Url8'  where id='256'  and entityid=3
update attribute set shortname='Position Url9',longname='Position Url9'  where id='257'  and entityid=3
update attribute set shortname='Position Url10',longname='Position Url10'  where id='258'  and entityid=3
update attribute set shortname='Parent Position ID',longname='Parent Position ID'  where id='259'  and entityid=3
update attribute set shortname='Medical Alert',longname='Medical Alert Details'  where id='260'  and entityid=2

update Attribute set TabBasedSort =NULL
update Attribute set tab  =0

update Attribute set ismanagerial  ='N', ispersonal ='N'


END
-------------------------
