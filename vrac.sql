select*
fr.FR_VALUE, item.SP, item.COMPONENT_SP,frcomp.FR_VALUE
from RndSuite.RndtFr as fr
 join RndSuite.RndtSp as sp on sp.FR = fr.FR and sp.FR_VERSION = fr.FR_VERSION
 join RndSuite.RndtBomItem as item on sp.SP = item.SP
 join RndSuite.RndtSp as composp on composp.SP = item.COMPONENT_SP
 join RndSuite.RndtFr as frcomp on frcomp.FR = composp.FR and frcomp.FR_VERSION = composp.FR_VERSION


