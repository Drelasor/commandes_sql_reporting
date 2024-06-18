select distinct
decii.IC, decii.ICNODE, decic.IC_SHORT_DESC, decic.DSP_TITLE as IC_DSP_TITLE,
          decii.II, decii.IINODE, decii.II_SHORT_DESC, decii.DSP_TITLE as II_DSP_TITLE, decii.DSP_TP as II_DSP_TP, decii.POS_X, decii.POS_Y,
	   ppsg_row.PR, ppsg_row.SHORT_DESC as PR_SHORT_DESC, ppsg_row.ORDER_NUMBER as PR_ORDER, ppsg_row.PR_SEQ as PR_SEQ,
          e.LY_SEQ as PR_HEADER_SEQ, e.DISP_TITLE as PR_HEADER_DESC,
          e.DISP_WIDTH as PR_HEADER_WIDTH, e.COL_ALIGNMENT, e.COL_ALIGNMENT_HEADER,
          e.COL_HIDDEN, e.COL_LEN,
case 
    when decii.DSP_TP = '@' then
                 case e.COL_TYPE
                     when 'STDPROP_VTP' then
                           case e.COL_LINK
                                  when 'ShortDescription' then cast((select SHORT_DESC from RndSuite.RndtRqIiPpsgRow myRow where ppsg_row.RQ = myRow.RQ and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Description' then cast((select DESCRIPTION from RndSuite.RndtRqIiPpsgRow myRow where ppsg_row.RQ = myRow.RQ and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Format' then cast((select FORMAT from RndSuite.RndtRqIiPpsgRow myRow where ppsg_row.RQ = myRow.RQ  and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Unit' then cast((select UNIT from RndSuite.RndtRqIiPpsgRow myRow where ppsg_row.RQ = myRow.RQ and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'ValueS' then cast((select VALUE_S from RndSuite.RndtRqIiPpsgCell mycells where ppsg_row.RQ = mycells.RQ and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                           else 
                                   cast((select VALUE from RndSuite.RndtRqIiPpsgCell mycells where ppsg_row.RQ = mycells.RQ and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                                  
                           end 
                     when 'STDPROP_UOM' then ppsg_row.UNIT
                     when 'AU_VTP' then
                           cast((select VALUE_S from RndSuite.RndtRqIiPpsgCell mycells where ppsg_row.RQ = mycells.RQ and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = concat('AU_',e.COL_LINK)) as nvarchar)
                                  
					 when 'DA_VTP' then
                           cast((select VALUE_S from RndSuite.RndtRqIiPpsgCell mycells where ppsg_row.RQ = mycells.RQ and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.LY_SEQ = e.LY_SEQ) as nvarchar)
                     else 'COL_TYPE NON RECOGNIZED !'
                 end 
          else null
          end as PR_VALUE

from RndSuite.RndtRq as form

--props formule
left join RndSuite.RndtRqRq as rqrq on form.RQ = rqrq.RQ
left join RndSuite.RndtRq as dec on dec.RQ = rqrq.RQ_CHILD
left join RndSuite.RndtRqIc as decic on decic.RQ = dec.RQ
left join RndSuite.RndtRqIi as decii on decii.RQ = decic.RQ and decii.IC = decic.IC and decii.ICNODE = decic.ICNODE
left join RndSuite.RndtRqIiPpsgRow as ppsg_row on ppsg_row.RQ = decii.RQ  and ppsg_row.IC = decii.IC and ppsg_row.ICNODE = decii.ICNODE and ppsg_row.IINODE = decii.IINODE
left join RndSuite.RndtRqIiPpsgCell cell on ppsg_row.RQ = cell.RQ and ppsg_row.IC = cell.IC and ppsg_row.ICNODE = cell.ICNODE and ppsg_row.IINODE = cell.IINODE and cell.PR_SEQ = ppsg_row.PR_SEQ
left join RndSuite.RndtRqIiLy spiily on decii.RQ = spiily.RQ and decii.ICNODE = spiily.ICNODE and decii.IINODE = spiily.IINODE
left join (select LY, VERSION as LY_VERSION, SEQ as LY_SEQ, COL_ID, 
        ltrim(rtrim(substring(COL_TP,1,charindex('@',COL_TP,1)-1))) as COL_TYPE,
              ltrim(rtrim(substring(COL_TP,charindex('@',COL_TP,1)+1,1000))) as COL_LINK, 
              DISP_TITLE, 
              DISP_WIDTH,
              COL_HIDDEN,
              COL_LEN,
              COL_ALIGNMENT,
              COL_ALIGNMENT_HEADER,
              COUNT(SEQ) over (partition by LY, VERSION) as COL_NUMBER
   from RndSuite.RndtLyDetails
  where COL_HIDDEN <> 1) e on spiily.LY = e.LY and spiily.LY_VERSION = e.LY_VERSION


  where form.RQ_VALUE = 'FM20240528-6'

