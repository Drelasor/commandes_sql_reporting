// spécifique
select distinct
spicchild.SP_VALUE, spicchild.IC_SHORT_DESC,spiichild.DSP_TITLE ,spiichild.IIVALUE
 
 from  RndSuite.RndtSpSp as spsp
 join RndSuite.RndtSpIc as spicchild on spicchild.SP = spsp.CHILD_SP
 join RndSuite.RndtSpIi as spiichild on spiichild.IC = spicchild.IC and spiichild.SP = spicchild.SP



where spicchild.SP_VALUE = 'SP20230522-3'
-----

// générique
select distinct
spic.SP_VALUE, spic.IC_SHORT_DESC,spii.DSP_TITLE,spii.IIVALUE


from  RndSuite.RndtSpSp as spsp
 join RndSuite.RndtSpIc as spicchild on spicchild.SP = spsp.CHILD_SP
 join RndSuite.RndtSpIc as spic on spic.SP = spsp.SP
 join RndSuite.RndtSpIi as spii on spii.IC = spic.IC and spii.SP = spic.SP



where spicchild.SP_VALUE = 'SP20230522-3'