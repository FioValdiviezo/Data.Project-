
---
Governance Indicators   
title: "Trust in Government Index"
author: " Fiorella Valdiviezo"
date: "04 October 2021"
---
## Load Require Packages
options("install.lock"=FALSE)
install.packages("inexact")
library(tidyverse)
library(mice)
library(haven)
library(foreign)
library(readstata13)
library(devtools)
library(GGally)
library(ggcorrplot)
library(plyr)
library(dplyr)  
### Average Governance Scores by Region,
# Import/ Read datasets
setwd("C:/Users/Z50-CORE-I5/Desktop/RSE.project/Poxy of Quality of Institutions/trust/Data")
enaho.2008.PER <- read.dta13("2008.dta",convert.factors=FALSE)
#The following is a proposal for a Trust in Goverment Institutions Index, for which the following variables were considered to be the most relevant in determining the citizens' trust in all civic, public, political and governmental structures. The following variables were measured in Peru .
* `p1_01`: Trust in National Elections Jury   (1=Not at all, 4=A lot)
* `p1_02`: Trust in Elections (1=Not at all, 4=A lot) 
* `p1_03`: Trust in National registry of identification and civil status(1=Not at all, 4=A lot) 
* `p1_04`: Trust in Provincial municipality (1=Not at all, 4=A lot)
* `p1_05`: Trust in Distrital municipality (1=Not at all, 4=A lot)
* `p1_06`: Trust in National Police (1=Not at all, 4=A lot)
* `p1_07`: Trust in Armed Forces (1=Not at all, 4=A lot)
* `p1_08`: Trust in Regional Government (1=Not at all, 4=A lot)
* `p1_09`: Trust in Judicial System (1=Not at all, 4=A lot)
* `p1_10`: Trust in Ministry of Education (1=Not at all, 4=A lot)
* `p1_11`: Trust in Defensor�a del Pueblo (1=Not at all, 4=A lot)
* `p1_12`: Trust in Congress of the republic (1=Not at all, 4=A lot)
* `p1_13`: Trust in Political Parties (1=Not at all, 4=A lot)
* `p10_2`: Respect for equality before the law (1=Not at all, 4=A lot)
* `p10_3`: Respect for Political freedom (1=Not at all, 4=A lot)
* `p10_4`: Respect for transparent elections (1=Not at all, 4=A lot)
##Variables measuring the levels of trust in religious institutions, such as the Catholic and the Protestant Churches, were left out of this proposed index, since they do not partake in the structures of government and political and civil affairs - regardless, of their influence in the citizens' daily lives. 
data.2008 <- enaho.2008.PER[,c('year', 'ubigeo','conglome','vivienda','hogar', 'codperso', 'p1_01', 'p1_02', 'p1_03', 'p1_04', 'p1_05', 'p1_06', 'p1_07', 'p1_08', 'p1_09', 'p1_10', 'p1_11', 'p1_12',
                               'p1_13', 'p10_2', 'p10_3', 'p10_4')]
data.2008 = (na.omit(data.2008))#So, ignoring missing values, we have 12957 rows left

my_data <- data.2008 %>% 
  select(p1_01, p1_02, p1_03, p1_04, p1_05, p1_06, p1_07, p1_08, p1_09, p1_10, p1_11, p1_12,
                   p1_13, p10_2, p10_3, p10_4) %>%  
 mutate_all(as.numeric)

# Correlation between variables
library(ggcorrplot)

corr_lapop <- my_data %>% 
  # calculate correlation matrix and round to 1 decimal place:
  cor(use = "pairwise") %>% 
  round(1)

ggcorrplot(corr_lapop, type = "lower", lab = T, show.legend = F)

#Principal Component Analysis

library(FactoMineR)
pca_1 <- PCA(my_data, graph = F)
summary(pca_1, loadings = T, cutoff = 0.3)#38.5% of variance is contained in the first principal component; the others all appear to be much lower.
fviz_eig(pca_1, choice = "eigenvalue", addlabels = T, ylim = c(0, 3))
eig <- get_eig(pca_1)
eig
#There are three components that give us an Eigenvalue (denoted by the standard deviation) greater than 1. 
#This limit will be our criterion for selecting the components that we will keep.
#The four components (dimensions) accounted for almost 61% of the total variation: the first component 38.5%, 
#the second 8.35%, the third 7.2% and the fourth 6.5%. The next step is to add these four components, but weighing 
#each of them by the percentage of the variance they represent. We do it as follows:
data_pca <- pca_1$ind$coord%>%
  as_tibble() %>%
  mutate(pca_01 = (Dim.1 * 38.5 + Dim.2 * 8.35 + Dim.3 * 7.2 + 
                     Dim.4 * 6.5) / 61)

