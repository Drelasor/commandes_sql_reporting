EXEC [RndSuite].[RndprSetConnectionForReport] @p_UserName;

select 
DISTINCT 
fr.FR_VALUE, spii.SP, spii.SP_VERSION,
       spii.IC, spii.ICNODE, spic.IC_SHORT_DESC , spic.DSP_TITLE as IC_DSP_TITLE,
          spii.II, spii.IINODE, spii.II_SHORT_DESC, spii.DSP_TITLE as II_DSP_TITLE, spii.DSP_TP as II_DSP_TP, 
                   spii.POS_X, spii.POS_Y,
          case spii.DSP_TP
              when 'F' then spii.DSP_TITLE
              else spii.SPECINFOFIELDVALUE
          end as IIVALUE,
          ppsg_row.PR, ppsg_row.SHORT_DESC as PR_SHORT_DESC, ppsg_row.ORDER_NUMBER as PR_ORDER, ppsg_row.PR_SEQ as PR_SEQ,
          e.LY_SEQ as PR_HEADER_SEQ, e.DISP_TITLE as PR_HEADER_DESC,
          e.DISP_WIDTH as PR_HEADER_WIDTH, e.COL_ALIGNMENT, e.COL_ALIGNMENT_HEADER,
          e.COL_HIDDEN, e.COL_LEN,
          case when spii.DSP_TP = '@' then
                 case e.COL_TYPE
                     when 'STDPROP_VTP' then
                           case e.COL_LINK
                                  when 'ShortDescription' then cast((select SHORT_DESC from RndSuite.RndvRepSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Description' then cast((select DESCRIPTION from RndSuite.RndvRepSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Format' then cast((select FORMAT from RndSuite.RndvRepSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Unit' then cast((select UNIT from RndSuite.RndvRepSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'ValueS' then cast((select VALUE_S from RndSuite.RndvRepSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                           else 
                                   cast((select VALUE from RndSuite.RndvRepSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                                  
                           end 
                     when 'STDPROP_UOM' then ppsg_row.UNIT
                     when 'AU_VTP' then
                           cast((select VALUE_S from RndSuite.RndvRepSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = concat('AU_',e.COL_LINK)) as nvarchar)
                                  
					 when 'DA_VTP' then
                           cast((select VALUE_S from RndSuite.RndvRepSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.LY_SEQ = e.LY_SEQ) as nvarchar)
                     else 'COL_TYPE NON RECOGNIZED !'
                 end 
          else null
          end as PR_VALUE,
          comp.CP, comp.DESCRIPTION as CP_DESC, comp.SHORT_DESC as CP_SHORT_DESC, comp.ORDER_NUMBER as CP_ORDER,
          comp.QUANTITY,
          f.DESCRIPTION as ATTACH_DESC,
          f.TOOLTIP as ATTACH_MIME
  from RndSuite.RndvRepSpIi spii inner join RndSuite.RndvSp spP on spii.SP= spP.SP and spii.SP_VERSION = spP.SP_VERSION
  left outer join RndSuite.RndvFr fr on spP.FR = fr.FR and spP.FR_VERSION = fr.FR_VERSION
  left outer join RndSuite.RndvSpSp spsp on spP.SP = spsp.SP and spP.SP_VERSION = spsp.SP_VERSION 
  left outer join RndSuite.RndvSp spC  on spC.SP = spsp.CHILD_SP and spC.SP_VERSION in ( select CASE spsp.CHILD_SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = spC.SP) else spsp.CHILD_SP_VERSION end)
  left outer join RndSuite.RndvRepSpIc spic on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE
  left outer join RndSuite.RndvRepSpIiPpsgRow ppsg_row on spii.SP = ppsg_row.SP and spii.SP_VERSION = ppsg_row.SP_VERSION and spii.IC = ppsg_row.IC and spii.ICNODE = ppsg_row.ICNODE and spii.IINODE = ppsg_row.IINODE
  left outer join RndSuite.RndvRepSpIiPpsgCell cell on ppsg_row.SP = cell.SP and ppsg_row.SP_VERSION = ppsg_row.SP_VERSION and ppsg_row.IC = cell.IC and ppsg_row.ICNODE = cell.ICNODE and ppsg_row.IINODE = cell.IINODE and cell.PR_SEQ = ppsg_row.PR_SEQ
  left outer join RndSuite.RndvRepSpIiComp comp on spii.SP = comp.SP and spii.SP_VERSION = comp.SP_VERSION and spii.IC = comp.IC and spii.ICNODE = comp.ICNODE and spii.IINODE = comp.IINODE
  left outer join RndSuite.RndvSpIiLy spiily on spii.SP = spiily.SP and spii.SP_VERSION = spiily.SP_VERSION and spii.ICNODE = spiily.ICNODE and spii.IINODE = spiily.IINODE
  left outer join (select LY, VERSION as LY_VERSION, SEQ as LY_SEQ, COL_ID, 
        ltrim(rtrim(substring(COL_TP,1,charindex('@',COL_TP,1)-1))) as COL_TYPE,
              ltrim(rtrim(substring(COL_TP,charindex('@',COL_TP,1)+1,1000))) as COL_LINK,
              DISP_TITLE,
              DISP_WIDTH,
              COL_HIDDEN,
              COL_LEN,
              COL_ALIGNMENT,
              COL_ALIGNMENT_HEADER,
              COUNT(SEQ) over (partition by LY, VERSION) as COL_NUMBER
   from RndSuite.RndvLyDetails
  where COL_HIDDEN <> 1) e on spiily.LY = e.LY and spiily.LY_VERSION = e.LY_VERSION
  left outer join RndSuite.RndvRepDc f on ltrim(rtrim(spii.SPECINFOFIELDVALUE)) = FORMAT(f.DC,'0')+'#'+FORMAT(f.VERSION,'0')

where spC.UNIQUE_ID = @p_UniqueID 

union all

select 
DISTINCT 
fr.FR_VALUE, spii.SP, spii.SP_VERSION,
       spii.IC, spii.ICNODE, spic.IC_SHORT_DESC , spic.DSP_TITLE as IC_DSP_TITLE,
          spii.II, spii.IINODE, spii.II_SHORT_DESC, spii.DSP_TITLE as II_DSP_TITLE, spii.DSP_TP as II_DSP_TP, 
                   spii.POS_X, spii.POS_Y,
          case spii.DSP_TP
              when 'F' then spii.DSP_TITLE
              else spii.SPECINFOFIELDVALUE
          end as IIVALUE,
          ppsg_row.PR, ppsg_row.SHORT_DESC as PR_SHORT_DESC, ppsg_row.ORDER_NUMBER as PR_ORDER, ppsg_row.PR_SEQ as PR_SEQ,
          e.LY_SEQ as PR_HEADER_SEQ, e.DISP_TITLE as PR_HEADER_DESC,
          e.DISP_WIDTH as PR_HEADER_WIDTH, e.COL_ALIGNMENT, e.COL_ALIGNMENT_HEADER,
          e.COL_HIDDEN, e.COL_LEN,
          case when spii.DSP_TP = '@' then
                 case e.COL_TYPE
                     when 'STDPROP_VTP' then
                           case e.COL_LINK
                                  when 'ShortDescription' then cast((select SHORT_DESC from RndSuite.RndvRepSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Description' then cast((select DESCRIPTION from RndSuite.RndvRepSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Format' then cast((select FORMAT from RndSuite.RndvRepSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Unit' then cast((select UNIT from RndSuite.RndvRepSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'ValueS' then cast((select VALUE_S from RndSuite.RndvRepSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                           else 
                                   cast((select VALUE from RndSuite.RndvRepSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                                  
                           end 
                     when 'STDPROP_UOM' then ppsg_row.UNIT
                     when 'AU_VTP' then
                           cast((select VALUE_S from RndSuite.RndvRepSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = concat('AU_',e.COL_LINK)) as nvarchar)
                                  
					 when 'DA_VTP' then
                           cast((select VALUE_S from RndSuite.RndvRepSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.LY_SEQ = e.LY_SEQ) as nvarchar)
                     else 'COL_TYPE NON RECOGNIZED !'
                 end 
          else null
          end as PR_VALUE,
          comp.CP, comp.DESCRIPTION as CP_DESC, comp.SHORT_DESC as CP_SHORT_DESC, comp.ORDER_NUMBER as CP_ORDER,
          comp.QUANTITY,
          f.DESCRIPTION as ATTACH_DESC,
          f.TOOLTIP as ATTACH_MIME
  from RndSuite.RndvRepSpIi spii inner join RndSuite.RndvSp spC on spii.SP= spC.SP and spii.SP_VERSION = spC.SP_VERSION
  left outer join RndSuite.RndvFr fr on spC.FR = fr.FR and spC.FR_VERSION = fr.FR_VERSION
  left outer join RndSuite.RndvSpSp spsp on spC.SP = spsp.CHILD_SP and spC.SP_VERSION in ( select CASE spsp.CHILD_SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = spC.SP) else spsp.CHILD_SP_VERSION end)
  left outer join RndSuite.RndvSp spP  on spP.SP = spsp.SP and spP.SP_VERSION = spsp.SP_VERSION
  left outer join RndSuite.RndvRepSpIc spic on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE
  left outer join RndSuite.RndvRepSpIiPpsgRow ppsg_row on spii.SP = ppsg_row.SP and spii.SP_VERSION = ppsg_row.SP_VERSION and spii.IC = ppsg_row.IC and spii.ICNODE = ppsg_row.ICNODE and spii.IINODE = ppsg_row.IINODE
  left outer join RndSuite.RndvRepSpIiPpsgCell cell on ppsg_row.SP = cell.SP and ppsg_row.SP_VERSION = ppsg_row.SP_VERSION and ppsg_row.IC = cell.IC and ppsg_row.ICNODE = cell.ICNODE and ppsg_row.IINODE = cell.IINODE and cell.PR_SEQ = ppsg_row.PR_SEQ
  left outer join RndSuite.RndvRepSpIiComp comp on spii.SP = comp.SP and spii.SP_VERSION = comp.SP_VERSION and spii.IC = comp.IC and spii.ICNODE = comp.ICNODE and spii.IINODE = comp.IINODE
  left outer join RndSuite.RndvSpIiLy spiily on spii.SP = spiily.SP and spii.SP_VERSION = spiily.SP_VERSION and spii.ICNODE = spiily.ICNODE and spii.IINODE = spiily.IINODE
  left outer join (select LY, VERSION as LY_VERSION, SEQ as LY_SEQ, COL_ID, 
        ltrim(rtrim(substring(COL_TP,1,charindex('@',COL_TP,1)-1))) as COL_TYPE,
              ltrim(rtrim(substring(COL_TP,charindex('@',COL_TP,1)+1,1000))) as COL_LINK,
              DISP_TITLE,
              DISP_WIDTH,
              COL_HIDDEN,
              COL_LEN,
              COL_ALIGNMENT,
              COL_ALIGNMENT_HEADER,
              COUNT(SEQ) over (partition by LY, VERSION) as COL_NUMBER
   from RndSuite.RndvLyDetails
  where COL_HIDDEN <> 1) e on spiily.LY = e.LY and spiily.LY_VERSION = e.LY_VERSION
  left outer join RndSuite.RndvRepDc f on ltrim(rtrim(spii.SPECINFOFIELDVALUE)) = FORMAT(f.DC,'0')+'#'+FORMAT(f.VERSION,'0')

where spC.UNIQUE_ID = @p_UniqueID