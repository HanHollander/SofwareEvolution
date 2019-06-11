
dependent <- read.csv(file="../../data/csv/eclipse/dependent/change-review_period.csv",header=TRUE,sep=",")

predictor <- read.csv(file="../../data/csv/eclipse/predictor/change-tenure_change.csv",header=TRUE,sep=",")

merged <- merge(dependent, predictor, by = "ch_changeIdNum")
# names(merged)[2]

plot(x=merged$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime., y=merged$tenure_change,
    main="Review period ~ Change (ecosystem) tenure",
    type="p",
    log="")  # scatterplot

merged_nozeros <- merged[apply(merged, 1, function(row) all(row != 0)),]

plot(x=merged_nozeros$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime., y=merged_nozeros$tenure_change,
    main="Review period ~ Change (ecosystem) tenure",
    type="p",
    log="")  # scatterplot

merged_noones <- merged_nozeros[apply(merged_nozeros, 1, function(row) all(row != 0)),]

plot(x=merged_noones$DATEDIFF.hist2.hist_createdTime..hist1.hist_createdTime., y=merged_noones$tenure_change,
    main="Review period ~ Change (ecosystem) tenure",
    type="p",
    log="")

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
