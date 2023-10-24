// Exemple Cedric

EXEC [RndSuite].[RndprSetConnectionForReport] @p_UserName;

 

select a.SP, a.SP_VALUE, a.UNIQUE_ID from RndSuite.RndvSp a
WHERE   (a.UNIQUE_ID  IN (@p_UniqueID))


Union

select c.SP, c.SP_VALUE, c.UNIQUE_ID from RndSuite.RndvSp a
left join RndSuite.RndvSpSp b on a.SP = b.SP and a.SP_VERSION = b.SP_VERSION
left join RndSuite.RndvSp c on b.CHILD_SP = c.SP  and c.SP_VERSION in ( select CASE b.CHILD_SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = c.SP) else b.CHILD_SP_VERSION end)
WHERE   (a.UNIQUE_ID  IN (@p_UniqueID))



/* 
dataset de base

EXEC [RndSuite].[RndprSetConnectionForReport] @p_UserName;
select SP, SP_VALUE, UNIQUE_ID from RndSuite.RndvSp
WHERE   (UNIQUE_ID  IN (@p_UniqueID))

*/

/* modification perso */ 

EXEC [RndSuite].[RndprSetConnectionForReport] @p_UserName;

--affichage parent 
select p.SP, p.SP_VALUE, p.UNIQUE_ID from RndSuite.RndvSp p
left join RndSuite.RndvSpSp spsp on p.SP = spsp.SP and p.SP_VERSION = spsp.SP_VERSION 
left join RndSuite.RndvSp c on c.SP = spsp.CHILD_SP and c.SP_VERSION in ( select CASE spsp.CHILD_SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = c.SP) else spsp.CHILD_SP_VERSION end)


where (c.UNIQUE_ID in (@p_UniqueID))

union all

--affichage enfant
select  c.SP, c.SP_VALUE, c.UNIQUE_ID  from RndSuite.RndvSp c
left join RndSuite.RndvSpSp spsp on c.SP = spsp.CHILD_SP and c.SP_VERSION in ( select CASE spsp.CHILD_SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = c.SP) else spsp.CHILD_SP_VERSION end)
left join RndSuite.RndvSp p on p.SP = spsp.SP and p.SP_VERSION = spsp.SP_VERSION

where (c.UNIQUE_ID in (@p_UniqueID));