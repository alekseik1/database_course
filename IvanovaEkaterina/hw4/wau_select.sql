WITH RECURSIVE cte AS
(
    SELECT MIN(CAST(begin_dttm AS DATE)) AS dt FROM sessions
        UNION ALL
	SELECT dt + INTERVAL 1 WEEK
      FROM cte
     WHERE dt + INTERVAL 1 WEEK <= (SELECT MAX(CAST(begin_dttm AS DATE)) FROM sessions)
)
SELECT cte.dt as FirstDayOFWeek, COUNT(DISTINCT sessions.user_id) as WAU
  FROM sessions RIGHT JOIN cte ON CAST(sessions.begin_dttm AS DATE) >= cte.dt 
  AND CAST(sessions.begin_dttm AS DATE) < cte.dt + INTERVAL 1 WEEK
 GROUP BY cte.dt
 ORDER BY cte.dt;
 
 +----------------+-----+
 | FirstDayOFWeek | WAU |
 +----------------+-----+
 | 2018-08-02     |   6 |
 | 2018-08-09     |  11 |
 | 2018-08-16     |  17 |
 | 2018-08-23     |  22 |
 | 2018-08-30     |  30 |
 | 2018-09-06     |  35 |
 | 2018-09-13     |  41 |
 | 2018-09-20     |  49 |
 | 2018-09-27     |  51 |
 +----------------+-----+