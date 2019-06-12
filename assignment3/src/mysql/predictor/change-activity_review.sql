SELECT
	ch_changeIdNum,
    COUNT(ch_changeIdNum)
FROM
-- 	gm_eclipse.t_change,
--  gm_eclipse.t_history
    gm_libreoffice.t_change,
    gm_libreoffice.t_history
WHERE
	ch_authorAccountId = hist_authorAccountId
    AND ch_createdTime > hist_createdTime
    AND (	hist_message LIKE '%Looks good to me, but someone else must approve%'
			OR hist_message LIKE '%Code-Review+1%'
			OR hist_message LIKE '%I would prefer that you didn\'t submit this%'
			OR hist_message LIKE '%Code-Review-1%'
		)
GROUP BY
	ch_changeIdNum
    
    
-- SELECT
-- 	hist_authorAccountId,
--     MIN(hist_createdTime)
-- FROM
-- 	gm_eclipse.t_history
-- -- 	gm_libreoffice.t_history
-- WHERE
-- 	hist_message LIKE '%Looks good to me, but someone else must approve%'
-- 	OR hist_message LIKE '%Code-Review+1%'
-- 	OR hist_message LIKE '%I would prefer that you didn\'t submit this%'
-- 	OR hist_message LIKE '%Code-Review-1%'
-- GROUP BY
-- 	hist_authorAccountId

--   -----------------------------------------------------------------  

-- SELECT
-- 	ch1.ch_changeIdNum,
--  COUNT(ch1.ch_changeIdNum) as c
-- FROM
-- 	gm_eclipse.t_change as ch1,
-- 	gm_eclipse.t_change as ch2
-- -- 	gm_libreoffice.t_change as ch1,
-- --  gm_libreoffice.t_change as ch2
-- WHERE
-- 	ch1.ch_authorAccountId = ch2.ch_authorAccountId
--     AND ch1.ch_createdTime > ch2.ch_createdTime
-- GROUP BY
-- 	ch1.ch_changeIdNum

--     -----------------------------------------------------------------

-- SELECT
-- 	ch_authorAccountId,
--     MIN(ch_createdTime)
-- FROM
-- --     gm_eclipse.t_change
-- 	gm_libreoffice.t_change
-- GROUP BY
-- 	ch_authorAccountId