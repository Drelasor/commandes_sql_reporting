--Recuperation données formule + dec + client
select distinct
form.RQ_VALUE, client.DESCRIPTION as nom_client, spiclang.DSP_TITLE as ic_client_form, spii.II_SHORT_DESC as ii_shortdesc, spiilang.DSP_TITLE , spii.IIVALUE, decprop.DESCRIPTION

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
left join RndSuite.RndtRqRq as rqrq on form.RQ = rqrq.RQ_CHILD
left join RndSuite.RndtRq as decprop on decprop.RQ = rqrq.RQ
left join RndSuite.RndtRqIc as decic on decic.RQ = decprop.RQ 
left join RndSuite.RndtRqIi as decii on decii.RQ = decic.RQ and decii.IC = decic.IC and decii.ICNODE = decic.ICNODE

--client dec
left join RndSuite.RndtRqSp as rqspdec on rqsp.RQ = form.RQ 
left join RndSuite.RndtSp as clientdec on clientdec.SP = rqspdec.SP and clientdec.SP_VERSION in ( select CASE rqspdec.SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndtSp x where x.SP = clientdec.SP) else rqspdec.SP_VERSION end)
left join RndSuite.RndtSpIc as decspic on decspic.SP = clientdec.SP 
Left join RndSuite.RndtSpIcLang as decspiclang on decspiclang.SP = decspic.SP and decspiclang.SP_VERSION = decspic.SP_VERSION and decspiclang.IC = decspic.IC and decspiclang.ICNODE = decspic.ICNODE
left join RndSuite.RndtSpIi as decspii on spii.SP = decspic.SP and decspii.SP_VERSION = decspic.SP_VERSION and decspii.ICNODE = decspic.ICNODE and decspii.IC = decspic.IC
Left join RndSuite.RndtSpIiLang as decspiilang on decspiilang.SP = decspii.SP and decspiilang.SP_VERSION = decspii.SP_VERSION and decspiilang.IC = decspii.IC and decspiilang.ICNODE = spii.ICNODE and decspiilang.IINODE = spii.IINODE


where form.RQ_VALUE = 'FM20240402-4'
order by spiclang.DSP_TITLE desc









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



// fusion occurence production + nombre de sp contenant une ligne de production 

select valeur_distincte , COUNT(*) AS occurences_ligne, nombre_sp
FROM (
    SELECT DISTINCT ppsg_row.DESCRIPTION AS valeur_distincte, sp.SP as valeur_sp
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

 ) AS sous_requete

CROSS JOIN (
    SELECT COUNT(DISTINCT sp.SP) AS nombre_sp
    FROM 
        RndSuite.RndtRq as form
    JOIN 
        RndSuite.RndtRqIc as formIc on formIc.RQ = form.RQ
    JOIN 
        RndSuite.RndtRqIcLang as formIcLang on formIcLang.RQ = formIc.RQ and formIcLang.IC = formIc.IC and formIcLang.ICNODE = formIc.ICNODE  
    JOIN 
        RndSuite.RndtRqIi as formIi on formIi.RQ = formIc.RQ and formIi.IC = formIc.IC and formIi.ICNODE = formIc.ICNODE
    JOIN 
        RndSuite.RndtRqIiLang as formIiLang on formIiLang.RQ = formIi.RQ and formIiLang.II = formIi.II and formIiLang.IINODE = formIi.IINODE  and formIiLang.IC = formIi.IC and formIiLang.ICNODE = formIi.ICNODE
    JOIN 
        RndSuite.RndtFmMat as mat on form.RQ = mat.RQ 
    JOIN 
        RndSuite.RndtSp as sp on sp.SP = mat.SP and sp.SP_VERSION = mat.SP_VERSION
    JOIN 
        RndSuite.RndtSpIc as spic on spic.SP = sp.SP and spic.SP_VERSION = sp.SP_VERSION
    JOIN 
        RndSuite.RndtSpIi as spii on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE and spii.IC = spic.IC	
    JOIN 
        RndSuite.RndtSpIiPpsgRow as ppsg_row on ppsg_row.SP = spii.SP and ppsg_row.SP_VERSION = spii.SP_VERSION and ppsg_row.IC = spii.IC and ppsg_row.ICNODE = spii.ICNODE and ppsg_row.IINODE = spii.IINODE
    WHERE 
        form.RQ_VALUE = 'FM20240423-6' and spii.IDENTIFIER like 'Mixers'
) AS test