trust.2008 <- bind_cols(data.2008, data_pca %>% select(pca_01))
###We want our indicator to go from 0 to 1
trust.2008 <- trust.2008 %>%
  mutate(trust_index = GGally::rescale01(pca_01) * 1)%>%
  select(trust_index, everything())
### Graph 
index_density <- ggplot(data = trust.2008,
                        mapping = aes(x = trust_index)) + 
  labs(x=" Trust in Institutions", y = "densidad") +
  geom_density()

index_density 
require(foreign)
write.dta(trust.2008, "Trust.2008.dta")

# Clean the workspace 
keep(trust.2008, sure = TRUE)
###################################################################################
# We follow the same procedure to build the trust index in institutions for 2009
##################################################################################
# 2009 Index 
enaho.2009.PER <- read.dta13("2009.dta",convert.factors=FALSE)
data.2009 <- enaho.2009.PER[,c('year', 'ubigeo','conglome','vivienda','hogar', 'codperso', 'p1_01', 'p1_02', 'p1_03', 'p1_04', 'p1_05', 'p1_06', 'p1_07', 'p1_08', 'p1_09', 'p1_10', 'p1_11', 'p1_12',
                               'p1_13', 'p10_2', 'p10_3', 'p10_4')]
data.2009 <- (na.omit(data.2009))
my_data <- data.2009 %>% 
  select(p1_01, p1_02, p1_03, p1_04, p1_05, p1_06, p1_07, p1_08, p1_09, p1_10, p1_11, p1_12,
         p1_13, p10_2, p10_3, p10_4) %>%  
  mutate_all(as.numeric)
# Correlation between variables
corr_enaho2009 <- my_data %>% 
  # calculate correlation matrix and round to 1 decimal place:
  cor(use = "pairwise") %>% 
  round(1)

ggcorrplot(corr_enaho2009, type = "lower", lab = T, show.legend = F)

#Principal Component Analysis
pca_1 <- PCA(my_data, graph = F)
summary(pca_1, loadings = T, cutoff = 0.3)#38.4% of variance is contained in the first principal component; the others all appear to be much lower.
fviz_eig(pca_1, choice = "eigenvalue", addlabels = T, ylim = c(0, 3))
eig <- get_eig(pca_1)
eig
#The four components (dimensions) accounted for almost 60% of the total variation: the first component 38.4%, 
#the second 8.3%, the third 6.9% and the fourth 6.6%. The next step is to add these four components, but weighing 
#each of them by the percentage of the variance they represent. We do it as follows:

data_pca <- pca_1$ind$coord%>%
  as_tibble() %>%
  mutate(pca_01 = (Dim.1 * 38.4 + Dim.2 * 8.3 + Dim.3 * 6.9 + 
                     Dim.4 * 6.6) / 60)

trust.2009 <- bind_cols(data.2009, data_pca %>% select(pca_01))
###We want our indicator to go from 0 to 1
trust.2009 <- trust.2009 %>%
  mutate(trust_index = GGally::rescale01(pca_01) * 1)%>%
  select(trust_index, everything())
### Graph 
index_density <- ggplot(data = trust.2009,
                        mapping = aes(x = trust_index)) + 
  labs(x=" Trust in Institutions", y = "densidad") +
  geom_density()

index_density 
require(foreign)
write.dta(trust.2009, "Trust.2009.dta")
###################################################################################
# We follow the same procedure to build the trust index in institutions for 2010
##################################################################################
# Clean the workspace 
keep(trust.2009, trust.2008, sure = TRUE)
# 2010 Index 
enaho.2010.PER <- read.dta13("2010.dta",convert.factors=FALSE)
data.2010 <- enaho.2010.PER[,c('year', 'ubigeo','conglome','vivienda','hogar', 'codperso', 'p1_01', 'p1_02', 'p1_03', 'p1_04', 'p1_05', 'p1_06', 'p1_07', 'p1_08', 'p1_09', 'p1_10', 'p1_11', 'p1_12',
                               'p1_13', 'p10_2', 'p10_3', 'p10_4')]
data.2010 <- (na.omit(data.2010))

my_data <- data.2010 %>% 
  select(p1_01, p1_02, p1_03, p1_04, p1_05, p1_06, p1_07, p1_08, p1_09, p1_10, p1_11, p1_12,
         p1_13, p10_2, p10_3, p10_4) %>%  
  mutate_all(as.numeric)
