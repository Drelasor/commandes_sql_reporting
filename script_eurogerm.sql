/***************************************************
/
/ RndSuite 7 - Reporting configuration script
/
/ Please check the database name and the @ variables before executing the script !!
/
****************************************************/

/* PLEASE MODIFY THE DATABASE NAME IN THE FOLLOWING LINE, IF REQUIRED */

If(OBJECT_ID('tempdb..#TempRep') Is Not Null)
Begin
    Drop Table #TempRep
End
GO

If(OBJECT_ID('dbo.Split') Is Not Null)
Begin
    Drop Function [dbo].[Split]
End
GO

/************************************************************************************************
/   CREATE TEMP FUNCTION 
************************************************************************************************/

CREATE FUNCTION [dbo].[Split]
(
    @String NVARCHAR(4000),
    @Delimiter NCHAR(1)
)
RETURNS TABLE
AS
RETURN
(
    WITH Split(stpos,endpos)
    AS(
        SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
        UNION ALL
        SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1)
            FROM Split
            WHERE endpos > 0
    )
    SELECT 'Id' = ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
        'Data' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+1)-stpos)
    FROM Split
)
GO

/************************************************************************************************
/   REPORTING PREFERENCES 
************************************************************************************************/

use [OpcenterRDnL_Dev]

declare @SSRSServer varchar(MAX)
declare @RndSuiteBackendServer varchar(max)
DECLARE @lLC_DESC nvarchar(2)
DECLARE @lLC numeric(12)
BEGIN
	SET @lLC_DESC = 'CO'
	SELECT @lLC = LC FROM RndSuite.RndtLc WHERE LC_DESC = @lLC_DESC
	
/* PLEASE MODIFY THE URL's IN THE FOLLOWING LINES, IF REQUIRED */
/*
set @SSRSServer = 'http://cesamseedc/ReportServer'
set @RndSuiteBackendServer = 'http://cesamseedc/OpcenterRDnLBackEnd/api/'

delete from RndSuite.RndtPref where CATEGORY = 'Reporting';

insert into RndSuite.RndtPref(PREF_TP,PREF_NAME,SEQ,PREF_VALUE,APPLICABLE_OBJ,CATEGORY,DESCRIPTION)
values('us','SSRS_Server',1,@SSRSServer,'','Reporting','Report Server')

insert into RndSuite.RndtPref(PREF_TP,PREF_NAME,SEQ,PREF_VALUE,APPLICABLE_OBJ,CATEGORY,DESCRIPTION)
values('us','SSRS_Viewer',2,'Pages/ReportViewer.aspx','','Reporting','Report Viewer')

insert into RndSuite.RndtPref(PREF_TP,PREF_NAME,SEQ,PREF_VALUE,APPLICABLE_OBJ,CATEGORY,DESCRIPTION)
values('us','BackendUrl',3,@RndSuiteBackendServer,'','Reporting','The backend url')

insert into RndSuite.RndtPref(PREF_TP,PREF_NAME,SEQ,PREF_VALUE,APPLICABLE_OBJ,CATEGORY,DESCRIPTION)
values('us','DbConnName',4,'ReportFormatting','','Reporting','The database connection name used by backend')
*/



/************************************************************************************************
/   REPORT TYPE CONFIGURATION
************************************************************************************************/

DELETE from [RndSuite].[RndtRpTp];
INSERT [RndSuite].[RndtRpTp] ([RP_TP], [DESCRIPTION]) VALUES (N'management', N'Management');
INSERT [RndSuite].[RndtRpTp] ([RP_TP], [DESCRIPTION]) VALUES (N'request', N'Request');
INSERT [RndSuite].[RndtRpTp] ([RP_TP], [DESCRIPTION]) VALUES (N'sample', N'Sample');
INSERT [RndSuite].[RndtRpTp] ([RP_TP], [DESCRIPTION]) VALUES (N'worksheet', N'Worksheet');
INSERT [RndSuite].[RndtRpTp] ([RP_TP], [DESCRIPTION]) VALUES (N'worklist', N'Worklist');
INSERT [RndSuite].[RndtRpTp] ([RP_TP], [DESCRIPTION]) VALUES (N'specification', N'Specification');

/************************************************************************************************
/   SETUP TEMP TABLE FOR SCRIPT
************************************************************************************************/

create table #TempRep
(
    RP int, --1
    REPNAME Varchar(50) collate SQL_Latin1_General_CP1_CS_AS,  --2
    SHORT_DESC Varchar(50) collate SQL_Latin1_General_CP1_CS_AS, --3
    DESCRIPTION Varchar(50) collate SQL_Latin1_General_CP1_CS_AS, --4
    FOLDER Varchar(50) collate SQL_Latin1_General_CP1_CS_AS, --5
    RP_TP Varchar(50) collate SQL_Latin1_General_CP1_CS_AS,--6
	TK_TP Varchar(50) collate SQL_Latin1_General_CP1_CS_AS,--7
	TASKS Varchar(50) collate SQL_Latin1_General_CP1_CS_AS,--8
	LAUNCHPAD Varchar(50) collate SQL_Latin1_General_CP1_CS_AS--9
)

