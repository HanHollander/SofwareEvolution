review_period <- read.csv(file="../../data/csv/eclipse/dependent/change-review_period.csv",header=TRUE,sep=",")
tenure_change <- read.csv(file="../../data/csv/eclipse/predictor/change-tenure_change.csv",header=TRUE,sep=",")
tenure_review <- read.csv(file="../../data/csv/eclipse/predictor/change-tenure_review.csv",header=TRUE,sep=",")
tenure_approval_blocking <- read.csv(file="../../data/csv/eclipse/predictor/change-tenure_approval_blocking.csv",header=TRUE,sep=",")
activity_change <- read.csv(file="../../data/csv/eclipse/predictor/change-activity_change.csv",header=TRUE,sep=",")
activity_review <- read.csv(file="../../data/csv/eclipse/predictor/change-activity_review.csv",header=TRUE,sep=",")
activity_approval_blocking <- read.csv(file="../../data/csv/eclipse/predictor/change-activity_approval_blocking.csv",header=TRUE,sep=",")


rp_tc <- merge(review_period, tenure_change, by = "ch_changeIdNum")
rp_tr <- merge(review_period, tenure_review, by = "ch_changeIdNum")
rp_tab <- merge(review_period, tenure_approval_blocking, by = "ch_changeIdNum")
rp_ac <- merge(review_period, activity_change, by = "ch_changeIdNum")
rp_ar <- merge(review_period, activity_review, by = "ch_changeIdNum")
rp_aab <- merge(review_period, activity_approval_blocking, by = "ch_changeIdNum")

print(names(rp_ac))
print(names(rp_aab))

boxplot(rp_tc$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    main="Review period of change", log = "y", col = "bisque")

plot(density(rp_tc$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.),
    main="Density Plot: Review period of change", ylab="Frequency", log="x")  # density plot for 'speed'
# polygon(density(rp_tc$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.), col="blue")

plot(x=rp_tc$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_tc$tenure_change,
    main="Review period of change ~ Change (ecosystem) tenure of author",
    type="p",
    log="")  # scatterplot

boxplot(rp_tc$tenure_change,
    main="Change (ecosystem) tenure of author", log = "y", col = "bisque")

plot(density(rp_tc$tenure_change),
    main="Density Plot: Change (ecosystem) tenure of author", ylab="Frequency", log="x")

plot(x=rp_tr$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_tr$tenure_review,
    main="Review period of change ~ Review tenure of author",
    type="p",
    log="")  # scatterplot


plot(x=rp_tab$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_tab$tenure_approval_blocking,
    main="Review period of change ~ Approval/blocking tenure of author",
    type="p",
    log="")  # scatterplot


plot(x=rp_ac$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_ac$c,
    main="Review period of change ~ Change activity of author",
    type="p",
    log="")  # scatterplot


plot(x=rp_ar$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_ar$COUNT.ch_changeIdNum.,
    main="Review period of change ~ Review activity of author",
    type="p",
    log="")  # scatterplot

plot(x=rp_aab$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime.,
    y=rp_aab$COUNT.ch_changeIdNum.,
    main="Review period of change ~ Approval/blocking activity of author",
    type="p",
    log="")  # scatterplot


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
