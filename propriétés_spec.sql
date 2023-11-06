EXEC [RndSuite].[RndprSetConnectionForReport] @p_UserName;
    select fr.FR_VALUE, spP.SP, spP.DESCRIPTION, spP.SP_VALUE+' ['+format(spP.SP_VERSION,'0')+']' as SP_VALUE,
        spP.STATUSID as SS, spP.EFFECTIVE_FROM, spP.EFFECTIVE_TILL,
        case when b.LAST_NAME is null then b.FIRST_NAME else b.LAST_NAME+', '+b.FIRST_NAME end as CREATED_BY,
        spP.CREATED_ON, 
        c.DESCRIPTION as STATUS,
        ltrim(rtrim(substring(c.SS_STYLE1,7,7))) as STATUS_COLOR
    from RndSuite.RndvRepSp spP
	inner join RndSuite.RndvFr fr on spP.FR = fr.FR and spP.FR_VERSION = fr.FR_VERSION
    inner join RndSuite.RndvSpSp spsp on spsp.SP = spP.SP and spsp.SP_VERSION = spP.SP_VERSION
    inner join RndSuite.RndvSp spC on spC.SP = spsp.CHILD_SP and spC.SP_VERSION in ( select CASE spsp.CHILD_SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = spC.SP) else spsp.CHILD_SP_VERSION end)
    inner join RndSuite.RndvContact b on spP.CREATED_BY = b.CONTACT
    inner join RndSuite.RndvSs c on spP.STATUSID = c.SS
    where spC.UNIQUE_ID = @p_UniqueID

    union all

    select fr.FR_VALUE,spC.SP, spC.DESCRIPTION, spC.SP_VALUE+' ['+format(spC.SP_VERSION,'0')+']' as SP_VALUE,
        spC.STATUSID as SS, spC.EFFECTIVE_FROM, spC.EFFECTIVE_TILL,
        case when b.LAST_NAME is null then b.FIRST_NAME else b.LAST_NAME+', '+b.FIRST_NAME end as CREATED_BY,
        spC.CREATED_ON, 
        c.DESCRIPTION as STATUS,
        ltrim(rtrim(substring(c.SS_STYLE1,7,7))) as STATUS_COLOR
    from RndSuite.RndvRepSp spC
	inner join RndSuite.RndvFr fr on spC.FR = fr.FR and spC.FR_VERSION = fr.FR_VERSION
    inner join RndSuite.RndvSpSp spsp on spC.SP = spsp.CHILD_SP and spC.SP_VERSION  in ( select CASE spsp.CHILD_SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = spC.SP) else spsp.CHILD_SP_VERSION end)
    inner join RndSuite.RndvSp spP on spsp.SP= spP.SP and spsp.SP_VERSION = spP.SP_VERSION
    inner join RndSuite.RndvContact b on spC.CREATED_BY = b.CONTACT
    inner join RndSuite.RndvSs c on spC.STATUSID = c.SS
    where spC.UNIQUE_ID = @p_UniqueID