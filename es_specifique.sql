select distinct
spic.SP_VALUE, spic.IC_SHORT_DESC,spii.DSP_TITLE ,spii.IIVALUE

from  RndSuite.RndtSpSp as spsp

left join RndSuite.RndtSpIc as spic on spic.SP = spsp.CHILD_SP 
left join RndSuite.RndtSpIi as spii on spii.IC = spic.IC and spii.SP = spic.SP

where spsp.CHILD_SP = 106

-----

select distinct
spic.SP_VALUE, spic.IC_SHORT_DESC,spii.DSP_TITLE ,spii.IIVALUE

from  RndSuite.RndtSpSp as spsp

left join RndSuite.RndtSpIc as spic on spic.SP = spsp.SP
left join RndSuite.RndtSpIi as spii on spii.IC = spic.IC and spii.SP = spic.SP

where spsp.CHILD_SP = 106