# Correlation between variables
corr_enaho2010 <- my_data %>% 
  # calculate correlation matrix and round to 1 decimal place:
  cor(use = "pairwise") %>% 
  round(1)

ggcorrplot(corr_enaho2010, type = "lower", lab = T, show.legend = F)

#Principal Component Analysis
pca_1 <- PCA(my_data, graph = F)
summary(pca_1, loadings = T, cutoff = 0.3)#38.8% of variance is contained in the first principal component; the others all appear to be much lower.
fviz_eig(pca_1, choice = "eigenvalue", addlabels = T, ylim = c(0, 3))
eig <- get_eig(pca_1)
eig
#The four components (dimensions) accounted for almost 61% of the total variation: the first component 38.5%, 
#the second 8%, the third 7.1% and the fourth 6.6%. The next step is to add these four components, but weighing 
#each of them by the percentage of the variance they represent. We do it as follows:

data_pca <- pca_1$ind$coord%>%
  as_tibble() %>%
  mutate(pca_01 = (Dim.1 * 38.8 + Dim.2 * 8 + Dim.3 * 7.1 + 
                     Dim.4 * 6.6) / 61)

trust.2010 <- bind_cols(data.2010, data_pca %>% select(pca_01))
###We want our indicator to go from 0 to 1
trust.2010 <- trust.2010 %>%
  mutate(trust_index = GGally::rescale01(pca_01) * 1) %>%
  select(trust_index, everything())
### Graph 
index_density <- ggplot(data = trust.2010,
                        mapping = aes(x = trust_index)) + 
  labs(x=" Trust in Institutions", y = "densidad") +
  geom_density()

index_density 
require(foreign)
write.dta(trust.2010, "Trust.2010.dta")
###################################################################################
# We follow the same procedure to build the trust index in institutions for 2011
##################################################################################
# Clean the workspace 
keep(trust.2009, trust.2008, trust.2010, sure = TRUE)
# 2011 Index 
enaho.2011.PER <- read.dta13("2011.dta",convert.factors=FALSE)
data.2011 <- enaho.2011.PER[,c('year', 'ubigeo','conglome','vivienda','hogar', 'codperso', 'p1_01', 'p1_02', 'p1_03', 'p1_04', 'p1_05', 'p1_06', 'p1_07', 'p1_08', 'p1_09', 'p1_10', 'p1_11', 'p1_12',
                               'p1_13', 'p10_2', 'p10_3', 'p10_4')]
data.2011 <- (na.omit(data.2011))

my_data <- data.2011 %>% 
  select(p1_01, p1_02, p1_03, p1_04, p1_05, p1_06, p1_07, p1_08, p1_09, p1_10, p1_11, p1_12,
         p1_13, p10_2, p10_3, p10_4) %>%  
  mutate_all(as.numeric)
# Correlation between variables
corr_enaho2011 <- my_data %>% 
  # calculate correlation matrix and round to 1 decimal place:
  cor(use = "pairwise") %>% 
  round(1)

ggcorrplot(corr_enaho2011, type = "lower", lab = T, show.legend = F)

#Principal Component Analysis
pca_1 <- PCA(my_data, graph = F)
summary(pca_1, loadings = T, cutoff = 0.3)#38.4% of variance is contained in the first principal component; the others all appear to be much lower.
fviz_eig(pca_1, choice = "eigenvalue", addlabels = T, ylim = c(0, 3))
eig <- get_eig(pca_1)
eig
#The four components (dimensions) accounted for almost 60% of the total variation: the first component 38.4%, 
#the second 8%, the third 7.4% and the fourth 6.3%. The next step is to add these four components, but weighing 
#each of them by the percentage of the variance they represent. We do it as follows:
data_pca <- pca_1$ind$coord%>%
  as_tibble() %>%
  mutate(pca_01 = (Dim.1 * 38.4 + Dim.2 * 8 + Dim.3 * 7.4 + 
                     Dim.4 * 6.3) / 60)

trust.2011 <- bind_cols(data.2011, data_pca %>% select(pca_01))

###We want our indicator to go from 0 to 1
trust.2011 <- trust.2011 %>%
  mutate(trust_index = GGally::rescale01(pca_01) * 1)%>%
  select(trust_index, everything())
### Graph 
index_density <- ggplot(data = trust.2011,
                        mapping = aes(x = trust_index)) + 
  labs(x=" Trust in Institutions", y = "densidad") +
  geom_density()

