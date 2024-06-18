select distinct
client.DESCRIPTION as client_form_nom, 
spic.IC_SHORT_DESC as client_form_short_desc_ic,
spii.II_SHORT_DESC as client_form_short_desc_ii,
spii.IIVALUE as client_form_value ,
clientdec.DESCRIPTION as client_dec_nom,
decspic.IC_SHORT_DESC as client_dec_short_desc_ic,
decspii.II_SHORT_DESC as client_dec_short_desc_ii,
decspii.IIVALUE as client_dec_value
from RndSuite.RndtRq as form

--props formule
left join  RndSuite.RndtRqIc as formIc on formIc.RQ = form.RQ
left join  RndSuite.RndtRqIcLang as formIcLang on formIcLang.RQ = formIc.RQ and formIcLang.IC = formIc.IC and formIcLang.ICNODE = formIc.ICNODE  
left join  RndSuite.RndtRqIi as formIi on formIi.RQ = formIc.RQ and formIi.IC = formIc.IC and formIi.ICNODE = formIc.ICNODE
left join  RndSuite.RndtRqIiLang as formIiLang on formIiLang.RQ = formIi.RQ and formIiLang.II = formIi.II and formIiLang.IINODE = formIi.IINODE  and formIiLang.IC = formIi.IC and formIiLang.ICNODE = formIi.ICNODE

--client_formule
left join RndSuite.RndtRqSp as rqsp on rqsp.RQ = form.RQ 
left join RndSuite.RndtSp as client on client.SP = rqsp.SP and client.SP_VERSION in ( select CASE rqsp.SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndtSp x where x.SP = client.SP) else rqsp.SP_VERSION end)
left join RndSuite.RndtSpIc as spic on spic.SP = client.SP 
Left join RndSuite.RndtSpIcLang as spiclang on spiclang.SP = spic.SP and spiclang.SP_VERSION = spic.SP_VERSION and spiclang.IC = spic.IC and spiclang.ICNODE = spic.ICNODE
left join RndSuite.RndtSpIi as spii on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE and spii.IC = spic.IC
Left join RndSuite.RndtSpIiLang as spiilang on spiilang.SP = spii.SP and spiilang.SP_VERSION = spii.SP_VERSION and spiilang.IC = spii.IC and spiilang.ICNODE = spii.ICNODE and spiilang.IINODE = spii.IINODE

--props du dec
left join RndSuite.RndtRqRq as rqrq on form.RQ = rqrq.RQ
left join RndSuite.RndtRq as decprop on decprop.RQ = rqrq.RQ_CHILD
left join RndSuite.RndtRqIc as decic on decic.RQ = decprop.RQ 
left join RndSuite.RndtRqIi as decii on decii.RQ = decic.RQ and decii.IC = decic.IC and decii.ICNODE = decic.ICNODE

--client dec
left join RndSuite.RndtRqSp as rqspdec on rqspdec.RQ = decprop.RQ
left join RndSuite.RndtSp as clientdec on clientdec.SP = rqspdec.SP and clientdec.SP_VERSION in ( select CASE rqspdec.SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndtSp x where x.SP = clientdec.SP) else rqspdec.SP_VERSION end)
left join RndSuite.RndtSpIc as decspic on decspic.SP = clientdec.SP 
Left join RndSuite.RndtSpIcLang as decspiclang on decspiclang.SP = decspic.SP and decspiclang.SP_VERSION = decspic.SP_VERSION and decspiclang.IC = decspic.IC and decspiclang.ICNODE = decspic.ICNODE
left join RndSuite.RndtSpIi as decspii on decspii.SP = decspic.SP and decspii.SP_VERSION = decspic.SP_VERSION and decspii.ICNODE = decspic.ICNODE and decspii.IC = decspic.IC
Left join RndSuite.RndtSpIiLang as decspiilang on decspiilang.SP = decspii.SP and decspiilang.SP_VERSION = decspii.SP_VERSION and decspiilang.IC = decspii.IC and decspiilang.ICNODE = spii.ICNODE and decspiilang.IINODE = spii.IINODE


where form.RQ_VALUE = 'FM20240528-6'
