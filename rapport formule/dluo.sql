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
