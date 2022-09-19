library(lme4)
library(dplyr)
library(ggplot2)
library(ggeffects)  # install the package first if you haven't already, then load it
library(performance)

setwd("C:/Users/THIENC/Desktop/CC-Linear-mixed-models-master")
rm(list = ls())

## case correlation example 35guihaifeng TLE
qHFOT4PET = read.csv('case35guihaifengCorr.csv')


## figure 3 A
p = ggplot(qHFOT4PET, aes(x=PETincluded, y=qHFOincluded)) + 
  geom_point()+
  geom_smooth(method=lm)+
  labs(title="PET versus HFO",
       x="PET T value", y = "HFO counts (log)")+
  theme_classic()  

p + scale_color_brewer(palette="Accent") + theme_minimal()

ggsave("Case35GHFPETHFO.pdf", width = 3, height = 3, units = "in")

cor.test(qHFOT4PET$PETincluded, qHFOT4PET$qHFOincluded, method=c("pearson"))

## figure 3 B
p = ggplot(qHFOT4PET, aes(x=PETincluded, y=qHFOFRincluded)) + 
  geom_point()+
  geom_smooth(method=lm)+
  labs(title="PET versus HFOFR",
       x="PET T value", y = "HFOFR counts (log)")+
  theme_classic()

p + scale_color_brewer(palette="Accent") + theme_minimal()

ggsave("Case35GHFPETHFOFR.pdf", width = 3, height = 3, units = "in")

cor.test(qHFOT4PET$PETincluded, qHFOT4PET$qHFOFRincluded, method=c("pearson"))

################## figure 3 C the bar plot of p and r
rm(list = ls())

RP32 = read.csv('GroupCorrRPrplot.csv')

# The r bars
# Change the colors manually
p <- ggplot(data=RP32, aes(x=CaseID, y=rVal,fill=GroupInd)) +
  geom_bar(stat="identity", color="black", position=position_dodge(),size=0.2)+
  theme_bw()
# Use custom colors
p + scale_fill_manual(values=c('#999999','#E69F00'))
# Use brewer color palettes
p + scale_fill_brewer(palette="Paired") + 
  labs(title="Individual correlation coefficients", x="Cases", y = "r value")+
  scale_x_continuous(limits=c(0, 33),breaks=seq(1,32,1)) + 
  scale_y_continuous(limits=c(-1, 0.45)) + 
  theme(axis.text = element_text(size = 15),axis.title = element_text(size = 20),plot.title = element_text(size = 20)) 
  

ggsave("GroupRP.pdf", width = 15, height = 6, units = "in")


###################figure3 box paird fisherz ##############
library(ggpubr)
rm(list = ls())

fisherZ = read.csv('fisherzHFO_HFOFR.csv')

ggpaired(fisherZ, cond1 = "fisherzHFO", cond2 = "fisherzHFOFR",
         fill = "condition", palette = "Blues",line.color = "gray", line.size = 0.4) + theme_minimal()


ggsave("fisherzHFO_HFOFR.pdf", width = 5, height = 3, units = "in")


################### figure 4 linear mixed effct model and prediction#####
rm(list = ls())

qHFOT4PET = read.csv('qHFOT4PETFullfinal.csv')

################## model 1 HFO
mixed.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope1)

model_performance(mixed.ranslope1)


# significance test
full.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
reduced.ranslope1 <- lmer(qHFOincludedFull ~ 1 + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
anova(reduced.ranslope1, full.ranslope1)

# plot the lme model
# Extract the prediction data frame
pred.mm <- ggpredict(mixed.ranslope1, terms = c("PETincludedFull"))  # this gives overall predictions for the model

# Plot the predictions 

p = ggplot(pred.mm) + 
    geom_line(aes(x = x, y = predicted)) +          # slope
    geom_ribbon(aes(x = x, ymin = predicted - std.error, ymax = predicted + std.error), 
                fill = "lightgrey", alpha = 0.5) +  # error band
    geom_point(data = qHFOT4PET,                      # adding the raw data (scaled values)
               aes(x = PETincludedFull, y = qHFOincludedFull, colour = CaseID),size = 1) + 
    labs(x = "PET T values", y = "HFO counts (log10)", 
         title = "PET HFO linear mixed model") + 
    theme_minimal()

p + theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))


