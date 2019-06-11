-- WOULD PROBABLY WORK, BUT CANT RUN (TIMEOUT AFTER 30 SECONDS)...

SELECT
	rev_changeId,
    SUM(f_linesInserted)
FROM
	gm_eclipse.t_revision,
	gm_eclipse.t_file
WHERE
	f_revisionId = rev_id
GROUP BY rev_changeId
