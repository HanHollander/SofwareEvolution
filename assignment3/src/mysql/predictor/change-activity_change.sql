SELECT
	ch1.ch_changeIdNum,
    COUNT(ch1.ch_changeIdNum) as c
FROM
	gm_eclipse.t_change as ch1,
	gm_eclipse.t_change as ch2
-- 	gm_libreoffice.t_change as ch1,
--  gm_libreoffice.t_change as ch2
WHERE
	ch1.ch_authorAccountId = ch2.ch_authorAccountId
    AND ch1.ch_createdTime > ch2.ch_createdTime
GROUP BY
	ch1.ch_changeIdNum