ggsave("lmePETHFO.pdf", width = 11, height = 6, units = "in")


Ypred1 = predict(mixed.ranslope1)
plot(Ypred1,qHFOT4PET$qHFOincludedFull)
cor.test(Ypred1, qHFOT4PET$qHFOincludedFull, method=c("pearson"))

realqHFO = qHFOT4PET$qHFOincludedFull;
predct1 = data.frame(Ypred1,realqHFO);



p = ggplot(predct1, aes(x=Ypred1, y=realqHFO)) + 
  geom_point(size = 1,colour = 'gray30')+
  geom_smooth(method=lm)+
  labs(title="Predictor: PET T values",
       x="Predicted HFO counts (log10)", y = "Real HFO counts (log10)")

p + scale_color_brewer(palette="Accent") + theme_minimal() + 
  theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))

ggsave("PredictVSrealHFO.pdf", width = 8, height = 6, units = "in")

################## model 2 HFOFR
mixed.ranslope2 <- lmer(qHFOFRincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope2)

model_performance(mixed.ranslope2)

# significance test
full.ranslope2 <- lmer(qHFOFRincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
reduced.ranslope2 <- lmer(qHFOFRincludedFull ~ 1 + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
anova(reduced.ranslope2, full.ranslope2)

# plot the lme model
# Extract the prediction data frame
pred.mm2 <- ggpredict(mixed.ranslope2, terms = c("PETincludedFull"))  # this gives overall predictions for the model

# Plot the predictions 

p = ggplot(pred.mm2) + 
  geom_line(aes(x = x, y = predicted)) +          # slope
  geom_ribbon(aes(x = x, ymin = predicted - std.error, ymax = predicted + std.error), 
              fill = "lightgrey", alpha = 0.5) +  # error band
  geom_point(data = qHFOT4PET,                      # adding the raw data (scaled values)
             aes(x = PETincludedFull, y = qHFOFRincludedFull, colour = CaseID),size = 1) + 
  labs(x = "PET T values", y = "HFOFR counts (log10)", 
       title = "PET HFOFR linear mixed model") + 
  theme_minimal()

p + theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))


ggsave("lmePETHFOFR.pdf", width = 11, height = 6, units = "in")


Ypred2 = predict(mixed.ranslope2)
plot(Ypred2,qHFOT4PET$qHFOFRincludedFull)
cor.test(Ypred2, qHFOT4PET$qHFOFRincludedFull, method=c("pearson"))

realqHFOFR = qHFOT4PET$qHFOFRincludedFull;
predct2 = data.frame(Ypred2,realqHFO);



p = ggplot(predct1, aes(x=Ypred1, y=realqHFOFR)) + 
  geom_point(size = 1,colour = 'gray30')+
  geom_smooth(method=lm)+
  labs(title="Predictor: PET T values",
       x="Predicted HFOFR counts (log10)", y = "Real HFOFR counts (log10)")

p + scale_color_brewer(palette="Accent") + theme_minimal() + 
  theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))

ggsave("PredictVSrealHFOFR.pdf", width = 8, height = 6, units = "in")


####### The boxplot between free and nonfree fisher z ######
rm(list = ls())

fisherZ = read.csv('fisherzFreeNonfree.csv')

p <- ggplot(fisherZ, aes(x=Labels, y=fisherZs,fill=Labels)) + 
  geom_boxplot() 

p + geom_dotplot(binaxis='y', stackdir='center', dotsize=1,fill = 'gray') + 
  scale_fill_manual(values=c("#67a9cf", "#ef8a62")) + theme_minimal() + 
  labs(title="Fisher z seizure free versus non-free",
       x="Groups", y = "Fisher z")

ggsave("fisherzFreeNonfree.pdf", width = 4, height = 3, units = "in")



