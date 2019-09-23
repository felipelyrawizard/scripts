#Matrix
a <- matrix(1:9, nrow = 3, ncol = 3)
a
x <- matrix(1:9, nrow = 3, dimnames = list(c("X","Y","Z"), c("A","B","C")))
x
colnames(x)
rownames(x)
