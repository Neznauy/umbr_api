Test query:

SELECT
  min_and_count.min_id AS min_id,
  min_and_count.count AS count,
  users.group_id AS group_id
FROM
  (SELECT
    min(id) AS min_id,
    count(*) AS count
  FROM 
    (SELECT id, group_id, row_number() over (ORDER BY id) - row_number() over (PARTITION BY group_id ORDER BY id) AS grp FROM users ) AS groups
  GROUP BY grp) AS min_and_count
INNER JOIN users ON min_and_count.min_id = users.id;
