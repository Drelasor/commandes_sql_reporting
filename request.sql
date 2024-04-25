//récuperation code dluo
select distinct

sp.SP,spii.II_SHORT_DESC, spii.DSP_TITLE, spii.IIVALUE

from RndSuite.RndtRq as form

join RndSuite.RndtRqIc as formIc on formIc.RQ = form.RQ
join RndSuite.RndtRqIcLang as formIcLang on formIcLang.RQ = formIc.RQ and formIcLang.IC = formIc.IC and formIcLang.ICNODE = formIc.ICNODE  

join RndSuite.RndtRqIi as formIi on formIi.RQ = formIc.RQ and formIi.IC = formIc.IC and formIi.ICNODE = formIc.ICNODE
join RndSuite.RndtRqIiLang as formIiLang on formIiLang.RQ = formIi.RQ and formIiLang.II = formIi.II and formIiLang.IINODE = formIi.IINODE  and formIiLang.IC = formIi.IC and formIiLang.ICNODE = formIi.ICNODE

join RndSuite.RndtFmMat as mat on form.RQ = mat.RQ 
join RndSuite.RndtSp as sp on sp.SP = mat.SP and sp.SP_VERSION = mat.SP_VERSION
join RndSuite.RndtSpIi as spii on spii.SP = sp.SP and spii.SP_VERSION = sp.SP_VERSION

where form.RQ = 230
and spii.II_SHORT_DESC like 'MDD_assigned_PF' ;



// récuperation ligne de production 


select distinct

sp.SP, ppsg_row.DESCRIPTION

from RndSuite.RndtRq as form

join RndSuite.RndtRqIc as formIc on formIc.RQ = form.RQ
join RndSuite.RndtRqIcLang as formIcLang on formIcLang.RQ = formIc.RQ and formIcLang.IC = formIc.IC and formIcLang.ICNODE = formIc.ICNODE  

join RndSuite.RndtRqIi as formIi on formIi.RQ = formIc.RQ and formIi.IC = formIc.IC and formIi.ICNODE = formIc.ICNODE
join RndSuite.RndtRqIiLang as formIiLang on formIiLang.RQ = formIi.RQ and formIiLang.II = formIi.II and formIiLang.IINODE = formIi.IINODE  and formIiLang.IC = formIi.IC and formIiLang.ICNODE = formIi.ICNODE

join RndSuite.RndtFmMat as mat on form.RQ = mat.RQ 
join RndSuite.RndtSp as sp on sp.SP = mat.SP and sp.SP_VERSION = mat.SP_VERSION
join RndSuite.RndtSpIc as spic on spic.SP = sp.SP and spic.SP_VERSION = sp.SP_VERSION
join RndSuite.RndtSpIi as spii on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE and spii.IC = spic.IC	
join RndSuite.RndtSpIiPpsgRow as ppsg_row on ppsg_row.SP = spii.SP and ppsg_row.SP_VERSION = spii.SP_VERSION and ppsg_row.IC = spii.IC and ppsg_row.ICNODE = spii.ICNODE and ppsg_row.IINODE = spii.IINODE

	
where form.RQ_VALUE = 'FM20240423-6' and spii.IDENTIFIER like 'Mixers'
