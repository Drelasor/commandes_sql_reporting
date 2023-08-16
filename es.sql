select
fr.FR as FR_FR,fr.FR_VERSION,fr.DESCRIPTION as FR_DESCRIPTION,fr.CREATED_BY as FR_CREATED_BY,fr.CREATED_ON as FR_CREATED_ON,

sp.SP, sp.SP_VERSION, sp.FR, sp.FR_VERSION,

spchild.SP as SP_CHILD_SP,  spchild.SP_VERSION as SP_CHILD_SP_VERSION,

spsp.SP as SPSP_SP,spsp.SP_VERSION as SPSP_SP_VERSION,spsp.CHILD_SP as SPSP_CHILD_SP, spsp.CHILD_SP_VERSION as SPSP_CHILD_SP_VERSION,

ic.SP as IC_SP, ic.SP_VERSION as IC_SP_VERSION,

icspchild.SP as IC_SP_CHILD , icspchild.SP_VERSION as IC_SP_CHILD_VERSION,

ii.II , ii.II_SHORT_DESC ,ii.DSP_TITLE , ii.IIVALUE,

iichild.II as IICHILD_II, iichild.II_SHORT_DESC as IICHILD_II_SHORT_DESC, iichild.DSP_TITLE as IICHILD_II_DSP_TITLE, iichild.IIVALUE as IICHILD_IVALUE



from RndSuite.RndtFr as fr
join RndSuite.RndtSp as sp on sp.FR = fr.FR and sp.FR_VERSION = fr.FR_VERSION
join RndSuite.RndtSpSp as spsp  on spsp.SP = sp.SP and spsp.SP_VERSION = sp.SP_VERSION
join RndSuite.RndtSp as spchild on spchild.SP = spsp.CHILD_SP and spchild.SP_VERSION = sp.SP_VERSION
join RndSuite.RndtSpIc as ic on ic.SP = sp.SP and  ic.SP_VERSION = sp.SP_VERSION
join RndSuite.RndtSpIc as icspchild on icspchild.SP = spchild.SP and icspchild.SP_VERSION = spchild.SP_VERSION
join RndSuite.RndtSpIi as ii on ii.IC = ic.IC 
join RndSuite.RndtSpIi as iichild on iichild.IC = icspchild.IC 
where fr.DESCRIPTION like 'ES%' and sp.SP = 173
