select distinct 

fr.DESCRIPTION as FR_DESCRIPTION,fr.CREATED_BY as FR_CREATED_BY,fr.CREATED_ON as FR_CREATED_ON,

sp.SP, sp.DESCRIPTION as SP_DESCRIPTION, sp.SP_VERSION, sp.SP_VALUE,spchild.SP as SP_CHILD, spchild.DESCRIPTION as SP_CHILD_DESCRIPTION, spchild.SP_VALUE as SP_CHILD_VALUE,

spic.IC as SPIC, spic.DSP_TITLE as SPIC_DSP_TITLE, spic.IC_SHORT_DESC as SPIC_SHORT_DESC, spicchild.IC as SPIC_CHILD,spicchild.DSP_TITLE as SPIC_CHILD_DSP_TITLE, spicchild.IC_SHORT_DESC as SPIC_CHILD_SHORT_DESC,

spii.II as SPII ,spii.II_SHORT_DESC as SPII_SHORT_DESC, spii.DSP_TITLE as SPII_DSP_TITLE , spii.IIVALUE as SPII_IIVALUE,

spiichild.II as SPII_CHILD, spiichild.II_SHORT_DESC as SPII_CHILD_SHORT_DESC, spiichild.DSP_TITLE as SPII_CHILD_DSP_TITLE, spiichild.IIVALUE  as SPII_CHILD_IIVALUE




from RndSuite.RndtFr as fr
 left join RndSuite.RndtSp as sp on sp.FR = fr.FR and sp.FR_VERSION = fr.FR_VERSION -- relation de la trame au sp parent
 left join RndSuite.RndtSpSp as spsp  on spsp.SP = sp.SP and spsp.SP_VERSION = sp.SP_VERSION --  table relationnel parent enfant 
 left join RndSuite.RndtSp as spchild on spchild.SP = spsp.CHILD_SP -- Récuperation des spe enfants
 left join RndSuite.RndtSpIc as spic on spic.SP = sp.SP and  spic.SP_VERSION = sp.SP_VERSION
 left join RndSuite.RndtSpIc as spicchild on spicchild.SP = spchild.SP and spicchild.SP_VERSION = spchild.SP_VERSION
 left join RndSuite.RndtSpIi as spii on spii.IC = spic.IC
 left join RndSuite.RndtSpIi as spiichild on spiichild.IC = spicchild.IC




--where fr.DESCRIPTION like 'ES%' and sp.SP = 84
where sp.SP = 110  and spii.IIVALUE is not null and spiichild.IIVALUE is not null  and spii.DSP_TITLE is not null and spiichild.DSP_TITLE is not null