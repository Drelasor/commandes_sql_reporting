EXEC [RndSuite].[RndprSetConnectionForReport] @p_UserName;
select distinct
formIi.IC, formIi.ICNODE, formIc.IC_SHORT_DESC, formIc.DSP_TITLE as IC_DSP_TITLE,
          formIi.II, formIi.IINODE, formIi.II_SHORT_DESC, formIi.DSP_TITLE as II_DSP_TITLE, formIi.DSP_TP as II_DSP_TP,ISNULL(formIi.IIVALUE,formiilang.IIVALUE),formIi.POS_X, formIi.POS_Y,
	   ppsg_row.PR, ppsg_row.SHORT_DESC as PR_SHORT_DESC, ppsg_row.ORDER_NUMBER as PR_ORDER, ppsg_row.PR_SEQ as PR_SEQ,
          e.LY_SEQ as PR_HEADER_SEQ, e.DISP_TITLE as PR_HEADER_DESC,
          e.DISP_WIDTH as PR_HEADER_WIDTH, e.COL_ALIGNMENT, e.COL_ALIGNMENT_HEADER,
          e.COL_HIDDEN, e.COL_LEN,
case 
    when formIi.DSP_TP = '@' then
                 case e.COL_TYPE
                     when 'STDPROP_VTP' then
                           case e.COL_LINK
                                  when 'ShortDescription' then cast((select SHORT_DESC from RndSuite.RndvRqIiPpsgRow myRow where ppsg_row.RQ = myRow.RQ and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Description' then cast((select DESCRIPTION from RndSuite.RndvRqIiPpsgRow myRow where ppsg_row.RQ = myRow.RQ and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Format' then cast((select FORMAT from RndSuite.RndvRqIiPpsgRow myRow where ppsg_row.RQ = myRow.RQ  and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Unit' then cast((select UNIT from RndSuite.RndvRqIiPpsgRow myRow where ppsg_row.RQ = myRow.RQ and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'ValueS' then cast((select max(ISNULL(celllang.VALUE_S,mycells.VALUE_S)) from RndSuite.RndvRqIiPpsgCell mycells 
								  left join RndSuite.RndvRqIiPpsgCellLang celllang on celllang.RQ = mycells.RQ and celllang.IC = mycells.IC and celllang.ICNODE = mycells.ICNODE and celllang.IINODE = mycells.IINODE and celllang.PR_SEQ = mycells.PR_SEQ and celllang.LANG_ID = @p_Lang
								  where ppsg_row.RQ = mycells.RQ and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                           else 
                                   cast((select VALUE from RndSuite.RndvRqIiPpsgCell mycells where ppsg_row.RQ = mycells.RQ and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                                  
                           end 
                     when 'STDPROP_UOM' then ppsg_row.UNIT
                     when 'AU_VTP' then
                           cast((select max(ISNULL(celllang.VALUE_S,mycells.VALUE_S)) from RndSuite.RndvRqIiPpsgCell mycells 
						   left join RndSuite.RndvRqIiPpsgCellLang celllang on celllang.RQ = mycells.RQ and celllang.IC = mycells.IC and celllang.ICNODE = mycells.ICNODE and celllang.IINODE = mycells.IINODE and celllang.PR_SEQ = mycells.PR_SEQ and celllang.LANG_ID = @p_Lang
						   where ppsg_row.RQ = mycells.RQ and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = concat('AU_',e.COL_LINK)) as nvarchar)
                                  
					 when 'DA_VTP' then
                           cast((select max(ISNULL(celllang.VALUE_S,mycells.VALUE_S)) from RndSuite.RndvRqIiPpsgCell mycells 
						   left join RndSuite.RndvRqIiPpsgCellLang celllang on celllang.RQ = mycells.RQ and celllang.IC = mycells.IC and celllang.ICNODE = mycells.ICNODE and celllang.IINODE = mycells.IINODE and celllang.PR_SEQ = mycells.PR_SEQ and celllang.LANG_ID = @p_Lang
						   where ppsg_row.RQ = mycells.RQ and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.LY_SEQ = e.LY_SEQ) as nvarchar)
                     else 'COL_TYPE NON RECOGNIZED !'
                 end 
          else null
          end as PR_VALUE

from RndSuite.RndvRq as form

--props formule
left join RndSuite.RndvRqIc as formIc on formIc.RQ = form.RQ
left join RndSuite.RndvRqIcLang as formIcLang on formIcLang.RQ = formIc.RQ and formIcLang.IC = formIc.IC and formIcLang.ICNODE = formIc.ICNODE  
left join RndSuite.RndvRqIi as formIi on formIi.RQ = formIc.RQ and formIi.IC = formIc.IC and formIi.ICNODE = formIc.ICNODE
left join RndSuite.RndvRqIiLang as formiilang on formiilang.RQ = formIi.RQ and formiilang.IC = formIi.IC and formiilang.ICNODE = formIi.ICNODE and formiilang.IINODE = formIi.IINODE and formiilang.II = formIi.II and formiilang.LANG_ID = @p_Lang
left join RndSuite.RndvRqIiPpsgRow as ppsg_row on ppsg_row.RQ = formIi.RQ  and ppsg_row.IC = formIi.IC and ppsg_row.ICNODE = formIi.ICNODE and ppsg_row.IINODE = formIi.IINODE
left join RndSuite.RndvRqIiPpsgCell cell on ppsg_row.RQ = cell.RQ and ppsg_row.IC = cell.IC and ppsg_row.ICNODE = cell.ICNODE and ppsg_row.IINODE = cell.IINODE and cell.PR_SEQ = ppsg_row.PR_SEQ
left join RndSuite.RndvRqIiLy spiily on formIi.RQ = spiily.RQ and formIi.ICNODE = spiily.ICNODE and formIi.IINODE = spiily.IINODE
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
   from RndSuite.RndvLyDetails
  where COL_HIDDEN <> 1) e on spiily.LY = e.LY and spiily.LY_VERSION = e.LY_VERSION


  where form.RQ = @p_RQ