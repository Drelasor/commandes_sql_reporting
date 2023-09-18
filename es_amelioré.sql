générique

select distinct 

sp.SP, 

spchild.SP as SP_CHILD, spchild.DESCRIPTION as SP_CHILD_DESCRIPTION, spchild.SP_VALUE as SP_CHILD_VALUE,

spicchild.IC as SPIC_CHILD,spicchild.DSP_TITLE as SPIC_CHILD_DSP_TITLE, spicchild.IC_SHORT_DESC as SPIC_CHILD_SHORT_DESC,

spiichild.II as SPII_CHILD, spiichild.II_SHORT_DESC as SPII_CHILD_SHORT_DESC, spiichild.DSP_TITLE as SPII_CHILD_DSP_TITLE, spiichild.IIVALUE  as SPII_CHILD_IIVALUE



from RndSuite.RndtSpSp as spsp
 inner join RndSuite.RndtSp as sp on sp.SP = spsp.SP 
 inner join RndSuite.RndtSp as spchild on spchild.SP = spsp.CHILD_SP and spchild.SP_VERSION in (
    select CASE spsp.CHILD_SP_VERSION when -1 then 
        (select TOP 1 first_value(x.SP_VERSION)
        over(order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = sp.SP)
else spsp.SP_VERSION end) 

 inner join RndSuite.RndtSpIc as spicchild on spicchild.SP = spchild.SP and spicchild.SP_VERSION = spchild.SP_VERSION
 inner join RndSuite.RndtSpIi as spiichild on spiichild.IC = spicchild.IC and spiichild.SP = spicchild.SP and spiichild.ICNODE = spicchild.ICNODE and spiichild.SP_VERSION = spicchild.SP_VERSION

where sp.SP_VALUE = 'SP20230522-7'