group by valeur_distincte,  nombre_sp

// ppsg 

select distinct

sp.SP_VALUE, spic.DSP_TITLE,ppsg_row.DESCRIPTION, cell.VALUE, cell.VALUE_S, cell.PR_SEQ as cell_PR_SEQ, ppsg_row.PR_SEQ as row_PR_SEQ,cell.COL_TP, form.RQ

from RndSuite.RndtRq as form

join RndSuite.RndtRqIc as formIc on formIc.RQ = form.RQ
join RndSuite.RndtRqIcLang as formIcLang on formIcLang.RQ = formIc.RQ and formIcLang.IC = formIc.IC and formIcLang.ICNODE = formIc.ICNODE  

join RndSuite.RndtRqIi as formIi on formIi.RQ = formIc.RQ and formIi.IC = formIc.IC and formIi.ICNODE = formIc.ICNODE
join RndSuite.RndtRqIiLang as formIiLang on formIiLang.RQ = formIi.RQ and formIiLang.II = formIi.II and formIiLang.IINODE = formIi.IINODE  and formIiLang.IC = formIi.IC and formIiLang.ICNODE = formIi.ICNODE

join RndSuite.RndtFmMat as mat on form.RQ = mat.RQ 
join RndSuite.RndtSp as sp on sp.SP = mat.SP and sp.ACTIVE = 1
join RndSuite.RndtSpIc as spic on spic.SP = sp.SP 
join RndSuite.RndtSpIi as spii on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE and spii.IC = spic.IC	
join RndSuite.RndtSpIiPpsgRow as ppsg_row on ppsg_row.SP = spii.SP and ppsg_row.SP_VERSION = spii.SP_VERSION and ppsg_row.IC = spii.IC and ppsg_row.ICNODE = spii.ICNODE and ppsg_row.IINODE = spii.IINODE
join RndSuite.RndtSpIiPpsgCell cell on ppsg_row.SP = cell.SP and ppsg_row.SP_VERSION = ppsg_row.SP_VERSION and ppsg_row.IC = cell.IC and ppsg_row.ICNODE = cell.ICNODE and ppsg_row.IINODE = cell.IINODE and cell.PR_SEQ = ppsg_row.PR_SEQ
--join RndSuite.RndtSpIiLy spiily on spii.SP = spiily.SP and spii.SP_VERSION = spiily.SP_VERSION and spii.ICNODE = spiily.ICNODE and spii.IINODE = spiily.IINODE
--join (select LY, VERSION as LY_VERSION, SEQ as LY_SEQ, COL_ID, 
--        ltrim(rtrim(substring(COL_TP,1,charindex('@',COL_TP,1)-1))) as COL_TYPE,
--              ltrim(rtrim(substring(COL_TP,charindex('@',COL_TP,1)+1,1000))) as COL_LINK,
--              DISP_TITLE,
--              DISP_WIDTH,
--              COL_HIDDEN,
--              COL_LEN,
--              COL_ALIGNMENT,
--              COL_ALIGNMENT_HEADER,
--              COUNT(SEQ) over (partition by LY, VERSION) as COL_NUMBER
--   from RndSuite.RndvLyDetails
--  where COL_HIDDEN <> 1) e on spiily.LY = e.LY and spiily.LY_VERSION = e.LY_VERSION


where form.RQ_VALUE = 'FM20240416-2' and spic.IC = 146  and sp.SP_VALUE = '100012343'
order by COL_TP asc;