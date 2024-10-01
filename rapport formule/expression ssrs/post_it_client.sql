=Switch(

     Fields!client_dec_short_desc_ic.Value = "Instructions"
     AND IsNothing(Fields!client_dec_value.Value), True,
     Fields!client_form_short_desc_ic.Value = "Instructions"
     AND IsNothing(Fields!client_form_value.Value), True,

      Fields!client_dec_short_desc_ic.Value = "RM Requirements"
      AND IsNothing(Fields!client_dec_value.Value), True,
      Fields!client_form_short_desc_ic.Value = "RM Requirements"
     AND IsNothing(Fields!client_form_value.Value), True,


 Fields!client_form_short_desc_ic.Value = "Instructions" AND 
    (Fields!client_dec_short_desc_ii.Value = "Formulation" OR
    Fields!client_form_short_desc_ii.Value = "Product_Spec_Guidelines" OR
    Fields!client_form_short_desc_ii.Value = "Industrialization" OR
    Fields!client_form_short_desc_ii.Value = "DAP_Instructions" OR
    Fields!client_form_short_desc_ii.Value = "Instructions_certificates" OR
    Fields!client_form_short_desc_ii.Value = "Other_Instructions"), False,

    Fields!client_form_short_desc_ic.Value = "RM Requirements" AND 
    Fields!client_form_short_desc_ii.Value = "Formulation", False,

    Fields!client_dec_short_desc_ic.Value = "Instructions" AND
    (Fields!client_dec_short_desc_ii.Value = "Formulation" OR
    Fields!client_dec_short_desc_ii.Value = "Product_Spec_Guidelines" OR
    Fields!client_dec_short_desc_ii.Value = "Industrialization" OR
    Fields!client_dec_short_desc_ii.Value = "DAP_Instructions" OR
    Fields!client_dec_short_desc_ii.Value = "Instructions_certificates" OR
    Fields!client_dec_short_desc_ii.Value = "Other_Instructions"), False,

    Fields!client_dec_short_desc_ic.Value = "RM Requirements" AND 
    Fields!client_dec_short_desc_ii.Value = "Formulation", False,

    True, True
)