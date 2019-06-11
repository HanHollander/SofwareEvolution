-- Amount of attributed reviews, per author

SELECT
	hist_authorAccountId,
    COUNT(hist_id)
FROM
	gm_libreoffice.t_history
	-- gm_eclipse.t_history
WHERE
	hist_message LIKE '%Looks good to me, but someone else must approve%'
	OR hist_message LIKE '%Code-Review+1%'
	OR hist_message LIKE '%I would prefer that you didn\'t submit this%'
	OR hist_message LIKE '%Code-Review-1%'
GROUP BY
	hist_authorAccountId
