select 
DISTINCT
mat.LEVEL,sp.SP_VALUE,sp.DESCRIPTION,sp.UNIQUE_ID,spii.SP, spii.SP_VERSION,
       spii.IC, spii.ICNODE, spic.IC_SHORT_DESC, spic.DSP_TITLE as IC_DSP_TITLE,
          spii.II, spii.IINODE, spii.II_SHORT_DESC, spii.DSP_TITLE as II_DSP_TITLE,spii.IIVALUE
from RndSuite.RndtRq as form

left outer join RndSuite.RndtRqIi as formIi on formIi.RQ = form.RQ and formIi.II_SHORT_DESC = 'Incorporation'

left outer join RndSuite.RndtFmMat as mat on form.RQ = mat.RQ 
left outer join RndSuite.RndtSp as sp on sp.SP = mat.SP and sp.SP_VERSION = mat.SP_VERSION
left outer join RndSuite.RndtSpIc as spic on spic.SP = sp.SP and spic.SP_VERSION = sp.SP_VERSION
left outer join RndSuite.RndtSpIi as spii on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE and spii.IC = spic.IC	
WHERE form.RQ = 543 and IC_SHORT_DESC = 'Prod'