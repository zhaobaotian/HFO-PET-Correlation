library(lme4)
library(dplyr)
library(ggplot2)
library(ggeffects)  # install the package first if you haven't already, then load it
library(performance)

setwd("C:/Users/THIENC/Desktop/CC-Linear-mixed-models-master")
rm(list = ls())

qHFOT4PET = read.csv('qHFOT4PETFull2.csv')
##### quick evaluate
# model 1
mixed.lmer <- lmer(qHFOincludedFull ~ PETincludedFull + (1 |CaseID), data = qHFOT4PET)
summary(mixed.lmer)

mixed.ranslope <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope)

model_performance(mixed.lmer)
model_performance(mixed.ranslope)

xVar = data.frame(qHFOT4PET$PETincludedFull)
Ypred = predict(mixed.lmer)
plot(Ypred,qHFOT4PET$qHFOincludedFull)
cor.test(Ypred, qHFOT4PET$qHFOincludedFull, method=c("pearson", "kendall", "spearman"))

Ypred2 = predict(mixed.ranslope)
plot(Ypred2,qHFOT4PET$qHFOincludedFull)
cor.test(Ypred2, qHFOT4PET$qHFOincludedFull, method=c("pearson", "kendall", "spearman"))

#--------------------------- model 2
# mixed.lmer <- lmer(qHFOFRincludedFull ~ PETincludedFull + (1 |CaseID), data = qHFOT4PET)
# summary(mixed.lmer)

mixed.ranslope <- lmer(qHFOFRincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope)

model_performance(mixed.ranslope)

# xVar = data.frame(qHFOT4PET$PETincludedFull)
# Ypred = predict(mixed.lmer)
# plot(Ypred,qHFOT4PET$qHFOFRincludedFull)
# cor.test(Ypred, qHFOT4PET$qHFOFRincludedFull, method=c("pearson", "kendall", "spearman"))

Ypred2 = predict(mixed.ranslope)
plot(Ypred2,qHFOT4PET$qHFOFRincludedFull)
cor.test(Ypred2, qHFOT4PET$qHFOFRincludedFull, method=c("pearson", "kendall", "spearman"))


#--------------------------- model 3
# mixed.lmer <- lmer(qHFOFRincludedFull ~ PETincludedFull + (1 |CaseID), data = qHFOT4PET)
# summary(mixed.lmer)

mixed.ranslope <- lmer(qHFOlatincludedFull * qHFOFRincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope)

model_performance(mixed.ranslope)

Ypred2 = predict(mixed.ranslope)
plot(Ypred2,qHFOT4PET$qHFOFRincludedFull)
cor.test(Ypred2, qHFOT4PET$qHFOFRincludedFull, method=c("pearson", "kendall", "spearman"))




####### for the plots

boxplot(qHFOincludedFull ~ qHFOT4PET$AnonymousID, data = qHFOT4PET)

ggplot(qHFOT4PET, aes(x = PETincludedFull, y = qHFOincludedFull, colour = CaseID))+
  geom_point(size = 2)+
  theme_classic()+
  theme(legend.position = "none")

mixed.ranslope <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope)



# Extract the prediction data frame
pred.mm <- ggpredict(mixed.ranslope, terms = c("PETincludedFull"))  # this gives overall predictions for the model

# Plot the predictions 

(ggplot(pred.mm) + 
    geom_line(aes(x = x, y = predicted)) +          # slope
    geom_ribbon(aes(x = x, ymin = predicted - std.error, ymax = predicted + std.error), 
                fill = "lightgrey", alpha = 0.5) +  # error band
    geom_point(data = qHFOT4PET,                      # adding the raw data (scaled values)
               aes(x = PETincludedFull, y = qHFOincludedFull, colour = CaseID)) + 
    labs(x = "PET T (indexed)", y = "HFO", 
         title = "PET predicts HFO") + 
    theme_minimal()
)


(mm_plot <- ggplot(qHFOT4PET, aes(x = PETincludedFull, y = qHFOincludedFull)) +
    facet_wrap(~qHFOT4PET$CaseID, nrow=5) +   # a panel for each mountain range
    geom_point(alpha = 0.3,size = 1) +
    theme_minimal() +
    geom_line(data = cbind(qHFOT4PET, pred = predict(mixed.ranslope)), aes(y = pred), size = 1) +  # adding predicted line from mixed model 
    theme(legend.position = "none",
          panel.spacing = unit(1, "lines")) + 
    labs(x = "PET (T value)", y = "HFO (log counts)", title = "PET versus HFO")  # adding space between panels
)


################### HFOFR
mixed.ranslope2 <- lmer(qHFOFRincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope2)
(mm_plot <- ggplot(qHFOT4PET, aes(x = PETincludedFull, y = qHFOFRincludedFull)) +
    facet_wrap(~qHFOT4PET$CaseID, nrow=5) +   # a panel for each mountain range
    geom_point(alpha = 0.3,size = 1) +
    theme_minimal() +
    geom_line(data = cbind(qHFOT4PET, pred = predict(mixed.ranslope2)), aes(y = pred), size = 1) +  # adding predicted line from mixed model 
    theme(legend.position = "none",
          panel.spacing = unit(1, "lines")) + 
    labs(x = "PET (T value)", y = "HFOFR (log counts)", title = "PET versus HFOFR")  # adding space between panels
)


###############################

library(stargazer)

stargazer(mixed.lmer, type = "text",
          digits = 3,
          star.cutoffs = c(0.05, 0.01, 0.001),
          digit.separator = "")


full.lmer <- lmer(qHFOincludedFull ~ PETincludedFull + (1+ PETincludedFull|CaseID), 
                  data = qHFOT4PET, REML = FALSE)
reduced.lmer <- lmer(qHFOincludedFull ~ 1 + (1+ PETincludedFull|CaseID), 
                     data = qHFOT4PET, REML = FALSE)
anova(reduced.lmer, full.lmer)


r2(mixed.lmer)
model_performance(mixed.lmer)

model_performance(mixed.ranslope)



xVar = data.frame(qHFOT4PET$PETincludedFull)
Ypred = predict(mixed.lmer)

plot(Ypred,qHFOT4PET$HFOincludedFull)

basic.lm2 <- lm(qHFOT4PET$HFOincludedFull ~ Ypred)
summary(basic.lm2)


cor.test(Ypred, qHFOT4PET$HFOincludedFull, method=c("pearson", "kendall", "spearman"))

#####################
Ypred2 = predict(mixed.ranslope)

plot(Ypred2,qHFOT4PET$HFOincludedFull)

basic.lm3 <- lm(qHFOT4PET$HFOincludedFull ~ Ypred2)
summary(basic.lm3)


cor.test(Ypred2, qHFOT4PET$HFOincludedFull, method=c("pearson", "kendall", "spearman"))





