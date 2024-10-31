EXEC [RndSuite].[RndprSetConnectionForReport] @p_UserName;
select 
DISTINCT 
client.DESCRIPTION,
          ppsg_rowmat.PR,ppsg_rowmat.ORDER_NUMBER as PR_ORDER, ppsg_rowmat.PR_SEQ as PR_SEQ,
          e.LY_SEQ as PR_HEADER_SEQ, e.DISP_TITLE as PR_HEADER_DESC,
		 cellcli.VALUE_S as client,
																		 	  
          case when spiimat.DSP_TP = '@' then
                 case e.COL_TYPE
                     when 'STDPROP_VTP' then
                           case e.COL_LINK
                                  when 'ShortDescription' then cast((select SHORT_DESC from RndSuite.RndvSpIiPpsgRow myRow where ppsg_rowmat.SP = myRow.SP and ppsg_rowmat.SP_VERSION = myRow.SP_VERSION and ppsg_rowmat.IC = myRow.IC and ppsg_rowmat.ICNODE = myRow.ICNODE and ppsg_rowmat.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_rowmat.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Description' then cast((select DESCRIPTION from RndSuite.RndvSpIiPpsgRow myRow where ppsg_rowmat.SP = myRow.SP and ppsg_rowmat.SP_VERSION = myRow.SP_VERSION and ppsg_rowmat.IC = myRow.IC and ppsg_rowmat.ICNODE = myRow.ICNODE and ppsg_rowmat.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_rowmat.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Format' then cast((select FORMAT from RndSuite.RndvSpIiPpsgRow myRow where ppsg_rowmat.SP = myRow.SP and ppsg_rowmat.SP_VERSION = myRow.SP_VERSION and ppsg_rowmat.IC = myRow.IC and ppsg_rowmat.ICNODE = myRow.ICNODE and ppsg_rowmat.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_rowmat.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Unit' then cast((select UNIT from RndSuite.RndvSpIiPpsgRow myRow where ppsg_rowmat.SP = myRow.SP and ppsg_rowmat.SP_VERSION = myRow.SP_VERSION and ppsg_rowmat.IC = myRow.IC and ppsg_rowmat.ICNODE = myRow.ICNODE and ppsg_rowmat.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_rowmat.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'ValueS' then cast((select max(ISNULL(celllang.VALUE_S,mycells.VALUE_S)) from RndSuite.RndvSpIiPpsgCell mycells
								  left join RndSuite.RndvSpIiPpsgCellLang celllang on celllang.SP = mycells.SP and celllang.SP_VERSION = mycells.SP_VERSION and celllang.IC = mycells.IC and celllang.ICNODE = mycells.ICNODE and celllang.IINODE = mycells.IINODE and celllang.PR_SEQ = mycells.PR_SEQ and LANG_ID = @p_Lang
								  where ppsg_rowmat.SP = mycells.SP and ppsg_rowmat.SP_VERSION = mycells.SP_VERSION and ppsg_rowmat.IC = mycells.IC and ppsg_rowmat.ICNODE = mycells.ICNODE and ppsg_rowmat.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_rowmat.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                           else 
                                   cast((select VALUE from RndSuite.RndvSpIiPpsgCell mycells where ppsg_rowmat.SP = mycells.SP and ppsg_rowmat.SP_VERSION = mycells.SP_VERSION and ppsg_rowmat.IC = mycells.IC and ppsg_rowmat.ICNODE = mycells.ICNODE and ppsg_rowmat.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_rowmat.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                                  
                           end 
                     when 'STDPROP_UOM' then ppsg_rowmat.UNIT
                     when 'AU_VTP' then
                           cast((select max(ISNULL(celllang.VALUE_S,mycells.VALUE_S))from RndSuite.RndvSpIiPpsgCell mycells 
						   left join RndSuite.RndvSpIiPpsgCellLang celllang on celllang.SP = mycells.SP and celllang.SP_VERSION = mycells.SP_VERSION and celllang.IC = mycells.IC and celllang.ICNODE = mycells.ICNODE and celllang.IINODE = mycells.IINODE and celllang.PR_SEQ = mycells.PR_SEQ and LANG_ID = @p_Lang
						   where ppsg_rowmat.SP = mycells.SP and ppsg_rowmat.SP_VERSION = mycells.SP_VERSION and ppsg_rowmat.IC = mycells.IC and ppsg_rowmat.ICNODE = mycells.ICNODE and ppsg_rowmat.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_rowmat.PR_SEQ 
                                                                           and mycells.COL_TP = concat('AU_',e.COL_LINK)) as nvarchar)
                                  
					 when 'DA_VTP' then
                           cast((select max(ISNULL(celllang.VALUE_S,mycells.VALUE_S)) from RndSuite.RndvSpIiPpsgCell mycells 
						   				left join RndSuite.RndvSpIiPpsgCellLang celllang on celllang.SP = mycells.SP and celllang.SP_VERSION = mycells.SP_VERSION and celllang.IC = mycells.IC and celllang.ICNODE = mycells.ICNODE and celllang.IINODE = mycells.IINODE and celllang.PR_SEQ = mycells.PR_SEQ and LANG_ID = @p_Lang
						   where ppsg_rowmat.SP = mycells.SP and ppsg_rowmat.SP_VERSION = mycells.SP_VERSION and ppsg_rowmat.IC = mycells.IC and ppsg_rowmat.ICNODE = mycells.ICNODE and ppsg_rowmat.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_rowmat.PR_SEQ 
                                                                           and mycells.LY_SEQ = e.LY_SEQ) as nvarchar)
                     else 'COL_TYPE NON RECOGNIZED !'
                 end 
          else null
          end as PR_VALUE
         
         
  from RndSuite.RndvRq rq 

  --récuperation champ commentaire qualité de la spec PMSF
  left join RndSuite.RndvFmMat  mat on mat.RQ = rq.RQ 
  left join RndSuite.RndvSp spmat on spmat.SP = mat.SP and spmat.SP_VERSION = mat.SP_VERSION
  left join RndSuite.RndvFr fr  on spmat.FR = fr.FR and spmat.FR_VERSION = fr.FR_VERSION and fr.FR_VALUE = 'PMSF'
  left join RndSuite.RndvSpIc spicmat on spicmat.SP = spmat.SP and spicmat.SP_VERSION = spmat.SP_VERSION 
  left join RndSuite.RndvSpIi spiimat on spiimat.SP = spmat.SP and spiimat.SP_VERSION = spmat.SP_VERSION and spiimat.IC = spicmat.IC and spiimat.ICNODE = spicmat.ICNODE
  left join RndSuite.RndvSpIiPpsgRow ppsg_rowmat on spiimat.SP = ppsg_rowmat.SP and spiimat.SP_VERSION = ppsg_rowmat.SP_VERSION and spiimat.IC = ppsg_rowmat.IC and spiimat.ICNODE = ppsg_rowmat.ICNODE and spiimat.IINODE = ppsg_rowmat.IINODE
  left join RndSuite.RndvSpIiPpsgCell cellmat on ppsg_rowmat.SP = cellmat.SP and cellmat.SP_VERSION = ppsg_rowmat.SP_VERSION and ppsg_rowmat.IC = cellmat.IC and ppsg_rowmat.ICNODE = cellmat.ICNODE and ppsg_rowmat.IINODE = cellmat.IINODE and cellmat.PR_SEQ = ppsg_rowmat.PR_SEQ
  left join RndSuite.RndvSpIiComp compmat on spiimat.SP = compmat.SP and spiimat.SP_VERSION = compmat.SP_VERSION and spiimat.IC = compmat.IC and spiimat.ICNODE = compmat.ICNODE and spiimat.IINODE = compmat.IINODE
  left join RndSuite.RndvSpIiLy spiilymat on spiimat.SP = spiilymat.SP and spiimat.SP_VERSION = spiilymat.SP_VERSION and spiimat.ICNODE = spiilymat.ICNODE and spiimat.IINODE = spiilymat.IINODE
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
  where COL_HIDDEN <> 1) e on spiilymat.LY = e.LY and spiilymat.LY_VERSION = e.LY_VERSION

  left join RndSuite.RndvSpIiPpsgCell cellcli on ppsg_rowmat.SP = cellcli.SP and cellcli.SP_VERSION = ppsg_rowmat.SP_VERSION and ppsg_rowmat.IC = cellcli.IC and ppsg_rowmat.ICNODE = cellcli.ICNODE and ppsg_rowmat.IINODE = cellcli.IINODE and cellcli.PR_SEQ = ppsg_rowmat.PR_SEQ and cellcli.PR_SEQ = 2 and cellcli.LY_SEQ = 4 

  -- Récuperation client de la formule 
  left join RndSuite.RndvRqSp rqsp on rqsp.RQ = rq.RQ
  left join RndSuite.RndvSp client on client.SP = rqsp.SP and client.SP_VERSION in ( select CASE rqsp.SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = client.SP) else rqsp.SP_VERSION end)


  where rq.RQ = @p_RQ and spiimat.II_SHORT_DESC = 'Customer_PPSG'