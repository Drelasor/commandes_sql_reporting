=Switch(
IsNothing(Fields!PR_VALUE.Value), True,
Fields!II_SHORT_DESC.Value = "Europe" And Fields!PR_HEADER_SEQ.Value = 18, False,
Fields!II_SHORT_DESC.Value = "France"  And Fields!PR_HEADER_SEQ.Value = 18, False, 
Fields!II_SHORT_DESC.Value = "Hors_EU" And Fields!PR_HEADER_SEQ.Value = 18, False, 
Fields!II_SHORT_DESC.Value = "Latina"And Fields!PR_HEADER_SEQ.Value = 18, False, 
Fields!II_SHORT_DESC.Value = "Middle East"And Fields!PR_HEADER_SEQ.Value = 18, False, 
Fields!II_SHORT_DESC.Value = "North_America"And Fields!PR_HEADER_SEQ.Value = 18, False, 
Fields!II_SHORT_DESC.Value = "Oceania" And Fields!PR_HEADER_SEQ.Value = 18, False, 
Fields!II_SHORT_DESC.Value = "Asia" And Fields!PR_HEADER_SEQ.Value = 18, False, 
Fields!II_SHORT_DESC.Value = "Africa" And Fields!PR_HEADER_SEQ.Value = 18, False, 
True, True
)