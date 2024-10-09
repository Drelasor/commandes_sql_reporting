-- Autorisation pays
select 
DISTINCT
formIi.IIVALUE as incorporation,sp.SP_VALUE,sp.UNIQUE_ID,spii.SP, spii.SP_VERSION,
       spii.IC, spii.ICNODE, spic.IC_SHORT_DESC, spic.DSP_TITLE as IC_DSP_TITLE,
          spii.II, spii.IINODE, spii.II_SHORT_DESC, spii.DSP_TITLE as II_DSP_TITLE, spii.DSP_TP as II_DSP_TP, 
                   spii.POS_X, spii.POS_Y,
				   ppsg_row.PR, ppsg_row.SHORT_DESC as PR_SHORT_DESC, ppsg_row.ORDER_NUMBER as PR_ORDER, ppsg_row.PR_SEQ as PR_SEQ,
          e.LY_SEQ as PR_HEADER_SEQ, e.DISP_TITLE as PR_HEADER_DESC,
          e.DISP_WIDTH as PR_HEADER_WIDTH, e.COL_ALIGNMENT, e.COL_ALIGNMENT_HEADER, 

		cast((select max(ISNULL(rowlang.DESCRIPTION,myRow.DESCRIPTION)) from RndSuite.RndtSpIiPpsgRow myRow 
		left join RndSuite.RndtPrLang rowlang on rowlang.PR = myRow.PR and rowlang.LANG_ID = 4
		where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar) as TITLE,

          case when spii.DSP_TP = '@' then
                 case e.COL_TYPE
                     when 'STDPROP_VTP' then
                           case e.COL_LINK
                                  when 'ShortDescription' then cast((select SHORT_DESC from RndSuite.RndtSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Description' then cast((select DESCRIPTION from RndSuite.RndtSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Format' then cast((select FORMAT from RndSuite.RndtSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Unit' then cast((select UNIT from RndSuite.RndtSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'ValueS' then cast((select max(ISNULL(celllang.VALUE_S,mycells.VALUE_S))  from RndSuite.RndtSpIiPpsgCell mycells
								  left join RndSuite.RndtSpIiPpsgCellLang celllang on celllang.SP = mycells.SP and celllang.SP_VERSION = mycells.SP_VERSION and celllang.IC = mycells.IC and celllang.ICNODE = mycells.ICNODE and celllang.IINODE = mycells.IINODE and celllang.PR_SEQ = mycells.PR_SEQ and LANG_ID = 4
								   where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                           else 
                                   cast((select VALUE from RndSuite.RndtSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                                  
                           end 
                     when 'STDPROP_UOM' then ppsg_row.UNIT
                     when 'AU_VTP' then
                           cast((select max(ISNULL(celllang.VALUE_S,mycells.VALUE_S))  from RndSuite.RndtSpIiPpsgCell mycells
						   left join RndSuite.RndtSpIiPpsgCellLang celllang on celllang.SP = mycells.SP and celllang.SP_VERSION = mycells.SP_VERSION and celllang.IC = mycells.IC and celllang.ICNODE = mycells.ICNODE and celllang.IINODE = mycells.IINODE and celllang.PR_SEQ = mycells.PR_SEQ and celllang.LANG_ID = 4
						   where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = concat('AU_',e.COL_LINK)) as nvarchar)
                                  
					 when 'DA_VTP' then
                           cast((select max(ISNULL(celllang.VALUE_S,mycells.VALUE_S))  from RndSuite.RndtSpIiPpsgCell mycells
						   left join RndSuite.RndtSpIiPpsgCellLang celllang on celllang.SP = mycells.SP and celllang.SP_VERSION = mycells.SP_VERSION and celllang.IC = mycells.IC and celllang.ICNODE = mycells.ICNODE and celllang.IINODE = mycells.IINODE and celllang.PR_SEQ = mycells.PR_SEQ and LANG_ID = 4
						   where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.LY_SEQ = e.LY_SEQ) as nvarchar)
                     else 'COL_TYPE NON RECOGNIZED !'
                 end 
          else null
          end as PR_VALUE, 
		  comp.CP, comp.DESCRIPTION as CP_DESC, comp.SHORT_DESC as CP_SHORT_DESC,  mat.QUANTITY,matp1.QUANTITY as quantity_parent1, matp2.QUANTITY as quantity_parent2, matp3.QUANTITY as quantity_parent3,	

		
CASE
    WHEN matp1.QUANTITY IS NOT NULL THEN 
        CASE
            WHEN matp2.QUANTITY IS NOT NULL THEN 
                CASE
                    WHEN matp3.QUANTITY IS NOT NULL THEN 
                        (((mat.QUANTITY * matp1.QUANTITY) / 1000) * matp2.QUANTITY / 1000) * matp3.QUANTITY / 1000
                    ELSE 
                        ((mat.QUANTITY * matp1.QUANTITY) / 1000) * matp2.QUANTITY / 1000 * 1
                END
            ELSE 
                (mat.QUANTITY * matp1.QUANTITY) / 1000 * 1
        END
    ELSE 
        mat.QUANTITY * 1
END AS final_result,
final_results.sum_final_result
	
		  
from RndSuite.RndtRq as form



left outer join RndSuite.RndtRqIc as formIc on formIc.RQ = form.RQ  and formIc.IC_SHORT_DESC = 'Formula Setting' 
left outer join RndSuite.RndtRqIi as formIi on formIi.RQ = formIc.RQ and formIi.IC = formIc.IC and formIi.ICNODE = formIc.ICNODE and formIi.II_SHORT_DESC = 'Incorporation'

left outer join RndSuite.RndtFmMat as mat on form.RQ = mat.RQ 
left outer join RndSuite.RndtSp as sp on sp.SP = mat.SP and sp.SP_VERSION = mat.SP_VERSION 
left outer join RndSuite.RndtFmMat as matp1 on mat.PARENT = matp1.UNIQUE_ID
left outer join RndSuite.RndtFmMat as matp2 on matp1.PARENT = matp2.UNIQUE_ID
left outer join RndSuite.RndtFmMat as matp3 on matp2.PARENT = matp3.UNIQUE_ID
left outer join RndSuite.RndtSpIc as spic on spic.SP = sp.SP and spic.SP_VERSION = sp.SP_VERSION
left outer join RndSuite.RndtSpIi as spii on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE and spii.IC = spic.IC
left outer join RndSuite.RndtSpIiPpsgRow as ppsg_row on ppsg_row.SP = spii.SP and ppsg_row.SP_VERSION = spii.SP_VERSION and ppsg_row.IC = spii.IC and ppsg_row.ICNODE = spii.ICNODE and ppsg_row.IINODE = spii.IINODE
left outer join RndSuite.RndtSpIiPpsgCell cell on ppsg_row.SP = cell.SP and ppsg_row.SP_VERSION = cell.SP_VERSION and ppsg_row.IC = cell.IC and ppsg_row.ICNODE = cell.ICNODE and ppsg_row.IINODE = cell.IINODE and cell.PR_SEQ = ppsg_row.PR_SEQ 
left outer join RndSuite.RndtSpIiComp comp on spii.SP = comp.SP and spii.SP_VERSION = comp.SP_VERSION and spii.IC = comp.IC and spii.ICNODE = comp.ICNODE and spii.IINODE = comp.IINODE
left outer join RndSuite.RndtSpIiCompLang complang on complang.UNIQUE_ID = comp.UNIQUE_ID
left outer join RndSuite.RndtSpIiLy spiily on spii.SP = spiily.SP and spii.SP_VERSION = spiily.SP_VERSION and spii.ICNODE = spiily.ICNODE and spii.IINODE = spiily.IINODE
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
   from RndSuite.RndtLyDetails
  where COL_HIDDEN <> 1) e on spiily.LY = e.LY and spiily.LY_VERSION = e.LY_VERSION
  LEFT JOIN (
    SELECT 
        SP,
        SUM(final_result) AS sum_final_result
    FROM (
        SELECT 
            DISTINCT mat.SP,
            CASE
                WHEN matp1.QUANTITY IS NOT NULL THEN 
                    CASE
                        WHEN matp2.QUANTITY IS NOT NULL THEN 
                            CASE
                                WHEN matp3.QUANTITY IS NOT NULL THEN 
                                    (((mat.QUANTITY * matp1.QUANTITY) / 1000) * matp2.QUANTITY / 1000) * matp3.QUANTITY / 1000
                                ELSE 
                                    ((mat.QUANTITY * matp1.QUANTITY) / 1000) * matp2.QUANTITY / 1000 * 1
                            END
                        ELSE 
                            (mat.QUANTITY * matp1.QUANTITY) / 1000 * 1
                    END
                ELSE 
                    mat.QUANTITY * 1
            END AS final_result
        FROM RndSuite.RndtRq AS form
        LEFT OUTER JOIN RndSuite.RndtRqIi AS formIi ON formIi.RQ = form.RQ AND formIi.II_SHORT_DESC = 'Incorporation'
        LEFT OUTER JOIN RndSuite.RndtFmMat AS mat ON form.RQ = mat.RQ 
        LEFT OUTER JOIN RndSuite.RndtFmMat AS matp1 ON mat.PARENT = matp1.UNIQUE_ID
        LEFT OUTER JOIN RndSuite.RndtFmMat AS matp2 ON matp1.PARENT = matp2.UNIQUE_ID
        LEFT OUTER JOIN RndSuite.RndtFmMat AS matp3 ON matp2.PARENT = matp3.UNIQUE_ID
        WHERE form.RQ = 543
    ) AS subquery
    GROUP BY SP
) AS final_results ON sp.SP = final_results.SP


WHERE form.RQ = 543

