EXEC [RndSuite].[RndprSetConnectionForReport] @p_UserName;
select distinct
client.DESCRIPTION as client_form_nom, 
spic.IC_SHORT_DESC as client_form_short_desc_ic,
spii.II_SHORT_DESC as client_form_short_desc_ii,
spii.IIVALUE as client_form_value ,
e.DISP_TITLE as PR_HEADER_DESC,
case when spii.DSP_TP = '@' then
                 case e.COL_TYPE
                     when 'STDPROP_VTP' then
                           case e.COL_LINK
                                  when 'ShortDescription' then cast((select SHORT_DESC from RndSuite.RndvSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Description' then cast((select DESCRIPTION from RndSuite.RndvSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Format' then cast((select FORMAT from RndSuite.RndvSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Unit' then cast((select UNIT from RndSuite.RndvSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'ValueS' then cast((select VALUE_S from RndSuite.RndvSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                           else 
                                   cast((select VALUE from RndSuite.RndvSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                                  
                           end 
                     when 'STDPROP_UOM' then ppsg_row.UNIT
                     when 'AU_VTP' then
                           cast((select VALUE_S from RndSuite.RndvSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = concat('AU_',e.COL_LINK)) as nvarchar)
                                  
					 when 'DA_VTP' then
                           cast((select VALUE_S from RndSuite.RndvSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.LY_SEQ = e.LY_SEQ) as nvarchar)
                     else 'COL_TYPE NON RECOGNIZED !'
                 end 
          else null
          end as PR_VALUE




from RndSuite.RndvRq as form

--client_formule
left join RndSuite.RndvRqSp as rqsp on rqsp.RQ = form.RQ 
left join RndSuite.RndvSp as client on client.SP = rqsp.SP and client.SP_VERSION in ( select CASE rqsp.SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = client.SP) else rqsp.SP_VERSION end)
left join RndSuite.RndvSpIc as spic on spic.SP = client.SP 
left join RndSuite.RndvSpIi as spii on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE and spii.IC = spic.IC
left join RndSuite.RndvSpIiPpsgRow as ppsg_row on ppsg_row.SP = spii.SP and ppsg_row.IC = spii.IC and ppsg_row.ICNODE = spii.ICNODE and ppsg_row.IINODE = spii.IINODE
left join RndSuite.RndvSpIiPpsgCell cell on ppsg_row.SP = cell.SP and ppsg_row.IC = cell.IC and ppsg_row.ICNODE = cell.ICNODE and ppsg_row.IINODE = cell.IINODE and cell.PR_SEQ = ppsg_row.PR_SEQ
left join RndSuite.RndvSpIiLy spiily on spii.SP = spiily.SP and spii.ICNODE = spiily.ICNODE and spii.IINODE = spiily.IINODE
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

  where form.RQ_VALUE = @p_RQ and spic.IC_SHORT_DESC = 'General Informations'


  Union 

  select distinct 
  clientdec.DESCRIPTION as client_form_nom, 
spic.IC_SHORT_DESC as client_form_short_desc_ic,
spii.II_SHORT_DESC as client_form_short_desc_ii,
spii.IIVALUE as client_form_value ,
e.DISP_TITLE as PR_HEADER_DESC,
case when spii.DSP_TP = '@' then
                 case e.COL_TYPE
                     when 'STDPROP_VTP' then
                           case e.COL_LINK
                                  when 'ShortDescription' then cast((select SHORT_DESC from RndSuite.RndvSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Description' then cast((select DESCRIPTION from RndSuite.RndvSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Format' then cast((select FORMAT from RndSuite.RndvSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'Unit' then cast((select UNIT from RndSuite.RndvSpIiPpsgRow myRow where ppsg_row.SP = myRow.SP and ppsg_row.SP_VERSION = myRow.SP_VERSION and ppsg_row.IC = myRow.IC and ppsg_row.ICNODE = myRow.ICNODE and ppsg_row.IINODE = myRow.IINODE and myRow.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           ) as nvarchar)
                                  when 'ValueS' then cast((select VALUE_S from RndSuite.RndvSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                           else 
                                   cast((select VALUE from RndSuite.RndvSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = e.COL_LINK) as nvarchar)
                                  
                           end 
                     when 'STDPROP_UOM' then ppsg_row.UNIT
                     when 'AU_VTP' then
                           cast((select VALUE_S from RndSuite.RndvSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.COL_TP = concat('AU_',e.COL_LINK)) as nvarchar)
                                  
					 when 'DA_VTP' then
                           cast((select VALUE_S from RndSuite.RndvSpIiPpsgCell mycells where ppsg_row.SP = mycells.SP and ppsg_row.SP_VERSION = mycells.SP_VERSION and ppsg_row.IC = mycells.IC and ppsg_row.ICNODE = mycells.ICNODE and ppsg_row.IINODE = mycells.IINODE and mycells.PR_SEQ = ppsg_row.PR_SEQ 
                                                                           and mycells.LY_SEQ = e.LY_SEQ) as nvarchar)
                     else 'COL_TYPE NON RECOGNIZED !'
                 end 
          else null
          end as PR_VALUE



--props du dec
from RndSuite.RndvRq as form
left join RndSuite.RndvRqRq as rqrq on form.RQ = rqrq.RQ
left join RndSuite.RndvRq as decprop on decprop.RQ = rqrq.RQ_CHILD

--client dec
left join RndSuite.RndvRqSp as rqspdec on rqspdec.RQ = decprop.RQ
left join RndSuite.RndvSp as clientdec on clientdec.SP = rqspdec.SP and clientdec.SP_VERSION in ( select CASE rqspdec.SP_VERSION when -1 then (select TOP 1 first_value(x.SP_VERSION) over (order by x.ACTIVE desc, x.SP_VERSION desc) from RndSuite.RndvSp x where x.SP = clientdec.SP) else rqspdec.SP_VERSION end)
left join RndSuite.RndvSpIc as spic on spic.SP = clientdec.SP 
left join RndSuite.RndvSpIi as spii on spii.SP = spic.SP and spii.SP_VERSION = spic.SP_VERSION and spii.ICNODE = spic.ICNODE and spii.IC = spic.IC
left join RndSuite.RndvSpIiPpsgRow as ppsg_row on ppsg_row.SP = spii.SP and ppsg_row.IC = spii.IC and ppsg_row.ICNODE = spii.ICNODE and ppsg_row.IINODE = spii.IINODE
left join RndSuite.RndvSpIiPpsgCell cell on ppsg_row.SP = cell.SP and ppsg_row.IC = cell.IC and ppsg_row.ICNODE = cell.ICNODE and ppsg_row.IINODE = cell.IINODE and cell.PR_SEQ = ppsg_row.PR_SEQ
left join RndSuite.RndvSpIiLy spiily on spii.SP = spiily.SP and spii.ICNODE = spiily.ICNODE and spii.IINODE = spiily.IINODE
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

where form.RQ_VALUE = @p_RQ  and spic.IC_SHORT_DESC = 'General Informations'