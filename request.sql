//Contexte Eurogerm

select rqP.RQ_VALUE	as DEC, rqC.RQ_VALUE as Formulation,sp.SP_VALUE as client, rqCiC.DESCRIPTION,rqCii.DSP_TITLE as Form_DSP_TITLE,rqCii.IIVALUE as Form_IIVALUE


from RndSuite.RndtRq as rqP
join RndSuite.RndtRqSp as rqsp on rqP.RQ = rqsp.RQ
join RndSuite.RndtRqRq as rqrq on rqrq.RQ = rqP.RQ 
join RndSuite.RndtRq as rqC on  rqrq.RQ_CHILD = rqC.RQ
join RndSuite.RndtRqIc as rqCiC on rqCiC.RQ = rqC.RQ 
join RndSuite.RndtRqIi as rqCii on rqCii.RQ = rqCiC.RQ and rqCii.IC = rqCiC.IC and rqCii.ICNODE = rqCiC.ICNODE
join RndSuite.RndtSp as sp on sp.SP = rqsp.SP and sp.SP_VERSION in (
    select CASE rqsp.SP_VERSION when -1 then 
        (select TOP 1 first_value(x.SP_VERSION)
        over(order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndtSp x where x.SP = sp.SP)
else rqsp.SP_VERSION end) 
join RndSuite.RndtSpIc as spic  on spic.SP=sp.SP and spic.SP_VERSION = sp.SP_VERSION
join RndSuite.RndtSpIi as spii on spii.SP = spic.SP and spii.IC = spic.IC and spii.ICNODE = spic.ICNODE
where rqP.RQ = 199
