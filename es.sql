ES enfant

select distinct 

sp.SP,

spchild.SP as SP_CHILD, spchild.DESCRIPTION as SP_CHILD_DESCRIPTION, spchild.SP_VALUE as SP_CHILD_VALUE,

spicchild.IC as SPIC_CHILD,spicchild.DSP_TITLE as SPIC_CHILD_DSP_TITLE, spicchild.IC_SHORT_DESC as SPIC_CHILD_SHORT_DESC,

spiichild.II as SPII_CHILD, spiichild.II_SHORT_DESC as SPII_CHILD_SHORT_DESC, spiichild.DSP_TITLE as SPII_CHILD_DSP_TITLE, spiichild.IIVALUE  as SPII_CHILD_IIVALUE



from RndSuite.RndtSpSp as spsp
 left join RndSuite.RndtSp as sp on sp.SP = spsp.SP
 left join RndSuite.RndtSp as spchild on spchild.SP = spsp.CHILD_SP -- Récuperation des spe enfants
 left join RndSuite.RndtSpIc as spicchild on spicchild.SP = spchild.SP and spicchild.SP_VERSION = spchild.SP_VERSION
 left join RndSuite.RndtSpIi as spiichild on spiichild.IC = spicchild.IC


--where fr.DESCRIPTION like 'ES%' and sp.SP = 84
where sp.SP = @p_sp



--------------------------------
ES parent

select distinct 

fr.DESCRIPTION as FR_DESCRIPTION,fr.CREATED_BY as FR_CREATED_BY,fr.CREATED_ON as FR_CREATED_ON,

sp.SP, sp.DESCRIPTION as SP_DESCRIPTION, sp.SP_VERSION, sp.SP_VALUE,

spic.IC as SPIC, spic.DSP_TITLE as SPIC_DSP_TITLE, spic.IC_SHORT_DESC as SPIC_SHORT_DESC,

spii.II as SPII ,spii.II_SHORT_DESC as SPII_SHORT_DESC, spii.DSP_TITLE as SPII_DSP_TITLE , spii.IIVALUE as SPII_IIVALUE


from RndSuite.RndtFr as fr
 join RndSuite.RndtSp as sp on sp.FR = fr.FR and sp.FR_VERSION = fr.FR_VERSION 
 join RndSuite.RndtSpIc as spic on spic.SP = sp.SP and  spic.SP_VERSION = sp.SP_VERSION
 join RndSuite.RndtSpIi as spii on spii.IC = spic.IC


where sp.SP = 110