############# model the TEL group

rm(list = ls())

TLEFR = read.csv('TLEHFOFR.csv')
PETincludedFull = TLEFR$PETincludedTLE
qHFOincludedFull = TLEFR$qHFOFRincludedTLE
CaseID = TLEFR$CaseIDTLE

qHFOT4PET = data.frame(PETincludedFull,qHFOincludedFull,CaseID)

################## LME model
mixed.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope1)

model_performance(mixed.ranslope1)


# significance test
full.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
reduced.ranslope1 <- lmer(qHFOincludedFull ~ 1 + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
anova(reduced.ranslope1, full.ranslope1)

# plot the lme model
# Extract the prediction data frame
pred.mm <- ggpredict(mixed.ranslope1, terms = c("PETincludedFull"))  # this gives overall predictions for the model

# Plot the predictions 

p = ggplot(pred.mm) + 
  geom_line(aes(x = x, y = predicted)) +          # slope
  geom_ribbon(aes(x = x, ymin = predicted - std.error, ymax = predicted + std.error), 
              fill = "lightgrey", alpha = 0.5) +  # error band
  geom_point(data = qHFOT4PET,                      # adding the raw data (scaled values)
             aes(x = PETincludedFull, y = qHFOincludedFull, colour = CaseID),size = 1) + 
  labs(x = "PET T values", y = "HFOFR counts (log10)", 
       title = "TLE: PET HFOFR LME") + 
  theme_minimal()

p + theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))


ggsave("TLElmePETHFOFR.pdf", width = 8, height = 6, units = "in")


Ypred1 = predict(mixed.ranslope1)
plot(Ypred1,qHFOT4PET$qHFOincludedFull)
cor.test(Ypred1, qHFOT4PET$qHFOincludedFull, method=c("pearson"))

realqHFO = qHFOT4PET$qHFOincludedFull;
predct1 = data.frame(Ypred1,realqHFO);



p = ggplot(predct1, aes(x=Ypred1, y=realqHFO)) + 
  geom_point(size = 1,colour = 'gray30')+
  geom_smooth(method=lm)+
  labs(title="Predictor: PET T values (TLE)",
       x="Predicted HFOFR counts (log10)", y = "Real HFOFR counts (log10)")

p + scale_color_brewer(palette="Accent") + theme_minimal() + 
  theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))

ggsave("PredictVSrealTLEHFOFR.pdf", width = 8, height = 6, units = "in")


#### model the extra TLE group

rm(list = ls())

eTLEFR = read.csv('eTLEHFOFR.csv')
PETincludedFull = eTLEFR$PETincludedeTLE
qHFOincludedFull = eTLEFR$qHFOFRincludedeTLE
CaseID = eTLEFR$CaseIDeTLE

qHFOT4PET = data.frame(PETincludedFull,qHFOincludedFull,CaseID)

################## LME model
mixed.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope1)

model_performance(mixed.ranslope1)


# significance test
full.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
reduced.ranslope1 <- lmer(qHFOincludedFull ~ 1 + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
anova(reduced.ranslope1, full.ranslope1)

# plot the lme model
# Extract the prediction data frame
pred.mm <- ggpredict(mixed.ranslope1, terms = c("PETincludedFull"))  # this gives overall predictions for the model

# Plot the predictions

p = ggplot(pred.mm) + 
  geom_line(aes(x = x, y = predicted)) +          # slope
  geom_ribbon(aes(x = x, ymin = predicted - std.error, ymax = predicted + std.error), 
              fill = "lightgrey", alpha = 0.5) +  # error band
  geom_point(data = qHFOT4PET,                      # adding the raw data (scaled values)
             aes(x = PETincludedFull, y = qHFOincludedFull, colour = CaseID),size = 1) + 
  labs(x = "PET T values", y = "HFOFR counts (log10)", 
       title = "eTLE: PET HFOFR LME") + 
  theme_minimal()

p + theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))


ggsave("eTLElmePETHFOFR.pdf", width = 8, height = 6, units = "in")


