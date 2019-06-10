-- The first change submitted, per author (ECOSYSTEM TENURE)

SELECT
	ch_authorAccountId,
    MIN(ch_createdTime)
FROM
--     gm_eclipse.t_change
	gm_libreoffice.t_change
GROUP BY
	ch_authorAccountId
