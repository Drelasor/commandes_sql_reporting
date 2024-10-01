=Switch(
    Fields!PR_HEADER_DESC.Value = "Pays", True,
    IsNothing(Fields!PR_VALUE.Value), True,
    Fields!PR_VALUE.Value = "100", True,
    Fields!II_SHORT_DESC.Value = "Europe", False,
    Fields!II_SHORT_DESC.Value = "France", False,
    Fields!II_SHORT_DESC.Value = "Hors_EU", False,
    Fields!II_SHORT_DESC.Value = "Latina", False,
    Fields!II_SHORT_DESC.Value = "Middle East", False,
    Fields!II_SHORT_DESC.Value = "North_America", False,
    Fields!II_SHORT_DESC.Value = "Oceania", False,
    Fields!II_SHORT_DESC.Value = "Asia", False,
    Fields!II_SHORT_DESC.Value = "Africa", False,
True,True
) 



