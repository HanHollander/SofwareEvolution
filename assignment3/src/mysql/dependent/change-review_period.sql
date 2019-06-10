-- The duration of the review period, per change

SELECT
	ch_changeIdNum,
    DATEDIFF(hist2.hist_createdTime, hist1.hist_createdTime)
FROM
-- 	gm_eclipse.t_change,
--  gm_eclipse.t_history AS hist1,
-- 	gm_eclipse.t_history AS hist2
	gm_libreoffice.t_change,
    gm_libreoffice.t_history AS hist1,
    gm_libreoffice.t_history AS hist2
WHERE
    ch_status = 'MERGED'
    AND ch_changeIdNum = hist1.hist_changeId
	AND hist1.hist_changeId = hist2.hist_changeId
    AND hist1.hist_message LIKE '%Uploaded patch set 1.%'
	AND (	hist2.hist_message LIKE '%Looks good to me, approved%'
			OR hist2.hist_message LIKE '%Code-Review+2%'	)
ORDER BY ch_changeIdNum;
