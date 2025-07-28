# Weekly Gear note
SELECT 
    DATE_TRUNC('week', gl.created_at)::DATE AS week_start,
    pg.name AS container,
    g.name || ' (ID: ' || gl.gear_id || ')' AS gear,
    gl.note
FROM gear_log gl
JOIN gear g ON gl.gear_id = g.id
LEFT JOIN gear pg ON g.parent_id = pg.id
WHERE gl.has_note = TRUE
GROUP BY week_start, pg.name, gl.gear_id, g.name, gl.note
ORDER BY week_start DESC, gear;

# Weekly Bag Usage
SELECT 
    DATE_TRUNC('week', gl.created_at)::DATE AS week_start,
    p.name as container,
    SUM(CASE WHEN gl.is_used THEN 1 ELSE 0 END) AS gear_used_count
FROM gear_log gl
JOIN gear g ON gl.gear_id = g.id
left join gear p on g.parent_id = p.id
GROUP BY week_start, p.name
HAVING SUM(CASE WHEN gl.is_used THEN 1 ELSE 0 END) > 0
ORDER BY week_start desc, p.name;

# Weekly Gear Missing
SELECT 
    DATE_TRUNC('week', gl.created_at)::DATE AS week_start,
    p.name as container,
    CONCAT(g.name, ' (ID: ', gl.gear_id, ')') AS gear,
    SUM(CASE WHEN gl.is_missing THEN 1 ELSE 0 END) AS missing_count
FROM gear_log gl
JOIN gear g ON gl.gear_id = g.id
left join gear p on g.parent_id = p.id
GROUP BY week_start, p.name, gl.gear_id, g.name
HAVING SUM(CASE WHEN gl.is_missing THEN 1 ELSE 0 END) > 0
ORDER BY week_start desc, gl.gear_id, g.name;

# Weekly Gear Expired
WITH week_start AS (
  SELECT DATE_TRUNC('week', CURRENT_DATE AT TIME ZONE 'Australia/Sydney') AS start_date
)
SELECT
  pg.name AS container,
  g.name || ' (ID: ' || g.id || ')' AS gear,
  g.mfg_date,
  g.shelf_life,
  g.expiry_date::DATE AS expiry_date,
  FLOOR(EXTRACT(EPOCH FROM (CURRENT_DATE AT TIME ZONE 'Australia/Sydney' - g.expiry_date::DATE)) / 86400) AS days_since_expiry
FROM gear g
LEFT JOIN gear pg ON g.parent_id = pg.id
CROSS JOIN week_start
WHERE
  g.track_expiry = TRUE
  AND g.expiry_date < week_start.start_date
ORDER BY g.expiry_date, g.id;

# Weekly Gear Expiring
select
  p.name as container,
  CONCAT(g.name, ' (ID: ', g.id, ')') AS gear,
  g.mfg_date,
  g.shelf_life,
  g.expiry_date::DATE as expiry_date
from
  gear g
  left join gear p on g.parent_id = p.id
where
  g.track_expiry = true
  and g.expiry_date >= DATE_TRUNC(
    'week',
    CURRENT_DATE AT TIME ZONE 'Australia/Sydney'
  )
  and g.expiry_date < DATE_TRUNC(
    'week',
    CURRENT_DATE AT TIME ZONE 'Australia/Sydney'
  ) + INTERVAL '1 week'
order by
  g.expiry_date,
  g.id;

# Weekly Gear Damaged
SELECT 
    DATE_TRUNC('week', gl.created_at)::DATE AS week_start,
    p.name as container,
    CONCAT(g.name, ' (ID: ', gl.gear_id, ')') AS gear,
    SUM(CASE WHEN gl.is_damaged THEN 1 ELSE 0 END) AS damaged_count
FROM gear_log gl
JOIN gear g ON gl.gear_id = g.id
left join gear p on g.parent_id = p.id
GROUP BY week_start, p.name, gl.gear_id, g.name
HAVING SUM(CASE WHEN gl.is_damaged THEN 1 ELSE 0 END) > 0
ORDER BY week_start desc, gl.gear_id, g.name;

# Weekly Gear Used
SELECT 
    DATE_TRUNC('week', gl.created_at)::DATE AS week_start,
    p.name as container,
    CONCAT(g.name, ' (ID: ', gl.gear_id, ')') AS gear,
    SUM(CASE WHEN gl.is_used THEN 1 ELSE 0 END) AS used_count
FROM gear_log gl

JOIN gear g ON gl.gear_id = g.id
left join gear p on g.parent_id = p.id
GROUP BY week_start, gl.gear_id, g.name, p.name
HAVING SUM(CASE WHEN gl.is_used THEN 1 ELSE 0 END) > 0
ORDER BY week_start desc, gl.gear_id, g.name;