index_density 
require(foreign)
write.dta(trust.2011, "Trust.2011.dta")
###################################################################################
# We follow the same procedure to build the trust index in institutions for 2012
##################################################################################
# Clean the workspace 
keep(trust.2011, trust.2010, trust.2009, sure = TRUE)
# 2012 Index 
enaho.2012.PER <- read.dta13("2012.dta",convert.factors=FALSE)
data.2012 <- enaho.2012.PER[,c('year', 'ubigeo','conglome','vivienda','hogar', 'codperso', 'p1_01', 'p1_02', 'p1_03', 'p1_04', 'p1_05', 'p1_06', 'p1_07', 'p1_08', 'p1_09', 'p1_10', 'p1_11', 'p1_12',
                               'p1_13', 'p10_2', 'p10_3', 'p10_4')]
data.2012 <- (na.omit(data.2012))

my_data <- data.2012 %>% 
  select(p1_01, p1_02, p1_03, p1_04, p1_05, p1_06, p1_07, p1_08, p1_09, p1_10, p1_11, p1_12,
         p1_13, p10_2, p10_3, p10_4) %>%  
  mutate_all(as.numeric)
# Correlation between variables
corr_enaho2012 <- my_data %>% 
  # calculate correlation matrix and round to 1 decimal place:
  cor(use = "pairwise") %>% 
  round(1)

ggcorrplot(corr_enaho2012, type = "lower", lab = T, show.legend = F)

#Principal Component Analysis
pca_1 <- PCA(my_data, graph = F)
summary(pca_1, loadings = T, cutoff = 0.3)#39% of variance is contained in the first principal component; the others all appear to be much lower.
fviz_eig(pca_1, choice = "eigenvalue", addlabels = T, ylim = c(0, 3))
eig <- get_eig(pca_1)
eig
#The four components (dimensions) accounted for almost 61% of the total variation: the first component 39%, 
#the second 8.5%, the third 7.4% and the fourth 6.3%. The next step is to add these four components, but weighing 
#each of them by the percentage of the variance they represent. We do it as follows:
data_pca <- pca_1$ind$coord%>%
  as_tibble() %>%
  mutate(pca_01 = (Dim.1 * 39 + Dim.2 * 8.5 + Dim.3 * 7.4 + 
                     Dim.4 * 6.3) / 61)

trust.2012 <- bind_cols(data.2012, data_pca %>% select(pca_01))
###We want our indicator to go from 0 to 1
trust.2012 <- trust.2012 %>%
  mutate(trust_index = GGally::rescale01(pca_01) * 1)%>%
  select(trust_index, everything())
### Graph 
index_density <- ggplot(data = trust.2012,
                        mapping = aes(x = trust_index)) + 
  labs(x=" Trust in Institutions", y = "densidad") +
  geom_density()

index_density 
require(foreign)
write.dta(trust.2012, "Trust.2012.dta")
###################################################################################
# We follow the same procedure to build the trust index in institutions for 2013
##################################################################################
# Clean the workspace 
keep(trust.2011, trust.2010, trust.2009,trust.2012, sure = TRUE)
# 2013 Index 
enaho.2013.PER <- read.dta13("2013.dta",convert.factors=FALSE)
data.2013 <- enaho.2013.PER[,c('year', 'ubigeo','conglome','vivienda','hogar', 'codperso', 'p1_01', 'p1_02', 'p1_03', 'p1_04', 'p1_05', 'p1_06', 'p1_07', 'p1_08', 'p1_09', 'p1_10', 'p1_11', 'p1_12',
                               'p1_13', 'p10_2', 'p10_3', 'p10_4')]
data.2013 <- (na.omit(data.2013))

my_data <- data.2013 %>% 
  select(p1_01, p1_02, p1_03, p1_04, p1_05, p1_06, p1_07, p1_08, p1_09, p1_10, p1_11, p1_12,
         p1_13, p10_2, p10_3, p10_4) %>%  
  mutate_all(as.numeric)
# Correlation between variables
corr_enaho2013 <- my_data %>% 
  # calculate correlation matrix and round to 1 decimal place:
  cor(use = "pairwise") %>% 
  round(1)

ggcorrplot(corr_enaho2013, type = "lower", lab = T, show.legend = F)

