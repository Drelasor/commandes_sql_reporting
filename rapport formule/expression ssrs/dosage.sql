=Switch(
IsNothing(Fields!PR_VALUE.Value), "",
   Fields!PR_VALUE.Value = "100", "",
    Fields!PR_VALUE.Value= "0", "interdit"&" "& Fields!PR_HEADER_DESC.Value &" " ,
    CDbl(Replace(Fields!PR_VALUE.Value, ".", ",")) > 0 And CDbl(Replace(Fields!PR_VALUE.Value, ".", ",")) < 100, 
        IIf(Fields!sum_final_result.Value * CDbl(Replace(Fields!incorporation.Value,".",",")) > CDbl(Replace(Fields!PR_VALUE.Value, ".", ",")), "Interdit "& Fields!PR_HEADER_DESC.Value &" "& Fields!sum_final_result.Value * CDbl(Replace(Fields!incorporation.Value,".",",")) & " > " & CDbl(Replace(Fields!PR_VALUE.Value, ".", ",")), "")
)


/*=Switch(
    Fields!PR_VALUE.Value= 0, Fields!PR_HEADER_DESC.Value &" = 0" ,
    Fields!PR_VALUE.Value > 0  And Fields!PR_VALUE.Value < 100, 
        IIf(Fields!sum_final_result.Value * Fields!incorporation.Value  > Fields!PR_VALUE.Value,  Fields!PR_HEADER_DESC.Value &" "& Fields!sum_final_result.Value * Fields!incorporation.Value & " > " & Fields!PR_VALUE.Value, "")
)*/