select sp.SP, sp.SP_VALUE,sp.SP_VERSION, sp.CONTEXT ,sssp.NAME as statut_spec , ssic.NAME as statut_ic, ssii.NAME as statut_ii , ii.IIVALUE, ii.II_SHORT_DESC

from RndSuite.RndtSp sp

left join RndSuite.RndtSpIc ic on ic.SP = sp.SP and ic.SP_VERSION = sp.SP_VERSION
left join RndSuite.RndtSpIi ii on ii.SP = ic.SP and ii.SP_VERSION = ic.SP_VERSION and ii.IC = ic.IC
left join RndSuite.RndtSs ssii on ssii.SS = ii.SS
left join RndSuite.RndtSs ssic on ssic.SS  = ic.SS
left join RndSuite.RndtSs sssp on sssp.SS = sp.SS


where ii.IIVALUE = '568162'
order by sp.SP_VERSION desc