Ypred1 = predict(mixed.ranslope1)
plot(Ypred1,qHFOT4PET$qHFOincludedFull)
cor.test(Ypred1, qHFOT4PET$qHFOincludedFull, method=c("pearson"))

realqHFO = qHFOT4PET$qHFOincludedFull;
predct1 = data.frame(Ypred1,realqHFO);



p = ggplot(predct1, aes(x=Ypred1, y=realqHFO)) + 
  geom_point(size = 1,colour = 'gray30')+
  geom_smooth(method=lm)+
  labs(title="Predictor: PET T values (eTLE)",
       x="Predicted HFOFR counts (log10)", y = "Real HFOFR counts (log10)")

p + scale_color_brewer(palette="Accent") + theme_minimal() + 
  theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))

ggsave("PredictVSrealeTLEHFOFR.pdf", width = 8, height = 6, units = "in")


############## For awake LME

rm(list = ls())

eTLEFR = read.csv('awakesleepHFOFR.csv')
PETincludedFull = eTLEFR$PETincludedFull
qHFOincludedFull = eTLEFR$qHFOFRincludedAwake
CaseID = eTLEFR$CaseID

qHFOT4PET = data.frame(PETincludedFull,qHFOincludedFull,CaseID)

################## LME model
mixed.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope1)

model_performance(mixed.ranslope1)


# significance test
full.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
reduced.ranslope1 <- lmer(qHFOincludedFull ~ 1 + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
anova(reduced.ranslope1, full.ranslope1)

# plot the lme model
# Extract the prediction data frame
pred.mm <- ggpredict(mixed.ranslope1, terms = c("PETincludedFull"))  # this gives overall predictions for the model

# Plot the predictions

p = ggplot(pred.mm) + 
  geom_line(aes(x = x, y = predicted)) +          # slope
  geom_ribbon(aes(x = x, ymin = predicted - std.error, ymax = predicted + std.error), 
              fill = "lightgrey", alpha = 0.5) +  # error band
  geom_point(data = qHFOT4PET,                      # adding the raw data (scaled values)
             aes(x = PETincludedFull, y = qHFOincludedFull, colour = CaseID),size = 1) + 
  labs(x = "PET T values", y = "HFOFR counts (log10)", 
       title = "Awake: PET HFOFR LME") + 
  theme_minimal()

p + theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))


ggsave("lmePETHFOFRawake.pdf", width = 9.5, height = 6, units = "in")


Ypred1 = predict(mixed.ranslope1)
plot(Ypred1,qHFOT4PET$qHFOincludedFull)
cor.test(Ypred1, qHFOT4PET$qHFOincludedFull, method=c("pearson"))

realqHFO = qHFOT4PET$qHFOincludedFull;
predct1 = data.frame(Ypred1,realqHFO);



p = ggplot(predct1, aes(x=Ypred1, y=realqHFO)) + 
  geom_point(size = 1,colour = 'gray30')+
  geom_smooth(method=lm)+
  labs(title="Predictor: PET T values (awake)",
       x="Predicted HFOFR counts (log10)", y = "Real HFOFR counts (log10)")

p + scale_color_brewer(palette="Accent") + theme_minimal() + 
  theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))

ggsave("PredictVSrealeHFOFRawake.pdf", width = 8, height = 6, units = "in")


################ For sleep LME
rm(list = ls())

eTLEFR = read.csv('awakesleepHFOFR.csv')
PETincludedFull = eTLEFR$PETincludedFull
qHFOincludedFull = eTLEFR$qHFOFRincludedeSleep
CaseID = eTLEFR$CaseID

qHFOT4PET = data.frame(PETincludedFull,qHFOincludedFull,CaseID)

################## LME model
mixed.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope1)

model_performance(mixed.ranslope1)


