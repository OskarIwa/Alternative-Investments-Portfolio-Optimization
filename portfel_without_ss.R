library(ggplot2)
library(dplyr)
library(lpSolve)
library(fPortfolio)
library(PerformanceAnalytics)

#importing data
portfolio <- read.csv2("portfolio.csv", fill = TRUE)

#portfele z granicy efektywności
dane <- ts(portfolio, start=c(2015, 2), end=c(2025, 10), frequency=12)
data1 <- as.timeSeries(dane)

data1 <- covEstimator(data1)

shortSpec <- portfolioSpec()

setSolver(shortSpec) <- "solveRshortExact"

shortFrontier <- portfolioFrontier(data1, constraints="LongOnly")

weightsPlot(shortFrontier,labels = TRUE, col = NULL)

wyniki_z_granicy <- shortFrontier@portfolio@portfolio

frontier_points <- data.frame(
  Ryzyko = wyniki_z_granicy$targetRisk[, 1],
  Zwrot = wyniki_z_granicy$targetReturn[, 1]
)

frontier_points <- frontier_points[order(frontier_points$Ryzyko), ]

tip_of_curve <- frontier_points[which.min(frontier_points$Ryzyko), ]

min_return_at_tip <- tip_of_curve$Zwrot

frontier_efficient_part <- subset(frontier_points, Zwrot >= min_return_at_tip)

#Variables for all calculations
CD_Projekt_Red <- portfolio$CD_Projekt_Red
kurs_GBP_PLN <- portfolio$kurs_GBP_PLN
Pallad <- portfolio$Pallad
ETF_SP500 <- portfolio$ETF_SP500
#importing weights from file
weights4inv <- read.table("weights4inv.txt",dec=",", header=TRUE, quote="\"",stringsAsFactors=FALSE)
w1 <- weights4inv$W1
w1 <- as.numeric(w1)
w2 <- weights4inv$W2
w2 <- as.numeric(w2)
w3 <- weights4inv$W3
w3 <- as.numeric(w3)
w4 <- weights4inv$W4
w4 <- as.numeric(w4)
#calculating SD
s1 <- sd(CD_Projekt_Red)
s2 <- sd(kurs_GBP_PLN)
s3 <- sd(Pallad)
s4 <- sd(ETF_SP500)
#Calculating corellation
corr12 <- cor(CD_Projekt_Red,kurs_GBP_PLN)
corr13 <- cor(CD_Projekt_Red,Pallad)
corr14 <- cor(CD_Projekt_Red, ETF_SP500)
corr23 <- cor(kurs_GBP_PLN, Pallad)
corr24 <- cor(kurs_GBP_PLN, ETF_SP500)
corr34 <- cor(Pallad, ETF_SP500)
#calculating ip
iportfolio <- mean(CD_Projekt_Red)*w1+mean(kurs_GBP_PLN)*w2+mean(Pallad)*w3+mean(ETF_SP500)*w4
#portfolio risk
sdp <- (w1^2*s1^2 + w2^2*s2^2 + w3^2*s3^2 + w4^2*s4^2 + 2*w1*w2*s1*s2*corr12 + 2*w1*w3*s1*s3*corr13 + 2*w1*w4*s1*s4*corr14 + 
          2*w2*w3*s2*s3*corr23 + 2*w2*w4*s2*s4*corr24 + 2*w3*w4*s3*s4*corr34)^0.5
#calculating effectivness
rf <- mean(CD_Projekt_Red)*0.1
sharp <- (iportfolio-rf)/sdp

