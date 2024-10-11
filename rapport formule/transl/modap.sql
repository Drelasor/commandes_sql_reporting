EXEC [RndSuite].[RndprSetConnectionForReport] @p_UserName;
select 
DISTINCT
sp.SP_VALUE,sp.DESCRIPTION,sp.UNIQUE_ID,spii.SP, spii.SP_VERSION,
       spii.IC, spii.ICNODE, spic.IC_SHORT_DESC, spic.DSP_TITLE as IC_DSP_TITLE,
          spii.II, spii.IINODE, spii.II_SHORT_DESC, spii.DSP_TITLE as II_DSP_TITLE, ISNULL(spii.IIVALUE,spiilang.IIVALUE)
from RndSuite.RndvRq as form

left outer join RndSuite.RndvRqIi as formIi on formIi.RQ = form.RQ and formIi.II_SHORT_DESC = 'Incorporation'

left outer join RndSuite.RndvFmMat as mat on form.RQ = mat.RQ 
left outer join RndSuite.RndvSp as sp on sp.SP = mat.SP and sp.SP_VERSION = mat.SP_VERSION
left outer join RndSuite.RndvSpIc as spic on spic.SP = sp.SP and spic.SP_VERSION = sp.SP_VERSION
left outer join RndSuite.RndvSpIi as spii on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE and spii.IC = spic.IC	
left outer join RndSuite.RndvSpIiLang as spiilang on spiilang.SP = spii.SP and spiilang.SP_VERSION = spii.SP_VERSION and spiilang.IINODE = spii.IINODE and spiilang.IC = spii.IC and spiilang.ICNODE = spii.ICNODE and spiilang.LANG_ID = @p_Lang
WHERE form.RQ = @p_RQ  and IC_SHORT_DESC = 'Prod' and spii.II_SHORT_DESC = 'Text_rich'