select valeur_distincte , COUNT(*) AS occurences_ligne, nombre_sp
FROM (
    SELECT DISTINCT ISNULL(ppsg_row.DESCRIPTION,rowlang.DESCRIPTION) AS valeur_distincte, sp.SP as valeur_sp
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
left join RndSuite.RndtPrLang as rowlang  on rowlang.PR = ppsg_row.PR and rowlang.LANG_ID = 1

where form.RQ = 192 and spii.IDENTIFIER like 'Mixers'

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
        form.RQ = 192 and spii.IDENTIFIER like 'Mixers'
) AS test

group by valeur_distincte,  nombre_sp
having  COUNT(*) = nombre_sp