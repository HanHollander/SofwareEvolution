review_period <- read.csv(file="../../data/csv/libreoffice/dependent/change-review_period.csv",header=TRUE,sep=",")
tenure_change <- read.csv(file="../../data/csv/libreoffice/predictor/change-tenure_change.csv",header=TRUE,sep=",")
tenure_review <- read.csv(file="../../data/csv/libreoffice/predictor/change-tenure_review.csv",header=TRUE,sep=",")
tenure_approval_blocking <- read.csv(file="../../data/csv/libreoffice/predictor/change-tenure_approval_blocking.csv",header=TRUE,sep=",")
activity_change <- read.csv(file="../../data/csv/libreoffice/predictor/change-activity_change.csv",header=TRUE,sep=",")
activity_review <- read.csv(file="../../data/csv/libreoffice/predictor/change-activity_review.csv",header=TRUE,sep=",")
activity_approval_blocking <- read.csv(file="../../data/csv/libreoffice/predictor/change-activity_approval_blocking.csv",header=TRUE,sep=",")
added_locs <- read.csv(file="../../data/csv/libreoffice/control/change-added_locs.csv",header=TRUE,sep=",")
removed_locs <- read.csv(file="../../data/csv/libreoffice/control/change-removed_locs.csv",header=TRUE,sep=",")
files_modified <- read.csv(file="../../data/csv/libreoffice/control/change-files_modified.csv",header=TRUE,sep=",")

rp_tc <- merge(review_period, tenure_change, by = "ch_changeIdNum")
rp_tr <- merge(review_period, tenure_review, by = "ch_changeIdNum")
rp_tab <- merge(review_period, tenure_approval_blocking, by = "ch_changeIdNum")
rp_ac <- merge(review_period, activity_change, by = "ch_changeIdNum")
rp_ar <- merge(review_period, activity_review, by = "ch_changeIdNum")
rp_aab <- merge(review_period, activity_approval_blocking, by = "ch_changeIdNum")
rp_al <- merge(review_period, added_locs, by="ch_changeIdNum")
rp_rl <- merge(review_period, removed_locs, by="ch_changeIdNum")
rp_fm <- merge(review_period, files_modified, by="ch_changeIdNum")

# ----------------------------------------------------------------------------------#

boxplot(rp_tc$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    main="Boxplot: Review period of change")

plot(density(rp_tc$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.),
    main="Density Plot: Review period of change", ylab="Frequency")

# ----------------------------------------------------------------------------------#

boxplot(rp_tc$tenure_change,
    main="Boxplot: Change (ecosystem) tenure of author")

plot(density(rp_tc$tenure_change),
    main="Density Plot: Change (ecosystem) tenure of author",
    ylab="Frequency")

plot(x=rp_tc$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_tc$tenure_change,
    main="Scatterplot: Review period of change ~ Change (ecosystem) tenure of author",
    type="p",
    log="")  # scatterplot

# ----------------------------------------------------------------------------------#

boxplot(rp_tr$tenure_review,
    main="Box Plot: Review tenure of author")

plot(density(rp_tr$tenure_review),
    main="Density Plot: Review tenure of author",
    ylab="Frequency")

plot(x=rp_tr$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_tr$tenure_review,
    main="Scatterplot: Review period of change ~ Review tenure of author",
    type="p",
    log="")  # scatterplot

# ----------------------------------------------------------------------------------#

boxplot(rp_tab$tenure_approval_blocking,
    main="Box Plot: Approval/blocking tenure of author")

plot(density(rp_tab$tenure_approval_blocking),
    main="Density Plot: Approval/blocking tenure of author",
    ylab="Frequency")

plot(x=rp_tab$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_tab$tenure_approval_blocking,
    main="Scatterplot: Review period of change ~ Approval/blocking tenure of author",
    type="p",
    log="")  # scatterplot

# ----------------------------------------------------------------------------------#

boxplot(rp_ac$c,
    main="Boxplot: Change activity of author")

plot(density(rp_ac$c),
    main="Density Plot: Change activity of author",
    ylab="Frequency")

plot(x=rp_ac$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_ac$c,
    main="Scatterplot: Review period of change ~ Change activity of author",
    type="p",
    log="")  # scatterplot

# ----------------------------------------------------------------------------------#

boxplot(rp_ar$COUNT.ch_changeIdNum.,
    main="Boxplot: Review activity of author")

plot(density(rp_ar$COUNT.ch_changeIdNum.),
    main="Density Plot: Review activity of author",
    ylab="Frequency")

plot(x=rp_ar$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_ar$COUNT.ch_changeIdNum.,
    main="Scatterplot: Review period of change ~ Review activity of author",
    type="p",
    log="")  # scatterplot

# ----------------------------------------------------------------------------------#

boxplot(rp_aab$COUNT.ch_changeIdNum.,
    main="Boxplot: Approval/blocking activity of author")

plot(density(rp_aab$COUNT.ch_changeIdNum.),
    main="Density Plot: Approval/blocking activity of author",
    ylab="Frequency")

plot(x=rp_aab$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_aab$COUNT.ch_changeIdNum.,
    main="Scatterplot: Review period of change ~ Approval/blocking activity of author",
    type="p",
    log="")  # scatterplot

# ----------------------------------------------------------------------------------#

boxplot(rp_al$s,
    main="Boxplot: Added lines of code")

plot(density(rp_al$s),
    main="Density Plot: Added lines of code",
    ylab="Frequency")

plot(x=rp_al$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_al$s,
    main="Scatterplot: Review period of change ~ Added lines of code",
    type="p",
    log="")  # scatterplot

# ----------------------------------------------------------------------------------#

boxplot(rp_rl$s,
    main="Boxplot: Removed lines of code")

plot(density(rp_rl$s),
    main="Density Plot: Removed lines of code",
    ylab="Frequency")

plot(x=rp_rl$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_rl$s,
    main="Scatterplot: Review period of change ~ Removed lines of code",
    type="p",
    log="")  # scatterplot

# ----------------------------------------------------------------------------------#

boxplot(rp_fm$c,
    main="Boxplot: Files modified")

plot(density(rp_fm$c),
    main="Density Plot: Files modified",
    ylab="Frequency")

plot(x=rp_fm$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_fm$c,
    main="Scatterplot: Review period of change ~ Files modified",
    type="p",
    log="")  # scatterplot

# ----------------------------------------------------------------------------------#

# ##Generate some data
# dd <- data.frame(a = 1:4, b= 1:0, c=0:3)
# print(dd)
# ##Go through each row and determine if a value is zero
# row_sub <- apply(dd, 1, function(row) all(row !=0 ))
# print(row_sub)
# ##Subset as usual
# dd[row_sub,]

# k <- c(1, 2, 3, 4);
# v1 <- c("a", "b", "c", "d");
# data1 = data.frame(k, v1);
# k <- c(2, 3);
# v2 <- c("e", "f");
# data2 = data.frame(k, v2);
#
# merge(data1, data2);

# There might not be a mapping change - tc for every change in the mapping change - rp
# change - rp
# change - tc
# >>>
# change - rp - tc
# change - rp - ??
