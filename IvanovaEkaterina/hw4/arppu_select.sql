WITH RECURSIVE cte AS
(
   SELECT MIN(CAST(payment_dttm AS DATE)) AS dt FROM payments
        UNION ALL
   SELECT cte.dt + INTERVAL 1 DAY
        FROM cte
        WHERE cte.dt + INTERVAL 1 DAY <= (SELECT MAX(CAST(payment_dttm AS DATE)) AS dt FROM payments)
),
PayForDay AS
(
    SELECT CAST(payment_dttm AS DATE) AS dt, SUM(payment_sum) as sum
	     FROM payments
         GROUP BY dt
),
PUForDay AS
(
    SELECT CAST(payment_dttm AS DATE) AS dt, COUNT(DISTINCT  payments.user_id) as count
        FROM payments
        GROUP BY dt
)
SELECT cte.dt as Day, COALESCE(pay.sum, 0) / COALESCE(PU.count, 1) as ARPPU
    FROM cte
    LEFT JOIN PayForDay AS pay ON cte.dt = pay.dt
    LEFT JOIN PUForDay AS PU ON cte.dt = PU.dt;
	
	+------------+--------------------+
	| Day        | ARPPU              |
	+------------+--------------------+
	| 2018-08-07 |                902 |
	| 2018-08-08 |                  0 |
	| 2018-08-09 |                  0 |
	| 2018-08-10 |                317 |
	| 2018-08-11 |                135 |
	| 2018-08-12 |                330 |
	| 2018-08-13 |                615 |
	| 2018-08-14 |                510 |
	| 2018-08-15 |                372 |
	| 2018-08-16 |                 28 |
	| 2018-08-17 |              731.5 |
	| 2018-08-18 |                839 |
	| 2018-08-19 |              381.5 |
	| 2018-08-20 |                508 |
	| 2018-08-21 |                277 |
	| 2018-08-22 |                  0 |
	| 2018-08-23 |              443.5 |
	| 2018-08-24 |             556.25 |
	| 2018-08-25 |              528.5 |
	| 2018-08-26 |                  0 |
	| 2018-08-27 |              818.5 |
	| 2018-08-28 |             633.75 |
	| 2018-08-29 |                537 |
	| 2018-08-30 |             476.75 |
	| 2018-08-31 |  348.6666666666667 |
	| 2018-09-01 |                466 |
	| 2018-09-02 |              154.5 |
	| 2018-09-03 |                  0 |
	| 2018-09-04 |                549 |
	| 2018-09-05 |                800 |
	| 2018-09-06 |             665.75 |
	| 2018-09-07 |                584 |
	| 2018-09-08 |              448.5 |
	| 2018-09-09 |  510.6666666666667 |
	| 2018-09-10 |             629.75 |
	| 2018-09-11 |              615.2 |
	| 2018-09-12 |  731.3333333333334 |
	| 2018-09-13 |                532 |
	| 2018-09-14 |  479.3333333333333 |
	| 2018-09-15 |              586.5 |
	| 2018-09-16 |  641.4444444444445 |
	| 2018-09-17 |             418.25 |
	| 2018-09-18 |                350 |
	| 2018-09-19 |            475.375 |
	| 2018-09-20 |  633.3333333333334 |
	| 2018-09-21 |             553.75 |
	| 2018-09-22 |                263 |
	| 2018-09-23 |              733.4 |
	| 2018-09-24 |              776.6 |
	| 2018-09-25 |  614.2222222222222 |
	| 2018-09-26 | 1056.8333333333333 |
	| 2018-09-27 |  420.7857142857143 |
	| 2018-09-28 |  994.2727272727273 |
	| 2018-09-29 |  837.6923076923077 |
	| 2018-09-30 |            1100.75 |
	+------------+--------------------+