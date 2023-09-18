inner join RndSuite.RndtRqSp as RqToFm on RqToFm.RQ = Fm.RQ
inner join RndSuite.RndtSp as FmSp on RqToFm.SP = FmSp.SP 
and FmSp.SP_VERSION in ( select CASE RqToFm.SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) 
over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = FmSp.SP) 
else RqToFm.SP_VERSION end) and FmSp.FR in (select FR from RndSuite.RndtFr where FR_VALUE = 'FM')


--avec sp
select *

from RndSuite.RndtSpSp as spsp  
join RndSuite.RndtSp as sp on sp.SP = spsp.SP
and sp.SP_VERSION in ( 
    select CASE spsp.SP_VERSION when -1 then 
        (select TOP 1 first_value(x.SP_VERSION) 
        over(order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = sp.SP)
else spsp.SP_VERSION end) 

-- avec sp_child
select *

from RndSuite.RndtSpSp as spsp  
join RndSuite.RndtSp as sp on sp.SP = spsp.CHILD_SP 
and sp.SP_VERSION in (
    select CASE spsp.CHILD_SP_VERSION when -1 then 
        (select TOP 1 first_value(x.SP_VERSION)
        over(order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = sp.SP)
else spsp.SP_VERSION end) 


/*
in  = La clause "IN" est utilisée pour spécifier une liste de valeurs dans une condition de recherche. 
Elle est généralement utilisée dans une clause WHERE 
pour filtrer les résultats d'une requête en fonction de plusieurs valeurs possibles.

over = La clause "OVER" est utilisée dans le contexte des fonctions d'agrégation (telles que SUM, AVG, COUNT, etc.) 
pour effectuer des calculs sur un ensemble de lignes défini par une fenêtre (window) spécifique. 
Cela permet d'effectuer des calculs cumulatifs ou de calculer des valeurs basées sur des partitions de données.

top = filtrer le nombre de lignes 

first_value = prend la première valeur de la colonne

