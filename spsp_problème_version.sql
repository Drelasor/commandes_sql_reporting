inner join RndSuite.RndtRqSp RqToFm on RqToFm.RQ = Fm.RQ
inner join RndSuite.RndtSp FmSp on RqToFm.SP = FmSp.SP 
and FmSp.SP_VERSION in ( select CASE RqToFm.SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) 
over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = FmSp.SP) 
else RqToFm.SP_VERSION end) and FmSp.FR in (select FR from RndSuite.RndtFr where FR_VALUE = 'FM')
