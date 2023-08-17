select distinct 

fr.DESCRIPTION as FR_DESCRIPTION,fr.CREATED_BY as FR_CREATED_BY,fr.CREATED_ON as FR_CREATED_ON,

sp.DESCRIPTION as SP_DESCRIPTION, spchild.DESCRIPTION as SP_CHILD_DESCRIPTION,

spic.IC, spic.IC_SHORT_DESC, spicchild.IC as SPIC_CHILD_IC, spicchild.IC_SHORT_DESC as SPIC_CHILD_IC_SHORT_DESC,

spii.II ,spii.II_SHORT_DESC ,spii.DSP_TITLE , spii.IIVALUE,

spiichild.II as SPII_CHILD_II, spiichild.II_SHORT_DESC as SPII_CHILD_II_SHORT_DESC, spiichild.DSP_TITLE as SPII_CHILD_DSP_TITLE, spiichild.IIVALUE  as SPII_CHILD_IIVALUE


from RndSuite.RndtFr as fr
join RndSuite.RndtSp as sp on sp.FR = fr.FR and sp.FR_VERSION = fr.FR_VERSION -- relation de la trame au sp parent
join RndSuite.RndtSpSp as spsp  on spsp.SP = sp.SP and spsp.SP_VERSION = sp.SP_VERSION --  table relationnel parent enfant 
join RndSuite.RndtSp as spchild on spchild.SP = spsp.CHILD_SP -- Récuperation des spe enfants
join RndSuite.RndtSpIc as spic on spic.SP = sp.SP and  spic.SP_VERSION = sp.SP_VERSION
join RndSuite.RndtSpIc as spicchild on spicchild.SP = spchild.SP and spicchild.SP_VERSION = spchild.SP_VERSION
join RndSuite.RndtSpIi as spii on spii.IC = spic.IC
join RndSuite.RndtSpIi as spiichild on spiichild.IC = spicchild.IC




where fr.DESCRIPTION like 'ES%' and sp.SP = 173


