-- The first review submitted, per author (REVIEW TENURE)

SELECT
	hist_authorAccountId,
    MIN(hist_createdTime)
FROM
	gm_eclipse.t_history
-- 	gm_libreoffice.t_history
WHERE
	hist_message LIKE '%Looks good to me, but someone else must approve%'
	OR hist_message LIKE '%Code-Review+1%'
	OR hist_message LIKE '%I would prefer that you didn\'t submit this%'
	OR hist_message LIKE '%Code-Review-1%'
GROUP BY
	hist_authorAccountId
