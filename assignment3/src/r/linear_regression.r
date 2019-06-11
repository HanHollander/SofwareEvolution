
dependent <- read.csv(file="../../data/csv/eclipse/dependent/change-review_period.csv",header=TRUE,sep=",");

predictor <- read.csv(file="../../data/csv/eclipse/predictor/change-tenure_change.csv",header=TRUE,sep=",");

merged <- merge(dependent, predictor, by = "ch_changeIdNum");
# names(merged)[2];

plot(x=merged$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime., y=merged$tenure_change,
    main="Review period ~ Change (ecosystem) tenure",
    type="p",
    log="")  # scatterplot

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
