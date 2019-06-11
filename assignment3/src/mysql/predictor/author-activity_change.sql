-- Amount of attributed changes, per author

SELECT
	ch_authorAccountId,
    COUNT(ch_id)
FROM
	-- gm_libreoffice.t_change
    gm_eclipse.t_change As ch
GROUP BY
	ch_authorAccountId
