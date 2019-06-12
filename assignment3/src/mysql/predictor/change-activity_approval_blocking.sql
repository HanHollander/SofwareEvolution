SELECT
	ch_changeIdNum,
    COUNT(ch_changeIdNum)
FROM
 	gm_eclipse.t_change,
    gm_eclipse.t_history
--  gm_libreoffice.t_change,
--  gm_libreoffice.t_history
WHERE
	ch_authorAccountId = hist_authorAccountId
    AND ch_createdTime > hist_createdTime
    AND (	hist_message LIKE '%Looks good to me, approved%'
			OR hist_message LIKE '%Code-Review+2%'
			OR hist_message LIKE '%Do not submit%'
			OR hist_message LIKE '%Code-Review-2%'
		)
GROUP BY
	ch_changeIdNum