delete from #TempRep
-- YOU CAN LIST THE TASKS WHERE THE REPORT SHOULD BE AVAILABLE, OR ENTER 'ALL'. EXAMPLES:
 INSERT #TempRep VALUES (1,N'SpecificationReport',N'Spec report',N'Spec report',N'%2fReports',N'specification',N'speclist',N'ALL',N'');
 INSERT #TempRep VALUES (2,N'FormulationReport',N'Form report',N'Form report',N'%2fReports%2fCustom',N'request',N'rqlist',N'ALL',N'');

--                         1       2                   3                    4                    5          6       7   8    9

                             
/************************************************************************************************
/   REPORT CONFIGURATION
************************************************************************************************/

DELETE FROM [RndSuite].[RndtRp] where RP IS NOT NULL

INSERT [RndSuite].[RndtRp] ([RP], [VERSION], [SHORT_DESC], [DESCRIPTION], [RP_CMD], [EFFECTIVE_FROM],  [EFFECTIVE_TILL],  [LOG_HS],  [ALLOW_MODIFY], [ACTIVE], [LC], [LC_VERSION], [SS]) 
select 
	a.RP, CAST(1.0000 AS Numeric(12, 4)), a.SHORT_DESC, a.DESCRIPTION, '{SSRS_Server}/{SSRS_Viewer}?'+a.FOLDER+'%2f'+a.REPNAME, CAST(GetDate() AS DateTime),  NULL,  N'0', N'0', N'1', @lLC, CAST(1.0000 AS Numeric(12, 4)), 1000011
from #TempRep a


/************************************************************************************************
/   REPORT ACCESS RIGHTS -- SELECT ALL UP'S FOR ALL REPORTS !!
************************************************************************************************/

DELETE FROM [RndSuite].[RndtRpAc] where RP IS NOT NULL

INSERT [RndSuite].[RndtRpAc] ([RP], [VERSION], [UP], [US], [AR]) 
select b.RP, CAST(1.0000 AS Numeric(12, 4)) as VERSION, a.UP, 0 as US, N'R' as AR
  from RndSuite.RndtUp a
  cross join #TempRep b
union all
select b.RP, CAST(1.0000 AS Numeric(12, 4)), CAST(-5 AS Numeric(5, 0)), 0, N'R'
  from #TempRep b

/************************************************************************************************
/   REPORT ARGUMENTS
************************************************************************************************/

DELETE FROM [RndSuite].[RndtRpCmdArg] where RP IS NOT NULL


 INSERT [RndSuite].[RndtRpCmdArg] ([RP], [VERSION], [ARGUMENT], [VALUE_TP], [VALUE], [CF])
 VALUES (CAST(1 AS Numeric(12, 0)), CAST(1.0000 AS Numeric(12, 4)), N'p_UniqueID', N'D', N'Specification.SpecificationUniqueId[]', NULL)

 
 INSERT [RndSuite].[RndtRpCmdArg] ([RP], [VERSION], [ARGUMENT], [VALUE_TP], [VALUE], [CF])
 VALUES (CAST(2 AS Numeric(12, 0)), CAST(1.0000 AS Numeric(12, 4)), N'p_RQ', N'D', N'Request.RequestId[]', NULL)


-- ALLWAYS ADD THE RENDER COMMAND TO EACH REPORT !!
INSERT [RndSuite].[RndtRpCmdArg] ([RP], [VERSION], [ARGUMENT], [VALUE_TP], [VALUE], [CF])
select a.RP, CAST(1.0000 AS Numeric(12, 4)), N'rs:Command', N'S', N'Render', NULL
  from #TempRep a


/************************************************************************************************
/   TASK REPORT CONFIG
************************************************************************************************/

DELETE FROM [RndSuite].[RndtTkRp] WHERE RP IS NOT NULL

INSERT [RndSuite].[RndtTkRp] ([TK], [VERSION], [RP], [RP_VERSION], [RP_TP], [SEQ], [VISIBLE]) 
select distinct a.TK, a.VERSION as TK_VERSION, b.RP, CAST(1 AS Numeric(12, 4)) as RP_VERSION, c.DESCRIPTION,
       dense_rank() over (partition by a.TK order by b.RP) as SEQ, 
	   N'1' as VISIBLE
  from RndSuite.RndtTk a
  inner join #TempRep b on a.TK_TP = b.TK_TP and (b.TASKS = 'ALL' or a.TK in (select CAST(Data as integer) as TK from dbo.Split(b.TASKS,',')))
  inner join RndSuite.RndtRpTp c on b.RP_TP = c.RP_TP

/************************************************************************************************
/   LAUNCHPAD REPORT CONFIG
************************************************************************************************/

DELETE FROM [RndSuite].[RndtLpItem] where ITEM_TP = 'RP'

INSERT [RndSuite].[RndtLpItem] ([PANEL_ID], [OPTION_ID], [ITEM_TP], [ITEM_ID], [ITEM_VERSION], [SEQ]) 
select 
CAST(4 AS Numeric(12, 0)), dense_rank() over (order by a.RP) as OPTION_ID, N'RP', a.RP, CAST(1.0000 AS Numeric(12, 4)), 
dense_rank() over (order by a.RP) as SEQ
from #TempRep a
where a.LAUNCHPAD = 'Y'
END
/************************************************************************************************
/   DROP TEMP OBJECTS
************************************************************************************************/

If(OBJECT_ID('tempdb..#TempRep') Is Not Null)
Begin
    Drop Table #TempRep
End


If(OBJECT_ID('dbo.Split') Is Not Null)
Begin
    Drop Function [dbo].[Split]
End

GO

