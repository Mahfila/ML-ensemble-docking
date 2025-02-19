# ShapiroWilks test to evaluate the normality distribution
# of the performance of each of the SBVS methods from the 30x4cv analysis
# n = 120 (120 validation sets)

library(rstatix)
library(ggpubr)
library(tidyr)
library(tidyverse)
library(dplyr)
library(ez)
library(xtable)

# REPEAT THIS ANALYSIS PER METRIC AND PER PROTEIN

do_SW_test <- function(csv_file, 
                        metric_colname = 'roc_auc') { 
    #' @description A simple function to apply the `shapiro_test`  
    #'              to the performances (ROC-AUC or NEF) of each SBVS method 
    #'
    
    df = read.csv(csv_file, header = TRUE)
    df = df %>%
        filter(X == metric_colname) %>%
    select(-X.1, -X)

    # Melting the data
    df_melt <- df  %>%
        mutate(rep = factor(1:nrow(.))) %>%
        pivot_longer(cols  = c(everything(), -rep), 
                 names_to  = 'VS_method', 
                 values_to = 'score')

    df_melt %>%
        group_by(VS_method) %>%
        shapiro_test(score)
}

# ====================
# Perform the analysis
# ====================

# CDK2
cdk2_file = '../cdk2/5_Machine_Learning/cv30x4_cdk2.csv'
## ROC
res.shapiro.cdk2.roc <- do_SW_test(csv_file = cdk2_file, 
                                    metric_colname = 'roc_auc')
## NEF
res.shapiro.cdk2.nef <- do_SW_test(csv_file = cdk2_file, 
                                    metric_colname = 'nef_Ra')

# FXa
fxa_file = '../fxa/5_Machine_Learning/cv30x4_fxa.csv'
## ROC
res.shapiro.fxa.roc <- do_SW_test(csv_file = fxa_file, 
                                   metric_colname = 'roc_auc')
## NEF
res.shapiro.fxa.nef <- do_SW_test(csv_file = fxa_file, 
                                   metric_colname = 'nef_Ra')

# EGFR
egfr_file = '../egfr/5_Machine_Learning/cv30x4_egfr.csv'
## ROC
res.shapiro.egfr.roc <- do_SW_test(csv_file = egfr_file, 
                                    metric_colname = 'roc_auc')
## NEF
res.shapiro.egfr.nef <- do_SW_test(csv_file = egfr_file, 
                                    metric_colname = 'nef_Ra')

# HSP90
hsp90_file = '../hsp90/5_Machine_Learning/cv30x4_hsp90.csv'
## ROC
res.shapiro.hsp90.roc <- do_SW_test(csv_file = hsp90_file, 
                                     metric_colname = 'roc_auc')
## NEF
res.shapiro.hsp90.nef <- do_SW_test(csv_file = hsp90_file, 
                                     metric_colname = 'nef_Ra')


# Gather the results in a single table
results <- list(
  res.shapiro.cdk2.roc,  res.shapiro.cdk2.nef,
  res.shapiro.fxa.roc,   res.shapiro.fxa.nef,
  res.shapiro.egfr.roc,  res.shapiro.egfr.nef,
  res.shapiro.hsp90.roc, res.shapiro.hsp90.nef
)
protein_names <- rep(c('cdk2', 'fxa', 'egfr', 'hsp90'),
                     each = 2)
method_names <- rep(c('AUC-ROC', 'NEF'), 4)

tab_res <- c()  
for (res in results) {
  tab_res <- rbind(tab_res, round(t(res[3:4]), 3))
}
colnames(tab_res) <- t(results[[1]][1])

# Add column names
cbind(protein_names, method_names, tab_res)

# Print the latex table
xtable(
  tab_res
)

# Citation
citation('rstatix')
citation('tidyverse')