# significance test
full.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
reduced.ranslope1 <- lmer(qHFOincludedFull ~ 1 + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
anova(reduced.ranslope1, full.ranslope1)

# plot the lme model
# Extract the prediction data frame
pred.mm <- ggpredict(mixed.ranslope1, terms = c("PETincludedFull"))  # this gives overall predictions for the model

# Plot the predictions

p = ggplot(pred.mm) + 
  geom_line(aes(x = x, y = predicted)) +          # slope
  geom_ribbon(aes(x = x, ymin = predicted - std.error, ymax = predicted + std.error), 
              fill = "lightgrey", alpha = 0.5) +  # error band
  geom_point(data = qHFOT4PET,                      # adding the raw data (scaled values)
             aes(x = PETincludedFull, y = qHFOincludedFull, colour = CaseID),size = 1) + 
  labs(x = "PET T values", y = "HFOFR counts (log10)", 
       title = "Sleep: PET HFOFR LME") + 
  theme_minimal()

p + theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))


ggsave("lmePETHFOFRsleep.pdf", width = 9.5, height = 6, units = "in")


Ypred1 = predict(mixed.ranslope1)
plot(Ypred1,qHFOT4PET$qHFOincludedFull)
cor.test(Ypred1, qHFOT4PET$qHFOincludedFull, method=c("pearson"))

realqHFO = qHFOT4PET$qHFOincludedFull;
predct1 = data.frame(Ypred1,realqHFO);



p = ggplot(predct1, aes(x=Ypred1, y=realqHFO)) + 
  geom_point(size = 1,colour = 'gray30')+
  geom_smooth(method=lm)+
  labs(title="Predictor: PET T values (sleep)",
       x="Predicted HFOFR counts (log10)", y = "Real HFOFR counts (log10)")

p + scale_color_brewer(palette="Accent") + theme_minimal() + 
  theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))

ggsave("PredictVSrealeHFOFRsleep.pdf", width = 8, height = 6, units = "in")

############################# HFO and HFOFR between awake and sleep
library(ggpubr)
rm(list = ls())

fisherZ = read.csv('HFOHFOFRawakesleep.csv')

ggpaired(fisherZ, cond1 = "HFOawake", cond2 = "HFOsleep",
         fill = "condition", palette = "Blues",line.color = "gray", line.size = 0.4) + theme_minimal()


ggsave("HFOawakeSleep.pdf", width = 5, height = 3, units = "in")

t.test(x = fisherZ$HFOawake,y = fisherZ$HFOsleep,paired = TRUE)

# HFOFR

ggpaired(fisherZ, cond1 = "HFOFRawake", cond2 = "HFOFRsleep",
         fill = "condition", palette = "Blues",line.color = "gray", line.size = 0.4) + theme_minimal()


ggsave("HFOFRawakeSleep.pdf", width = 5, height = 3, units = "in")

t.test(x = fisherZ$HFOFRawake,y = fisherZ$HFOFRsleep,paired = TRUE)


################################################# addtional analysis suggested by Aileen

############# model the HS+FCD group

rm(list = ls())

TLEFR = read.csv('HSFCDHFOFR.csv')
PETincludedFull = TLEFR$PETincludedTLE
qHFOincludedFull = TLEFR$qHFOFRincludedTLE
CaseID = TLEFR$CaseIDTLE

qHFOT4PET = data.frame(PETincludedFull,qHFOincludedFull,CaseID)

################## LME model
mixed.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope1)

model_performance(mixed.ranslope1)


# significance test
full.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
reduced.ranslope1 <- lmer(qHFOincludedFull ~ 1 + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
anova(reduced.ranslope1, full.ranslope1)

# plot the lme model
# Extract the prediction data frame
pred.mm <- ggpredict(mixed.ranslope1, terms = c("PETincludedFull"))  # this gives overall predictions for the model

# Plot the predictions 

p = ggplot(pred.mm) + 
  geom_line(aes(x = x, y = predicted)) +          # slope
  geom_ribbon(aes(x = x, ymin = predicted - std.error, ymax = predicted + std.error), 
              fill = "lightgrey", alpha = 0.5) +  # error band
  geom_point(data = qHFOT4PET,                      # adding the raw data (scaled values)
             aes(x = PETincludedFull, y = qHFOincludedFull, colour = CaseID),size = 1) + 
  labs(x = "PET T values", y = "HFOFR counts (log10)", 
       title = "HS + FCD IIa/b: PET HFOFR LME") + 
  theme_minimal()

p + theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))