#Principal Component Analysis
pca_1 <- PCA(my_data, graph = F)
summary(pca_1, loadings = T, cutoff = 0.3)#38.2% of variance is contained in the first principal component; the others all appear to be much lower.
fviz_eig(pca_1, choice = "eigenvalue", addlabels = T, ylim = c(0, 3))
eig <- get_eig(pca_1)
eig
#The four components (dimensions) accounted for almost 61% of the total variation: the first component 38.2%, 
#the second 8.2%, the third 7.6% and the fourth 6.4%. The next step is to add these four components, but weighing 
#each of them by the percentage of the variance they represent. We do it as follows:
data_pca <- pca_1$ind$coord%>%
  as_tibble() %>%
  mutate(pca_01 = (Dim.1 * 38.2 + Dim.2 * 8.2 + Dim.3 * 7.6 + 
                     Dim.4 * 6.4) / 61)

trust.2013 <- bind_cols(data.2013, data_pca %>% select(pca_01))
###We want our indicator to go from 0 to 1
trust.2013 <- trust.2013 %>%
  mutate(trust_index = GGally::rescale01(pca_01) * 1)%>%
  select(trust_index, everything())
### Graph 
index_density <- ggplot(data = trust.2013,
                        mapping = aes(x = trust_index)) + 
  labs(x=" Trust in Institutions", y = "densidad") +
  geom_density()

index_density 
require(foreign)
write.dta(trust.2013, "Trust.2013.dta")
###################################################################################
# We follow the same procedure to build the trust index in institutions for 2014
##################################################################################
# Clean the workspace 
keep(trust.2011, trust.2010, trust.2009,trust.2012, trust.2013, sure = TRUE)
# 2014 Index 
enaho.2014.PER <- read.dta13("2014.dta",convert.factors=FALSE)
data.2014 <- enaho.2014.PER[,c('year', 'ubigeo','conglome','vivienda','hogar', 'codperso', 'p1_01', 'p1_02', 'p1_03', 'p1_04', 'p1_05', 'p1_06', 'p1_07', 'p1_08', 'p1_09', 'p1_10', 'p1_11', 'p1_12',
                               'p1_13', 'p10_2', 'p10_3', 'p10_4')]
data.2014 <- (na.omit(data.2014))

my_data <- data.2014 %>% 
  select(p1_01, p1_02, p1_03, p1_04, p1_05, p1_06, p1_07, p1_08, p1_09, p1_10, p1_11, p1_12,
         p1_13, p10_2, p10_3, p10_4) %>%  
  mutate_all(as.numeric)
# Correlation between variables
corr_enaho2014 <- my_data %>% 
  # calculate correlation matrix and round to 1 decimal place:
  cor(use = "pairwise") %>% 
  round(1)

ggcorrplot(corr_enaho2014, type = "lower", lab = T, show.legend = F)

#Principal Component Analysis
pca_1 <- PCA(my_data, graph = F)
summary(pca_1, loadings = T, cutoff = 0.3)#38.2% of variance is contained in the first principal component; the others all appear to be much lower.
fviz_eig(pca_1, choice = "eigenvalue", addlabels = T, ylim = c(0, 3))
eig <- get_eig(pca_1)
eig
#The four components (dimensions) accounted for almost 61% of the total variation: the first component 38.1%, 
#the second 8.6%, the third 7.6% and the fourth 6.7%. The next step is to add these four components, but weighing 
#each of them by the percentage of the variance they represent. We do it as follows:
data_pca <- pca_1$ind$coord%>%
  as_tibble() %>%
  mutate(pca_01 = (Dim.1 * 38.1 + Dim.2 * 8.6 + Dim.3 * 7.6 + 
                     Dim.4 * 6.7) / 61)

trust.2014 <- bind_cols(data.2014, data_pca %>% select(pca_01))
###We want our indicator to go from 0 to 1
trust.2014 <- trust.2014 %>%
  mutate(trust_index = GGally::rescale01(pca_01) * 1)%>%
  select(trust_index, everything())
### Graph 
index_density <- ggplot(data = trust.2014,
                        mapping = aes(x = trust_index)) + 
  labs(x=" Trust in Institutions", y = "densidad") +
  geom_density()

index_density 
require(foreign)
write.dta(trust.2014, "Trust.2014.dta")

# Clean Workspace 
keep(trust.2011, trust.2010, trust.2009, trust.2008, trust.2012, trust.2013, trust.2014, sure = TRUE)

###################################################################################
# We follow the same procedure to build the trust index in institutions for 2014
##################################################################################

trust.trends <- rbind(trust.2008,trust.2009, trust.2010,trust.2011,trust.2012, trust.2013,
                      trust.2014)

require(foreign)
write.dta(trust.trends, "TrustinGoverment.dta")