#preparing df with results
data <- cbind(w1, w2, w3, w4, iportfolio, sdp, sharp, treynor)
data <- as.data.frame(data)
#finding interesting portfolios
min.risk <- subset(data, data$sdp==min(data$sdp))
max.effectivness <- subset(data, data$sharp==max(data$sharp))
max.ip <- subset(data, data$iportfolio==max(data$iportfolio))
max.w1 <- subset(data, data$w1==1)
max.w2 <- subset(data, data$w2==1)
max.w3 <- subset(data, data$w3==1)
max.w4 <- subset(data, data$w4==1)
simple.div <- subset(data, data$w1==0.25 & data$w2==0.25 & data$w3==0.25 & data$w4==0.25)
des <- c("Minimal risk portfolio", "Maximum efficiency portfolio", "Maximum rate of return portfolio", "Max weight one portfolio", "Max weight two portfolio", "Max weight three portfolio", "Max weight four portfolio", "Simple divesrification portfolio")
#Creating table with results 3 portfolios and showing results in console
results_without_ss <- cbind(rbind(min.risk, max.effectivness, max.ip, max.w1, max.w2, max.w3, max.w4, simple.div), des)
write.csv(x=results_without_ss, file = "results_without_ss.csv", row.names=FALSE)
#tworzenie wykresu
ggplot() +
  geom_point(data=data, aes(x=sdp, y=iportfolio), col="#E69F00") +
  geom_point(data = min.risk, aes(sdp, iportfolio), size = 5, col = "green3") +
  geom_text(data = min.risk, aes(x = sdp, y = iportfolio, label = paste(
    "Minimalne ryzyko",
    paste("Ryzyko:", round(sdp, 3)),
    paste("Stopa zwrotu:", round(iportfolio, 5)),
    paste("Efektywność:", round(sharp, 3)),
    sep = "\n")),
    hjust = 1.3,
    vjust = 1,
    size = 3.5) +
  geom_point(data = max.effectivness, aes(sdp, iportfolio), size = 5, col = "blue") +
  geom_text(
    data = max.effectivness,
    aes(
      x = sdp,
      y = iportfolio,
      label = paste(
        "Max efektywność",
        paste("Ryzyko:", round(sdp, 3)),
        paste("Stopa zwrotu:", round(iportfolio, 5)),
        paste("Efektywność:", round(sharp, 3)),
        sep = "\n")),
    hjust = 1,      
    vjust = -0.5,   
    size = 3.5) +
  geom_point(data = max.w1, aes(sdp, iportfolio), size = 3, col = "black") +
  geom_text(data = max.w1, aes(sdp, iportfolio, label = paste("CD Projekt Red (100%)")), vjust = 1.5, hjust = -0.06, size = 3.5) +
  geom_point(data = max.w2, aes(sdp, iportfolio), size = 3, col = "black") +
  geom_text(data = max.w2, aes(sdp, iportfolio, label = "GBP (100%)"), vjust = 1.5, hjust = -0.06, size = 3.5) +
  geom_point(data = max.w3, aes(sdp, iportfolio), size = 3, col = "black") +
  geom_text(data = max.w3, aes(sdp, iportfolio, label = "Pallad (100%)"), vjust = 1.5, hjust = -0.06, size = 3.5) +
  geom_point(data = max.w4, aes(sdp, iportfolio), size = 3, col = "black") +
  geom_text(data = max.w4, aes(sdp, iportfolio, label = "ETF SP500 (100%)"), vjust = 1.5, hjust = -0.06, size = 3.5) +
  geom_abline(intercept = rf, 
              slope = max.effectivness$sharp, linetype = "dashed", linewidth = 0.8) +
  geom_segment(data = max.effectivness,
               aes(x = 0,  
                   y = rf, 
                   xend = sdp, 
                   yend = iportfolio),
               color = "red", 
               linewidth = 1) +
  annotate("text", x = 0.07, y = 0.021, label = "CML", size = 4.5) +
  geom_point(aes(x = 0, y = rf), size = 5, col = "pink") +
  geom_abline(intercept = rf, 
              slope = min.risk$sharp, linetype = "dotted", linewidth = 0.8) +
  geom_segment(data = min.risk,
               aes(x = 0, 
                   y = rf, 
                   xend = sdp, 
                   yend = iportfolio),
               color = "red", 
               linewidth = 1) +
  annotate("text", x = 0.07, y = -0.002, label = "MR", size = 4.5) +
  annotate("text", x = 0, y = 0.003, label = "RF", size = 4.5) +
  coord_cartesian(xlim = c(0, 0.150), ylim = c(-0.0025, 0.0225)) +
  geom_line(data = frontier_efficient_part, aes(x = Ryzyko, y = Zwrot), color = "purple", linewidth = 1) +
  
  labs(x = "Ryzyko portfela [%]", y = "Stopa zwrotu portfela [%]") +
  theme(
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  )
                  