ggsave("HSFCDlmePETHFOFR.pdf", width = 8, height = 6, units = "in")


Ypred1 = predict(mixed.ranslope1)
plot(Ypred1,qHFOT4PET$qHFOincludedFull)
cor.test(Ypred1, qHFOT4PET$qHFOincludedFull, method=c("pearson"))

realqHFO = qHFOT4PET$qHFOincludedFull;
predct1 = data.frame(Ypred1,realqHFO);



p = ggplot(predct1, aes(x=Ypred1, y=realqHFO)) + 
  geom_point(size = 1,colour = 'gray30')+
  geom_smooth(method=lm)+
  labs(title="Predictor: PET T values (TLE)",
       x="Predicted HFOFR counts (log10)", y = "Real HFOFR counts (log10)")

p + scale_color_brewer(palette="Accent") + theme_minimal() + 
  theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))

ggsave("PredictVSreal-HSFCD-HFOFR.pdf", width = 8, height = 6, units = "in")


#### model the other patients group

rm(list = ls())

eTLEFR = read.csv('otherPathHFOFR.csv')
PETincludedFull = eTLEFR$PETincludedeTLE
qHFOincludedFull = eTLEFR$qHFOFRincludedeTLE
CaseID = eTLEFR$CaseIDeTLE

qHFOT4PET = data.frame(PETincludedFull,qHFOincludedFull,CaseID)

################## LME model
mixed.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET)
summary(mixed.ranslope1)

model_performance(mixed.ranslope1)


# significance test
full.ranslope1 <- lmer(qHFOincludedFull ~ PETincludedFull + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
reduced.ranslope1 <- lmer(qHFOincludedFull ~ 1 + (1 + PETincludedFull|CaseID), data = qHFOT4PET, REML = FALSE)
anova(reduced.ranslope1, full.ranslope1)

# plot the lme model
# Extract the prediction data frame
pred.mm <- ggpredict(mixed.ranslope1, terms = c("PETincludedFull"))  # this gives overall predictions for the model

# Plot the predictions

p = ggplot(pred.mm) + 
  geom_line(aes(x = x, y = predicted)) +          # slope
  geom_ribbon(aes(x = x, ymin = predicted - std.error, ymax = predicted + std.error), 
              fill = "lightgrey", alpha = 0.5) +  # error band
  geom_point(data = qHFOT4PET,                      # adding the raw data (scaled values)
             aes(x = PETincludedFull, y = qHFOincludedFull, colour = CaseID),size = 1) + 
  labs(x = "PET T values", y = "HFOFR counts (log10)", 
       title = "other: PET HFOFR LME") + 
  theme_minimal()

p + theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))


ggsave("otherPatholmePETHFOFR.pdf", width = 8, height = 6, units = "in")


Ypred1 = predict(mixed.ranslope1)
plot(Ypred1,qHFOT4PET$qHFOincludedFull)
cor.test(Ypred1, qHFOT4PET$qHFOincludedFull, method=c("pearson"))

realqHFO = qHFOT4PET$qHFOincludedFull;
predct1 = data.frame(Ypred1,realqHFO);



p = ggplot(predct1, aes(x=Ypred1, y=realqHFO)) + 
  geom_point(size = 1,colour = 'gray30')+
  geom_smooth(method=lm)+
  labs(title="Predictor: PET T values (eTLE)",
       x="Predicted HFOFR counts (log10)", y = "Real HFOFR counts (log10)")

p + scale_color_brewer(palette="Accent") + theme_minimal() + 
  theme(axis.text = element_text(size = 20),axis.title = element_text(size = 25),plot.title = element_text(size = 25))

ggsave("PredictVSreal-other-HFOFR.pdf", width = 8, height = 6, units = "in")






