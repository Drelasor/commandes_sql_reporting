//Contexte Eurogerm

select distinct 
rqP.RQ_VALUE as DEC,rqPLang.DESCRIPTION, 
rqC.RQ_VALUE as Formulation, rqC.DESCRIPTION,
sp.SP_VALUE as client,
splang.DESCRIPTION, 
rqCic.DESCRIPTION,
rqCii.DSP_TITLE as Form_DSP_TITLE,
rqCii.IIVALUE as Form_IIVALUE


--Selection du DEC
from RndSuite.RndtRq as rqP 
join RndSuite.RndtRqLang as rqPLang on rqPLang.RQ = rqP.RQ
join RndSuite.RndtRqIc as rqPic on rqPic.RQ = rqP.RQ 
join RndSuite.RndtRqIi as rqPii on rqPii.RQ = rqPic.RQ and rqPii.IC = rqPic.IC and rqPii.ICNODE = rqPic.ICNODE



--Selection de la formulation du DEC 
join RndSuite.RndtRqRq as rqrq on rqrq.RQ = rqP.RQ 
join RndSuite.RndtRq as rqC on  rqrq.RQ_CHILD = rqC.RQ
join RndSuite.RndtRqIc as rqCic on rqCic.RQ = rqC.RQ 
join RndSuite.RndtRqIi as rqCii on rqCii.RQ = rqCic.RQ and rqCii.IC = rqCic.IC and rqCii.ICNODE = rqCic.ICNODE


--Selection du client lié au DEC
join RndSuite.RndtRqSp as rqsp on rqP.RQ = rqsp.RQ
join RndSuite.RndtSp as sp on sp.SP = rqsp.SP and sp.SP_VERSION in (
    select CASE rqsp.SP_VERSION when -1 then 
        (select TOP 1 first_value(x.SP_VERSION)
        over(order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndtSp x where x.SP = sp.SP)
else rqsp.SP_VERSION end) 
join RndSuite.RndtSpLang as splang on splang.SP = sp.SP and splang.SP_VERSION = sp.SP_VERSION
join RndSuite.RndtSpIc as spic  on spic.SP=sp.SP and spic.SP_VERSION = sp.SP_VERSION
join RndSuite.RndtSpIi as spii on spii.SP = spic.SP and spii.IC = spic.IC and spii.ICNODE = spic.ICNODE

where rqP.RQ = 199