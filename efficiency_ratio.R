library(PerformanceAnalytics)
library(xts)

portfolio <- read.csv2("stzwr_wig.csv", fill = TRUE)

CD_Projekt_Red <- portfolio$CDPR
kurs_GBP_PLN <- portfolio$GBPPLN
Pallad <- portfolio$Pallad
ETF_SP500 <- portfolio$ETFSP500
WIG_20 <- portfolio$WIG20

#wagi portfela o największej efektywności według Sharpe
w1 <- 0.2
w2 <- 0
w3 <- 0.06
w4 <- 0.74

rf <- 0.1*mean(CD_Projekt_Red)

s1 <- sd(CD_Projekt_Red)
s2 <- sd(kurs_GBP_PLN)
s3 <- sd(Pallad)
s4 <- sd(ETF_SP500)

corr12 <- cor(CD_Projekt_Red,kurs_GBP_PLN)
corr13 <- cor(CD_Projekt_Red,Pallad)
corr14 <- cor(CD_Projekt_Red, ETF_SP500)
corr23 <- cor(kurs_GBP_PLN, Pallad)
corr24 <- cor(kurs_GBP_PLN, ETF_SP500)
corr34 <- cor(Pallad, ETF_SP500)

iportfolio <- CD_Projekt_Red*w1+kurs_GBP_PLN*w2+Pallad*w3+ETF_SP500*w4
sdp <- (w1^2*s1^2 + w2^2*s2^2 + w3^2*s3^2 + w4^2*s4^2 + 2*w1*w2*s1*s2*corr12 + 2*w1*w3*s1*s3*corr13 + 2*w1*w4*s1*s4*corr14 + 
          2*w2*w3*s2*s3*corr23 + 2*w2*w4*s2*s4*corr24 + 2*w3*w4*s3*s4*corr34)^0.5

dates <- seq(as.Date("2015-02-28"), by = "month", length.out = length(iportfolio))
iportfolio_xts <- xts(iportfolio, order.by = dates)
WIG_20_xts <- xts(WIG_20, order.by = dates)

treynor <- TreynorRatio(iportfolio_xts, WIG_20_xts, Rf = rf)
omega <- Omega(iportfolio_xts, L = rf)
sharpeannualized <- SharpeRatio.annualized(iportfolio_xts, Rf = rf)
jensen_alpha <- CAPM.alpha(iportfolio_xts, WIG_20_xts, Rf = rf)
information <- InformationRatio(iportfolio_xts, WIG_20_xts)
sortino <- SortinoRatio(iportfolio_xts, MAR = rf)
modigliani <- Modigliani(iportfolio_xts, WIG_20_xts, Rf = rf)
burke <- BurkeRatio(iportfolio_xts, Rf = rf, modified = FALSE)
drowdown <- maxDrawdown(iportfolio_xts)
calmar <- CalmarRatio(iportfolio_xts)

data_efficiencyRatio <- rbind(treynor, omega, sharpeannualized, jensen_alpha, information, sortino, modigliani, burke, drowdown, calmar)
write.csv(x=data_efficiencyRatio, file = "efficiencyRatio.csv", row.names=FALSE)