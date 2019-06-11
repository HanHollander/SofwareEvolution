-- The first review submitted, per author (APPROVAL/BLOCKING TENURE)

SELECT
	hist_authorAccountId,
    MIN(hist_createdTime)
FROM
--     gm_eclipse.t_history
	gm_libreoffice.t_history
WHERE
	hist_message LIKE '%Looks good to me, approved%'
	OR hist_message LIKE '%Code-Review+2%'
	OR hist_message LIKE '%Do not submit%'
	OR hist_message LIKE '%Code-Review-2%'
GROUP BY
	hist_authorAccountId
