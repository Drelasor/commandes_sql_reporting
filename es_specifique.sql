select distinct

sp.SP, sp.SP_VALUE, sp.SP_VERSION, spic.IC_SHORT_DESC, spii.DSP_TITLE, spsp.SP as SPSP_SP, spsp.CHILD_SP, spchild.SP as SPCHILD,  spchild.SP_VALUE as SPCHILD_VALUE, spchild.SP_VERSION as SPCHILD, spicchild.IC_SHORT_DESC, spiichild.DSP_TITLE

from RndSuite.RndtSp as sp
left join RndSuite.RndtSpIc as spic on sp.SP = spic.SP and sp.SP_VERSION = spic.SP_VERSION
left join RndSuite.RndtSpIi as spii on spii.IC = spic.IC
left join RndSuite.RndtSpSp as spsp on spsp.SP = sp.SP
left join RndSuite.RndtSp as spchild on spchild.SP = spsp.CHILD_SP
left join RndSuite.RndtSpIc as spicchild on spchild.SP = spicchild.SP and spchild.SP_VERSION = spicchild.SP_VERSION
left join RndSuite.RndtSpIi as spiichild on spiichild.IC = spicchild.IC


where sp.SP = 110 and spchild.SP = 106
