test_that("runEISA() runs", {
    cntEx <- readRDS(system.file("extdata", "Fig3abc_GSE33252_rawcounts_exonic.rds", package = "eisaR"))[,-1]
    cntIn <- readRDS(system.file("extdata", "Fig3abc_GSE33252_rawcounts_intronic.rds", package = "eisaR"))[,-1]

    # arguments
    expect_error(runEISA(data.frame("a")))
    expect_error(runEISA(rbind(1:2, 3:4), "b"))
    expect_error(runEISA(rbind(1:2, 3:4), rbind(1:2, 3:4), c("a","b","c")))
    expect_error(runEISA(rbind(1:2, 3:4), rbind(1:2, 3:4), c("a","b")))

    # expected results
    cond <- factor(c("ES","ES","TN","TN"))
    res1 <- runEISA(cntEx, cntIn, cond, method = "published")
    res2 <- runEISA(cntEx, cntIn, cond, method = "new")
    expect_true(is.list(res1))
    expect_true(is.list(res2))
    expect_length(res1, 8L)
    expect_true(all(res1$quantGenes %in% rownames(cntEx)))
    ids <- intersect(res1$quantGenes, res2$quantGenes)
    expect_gt(cor(res1$contrasts[ids,"Dex"], res2$contrasts[ids,"Dex"]), 0.97)
    expect_gt(cor(res1$contrasts[ids,"Din"], res2$contrasts[ids,"Din"]), 0.97)
    expect_gt(cor(res1$contrasts[ids,"Dex.Din"], res2$contrasts[ids,"Dex.Din"]), 0.85)
})