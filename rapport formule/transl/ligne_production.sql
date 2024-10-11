EXEC [RndSuite].[RndprSetConnectionForReport] @p_UserName;
select valeur_distincte , COUNT(*) AS occurences_ligne, nombre_sp
FROM (
    SELECT DISTINCT ISNULL(ppsg_row.DESCRIPTION,rowlang.DESCRIPTION) AS valeur_distincte, sp.SP as valeur_sp
	from RndSuite.RndvRq as form

join RndSuite.RndvRqIc as formIc on formIc.RQ = form.RQ
join RndSuite.RndvRqIcLang as formIcLang on formIcLang.RQ = formIc.RQ and formIcLang.IC = formIc.IC and formIcLang.ICNODE = formIc.ICNODE  

join RndSuite.RndvRqIi as formIi on formIi.RQ = formIc.RQ and formIi.IC = formIc.IC and formIi.ICNODE = formIc.ICNODE
join RndSuite.RndvRqIiLang as formIiLang on formIiLang.RQ = formIi.RQ and formIiLang.II = formIi.II and formIiLang.IINODE = formIi.IINODE  and formIiLang.IC = formIi.IC and formIiLang.ICNODE = formIi.ICNODE

join RndSuite.RndvFmMat as mat on form.RQ = mat.RQ 
join RndSuite.RndvSp as sp on sp.SP = mat.SP and sp.SP_VERSION = mat.SP_VERSION
join RndSuite.RndvSpIc as spic on spic.SP = sp.SP and spic.SP_VERSION = sp.SP_VERSION
join RndSuite.RndvSpIi as spii on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE and spii.IC = spic.IC	
join RndSuite.RndvSpIiPpsgRow as ppsg_row on ppsg_row.SP = spii.SP and ppsg_row.SP_VERSION = spii.SP_VERSION and ppsg_row.IC = spii.IC and ppsg_row.ICNODE = spii.ICNODE and ppsg_row.IINODE = spii.IINODE
left join RndSuite.RndvPrLang as rowlang  on rowlang.PR = ppsg_row.PR and rowlang.LANG_ID = @p_Lang

where form.RQ = @p_RQ  and spii.IDENTIFIER like 'Mixers'

 ) AS sous_requete

CROSS JOIN (
    SELECT COUNT(DISTINCT sp.SP) AS nombre_sp
    FROM 
        RndSuite.RndvRq as form
    JOIN 
        RndSuite.RndvRqIc as formIc on formIc.RQ = form.RQ
    JOIN 
        RndSuite.RndvRqIcLang as formIcLang on formIcLang.RQ = formIc.RQ and formIcLang.IC = formIc.IC and formIcLang.ICNODE = formIc.ICNODE  
    JOIN 
        RndSuite.RndvRqIi as formIi on formIi.RQ = formIc.RQ and formIi.IC = formIc.IC and formIi.ICNODE = formIc.ICNODE
    JOIN 
        RndSuite.RndvRqIiLang as formIiLang on formIiLang.RQ = formIi.RQ and formIiLang.II = formIi.II and formIiLang.IINODE = formIi.IINODE  and formIiLang.IC = formIi.IC and formIiLang.ICNODE = formIi.ICNODE
    JOIN 
        RndSuite.RndvFmMat as mat on form.RQ = mat.RQ 
    JOIN 
        RndSuite.RndvSp as sp on sp.SP = mat.SP and sp.SP_VERSION = mat.SP_VERSION
    JOIN 
        RndSuite.RndvSpIc as spic on spic.SP = sp.SP and spic.SP_VERSION = sp.SP_VERSION
    JOIN 
        RndSuite.RndvSpIi as spii on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE and spii.IC = spic.IC	
    JOIN 
        RndSuite.RndvSpIiPpsgRow as ppsg_row on ppsg_row.SP = spii.SP and ppsg_row.SP_VERSION = spii.SP_VERSION and ppsg_row.IC = spii.IC and ppsg_row.ICNODE = spii.ICNODE and ppsg_row.IINODE = spii.IINODE
    WHERE 
        form.RQ = @p_RQ  and spii.IDENTIFIER like 'Mixers'
) AS test

group by valeur_distincte,  nombre_sp
having  COUNT(*) = nombre_sp