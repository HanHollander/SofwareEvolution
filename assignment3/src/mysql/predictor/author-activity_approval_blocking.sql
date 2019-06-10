-- Amount of attributed approval/blocking, per author

SELECT
	hist_authorAccountId,
    COUNT(hist_id)
FROM
	-- gm_libreoffice.t_history
    gm_eclipse.t_history
WHERE
	hist_message LIKE '%Looks good to me, approved%'
	OR hist_message LIKE '%Code-Review+2%'
	OR hist_message LIKE '%Do not submit%'
	OR hist_message LIKE '%Code-Review-2%'
GROUP BY
	hist_authorAccountId
