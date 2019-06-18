SELECT
	rev_changeId as ch_changeIdNum,
    COUNT(DISTINCT f.id) as c
FROM
--    gm_eclipse.t_file as f,
--    gm_eclipse.t_revision as rev
  gm_libreoffice.t_file as f,
  gm_libreoffice.t_revision as rev
WHERE
	f_revisionId = rev.id
GROUP BY
    rev_changeId