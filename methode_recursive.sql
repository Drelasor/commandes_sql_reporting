WITH RECURSIVE SpecHierarchy AS (
  SELECT
    SP.ID AS ParentID,
    SPIC.*,
    SPII.*,
    SPSP.ChildID
  FROM SP
  INNER JOIN SPIC ON SP.ID = SPIC.SP_ID
  INNER JOIN SPII ON SPIC.ID = SPII.SPIC_ID
  LEFT JOIN SPSP ON SP.ID = SPSP.ParentID
  WHERE SP.ID = parent_id -- Remplacez parent_id par l'ID de l'élément parent souhaité
  
  UNION ALL
  
  SELECT
    SH.ParentID,
    SPIC.*,
    SPII.*,
    SPSP.ChildID
  FROM SpecHierarchy SH
  INNER JOIN SPSP ON SH.ChildID = SPSP.ParentID
  INNER JOIN SPIC ON SPSP.ChildID = SPIC.SP_ID
  INNER JOIN SPII ON SPIC.ID = SPII.SPIC_ID
)

SELECT * FROM SpecHierarchy;


----


