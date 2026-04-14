library(ggplot2)
#importing data
portfolio <- read.csv2("portfolio.csv", fill=TRUE)
#Variables for all calculations
CDProjektRed <- portfolio$CD_Projekt_Red
GBP <- portfolio$kurs_GBP_PLN
pallad <- portfolio$Pallad
ETFSP500 <- portfolio$ETF_SP500
#importing weights from file
weights4inv <- read.table("weights_4_ss_R.txt",dec=",", header=TRUE, quote="\"",stringsAsFactors=FALSE)
w1 <- as.numeric(weights4inv$W1)
w2 <- as.numeric(weights4inv$W2)
w3 <- as.numeric(weights4inv$W3)
w4 <- as.numeric(weights4inv$W4)
#calculating SD
s1 <- sd(CDProjektRed)
s2 <- sd(GBP)
s3 <- sd(pallad)
s4 <- sd(ETFSP500)
#Calculating corellation
corr12 <- cor(CDProjektRed,GBP)
corr13 <- cor(CDProjektRed,pallad)
corr14 <- cor(CDProjektRed, ETFSP500)
corr23 <- cor(GBP, pallad)
corr24 <- cor(GBP, ETFSP500)
corr34 <- cor(pallad, ETFSP500)
#calculating ip
iportfolio <- mean(CDProjektRed)*w1+mean(GBP)*w2+mean(pallad)*w3+mean(ETFSP500)*w4
#portfolio risk
sdp <- (w1^2*s1^2 + w2^2*s2^2 + w3^2*s3^2 + w4^2*s4^2 + 2*w1*w2*s1*s2*corr12 + 2*w1*w3*s1*s3*corr13 + 2*w1*w4*s1*s4*corr14 + 
          2*w2*w3*s2*s3*corr23 + 2*w2*w4*s2*s4*corr24 + 2*w3*w4*s3*s4*corr34)^0.5
#calculating effectivness
rf <- mean(CDProjektRed)*0.1
sharp <- (iportfolio-rf)/sdp
#preparing df with results
data <- cbind(w1, w2, w3, w4, iportfolio, sdp, sharp, treynor)
data <- as.data.frame(data)
#finding interesting portfolios
min.risk <- subset(data, data$sdp==min(data$sdp))
max.effectivness <- subset(data, data$sharp==max(data$sharp))
max.treynor <- subset(data, data$treynor==max(data$treynor))
max.ip <- subset(data, data$iportfolio==max(data$iportfolio))
max.w1 <- subset(data, data$w1==1 & data$w2==0 & data$w3==0 & data$w4==0)
max.w2 <- subset(data, data$w1==0 & data$w2==1 & data$w3==0 & data$w4==0)
max.w3 <- subset(data, data$w1==0 & data$w2==0 & data$w3==1 & data$w4==0)
max.w4 <- subset(data, data$w1==0 & data$w2==0 & data$w3==0 & data$w4==1)
des <- c("Minimal risk portfolio", "Maximum efficiency portfolio", "Maximum rate of return portfolio", "Max weight one portfolio", "Max weight two portfolio", "Max weight three portfolio", "Max weight four portfolio", "Treynor Ratio")
#Creating table with results 3 portfolios and showing results in console
results_ss <- cbind(rbind(min.risk, max.effectivness, max.ip, max.w1, max.w2, max.w3, max.w4,max.treynor), des)
write.csv(x=results_ss, file = "results_ss.csv", row.names=FALSE)
#creating and saving OS
ggplot() +
  geom_point(data=data, aes(x=sdp, y=iportfolio), col="lightblue") +
  geom_point(data=subset(data, w1 >= 0 & w2 >= 0 & w3 >= 0 & w4 >= 0), 
             aes(x=sdp, y=iportfolio), col="#E69F00", alpha=0.5) +
  geom_point(data = min.risk, aes(sdp, iportfolio), size = 5, col = "green3") +
  geom_text(data = min.risk, aes(x = sdp, y = iportfolio, label = paste(
    "Minimalne ryzyko",
    paste("Ryzyko:", round(sdp, 3)),
    paste("Stopa zwrotu:", round(iportfolio, 5)),
    paste("Efektywność:", round(sharp, 3)),
    sep = "\n")),
    hjust = 1.15,
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
  geom_abline(intercept = rf, 
              slope = max.effectivness$sharp, linetype = "dashed", linewidth = 0.8) +
  geom_abline(intercept = rf, 
              slope = min.risk$sharp, linetype = "dotted", linewidth = 0.8) +
  geom_point(data = max.w1, aes(sdp, iportfolio), size = 3, col = "black") +
  geom_text(data = max.w1, aes(sdp, iportfolio, label = "CD Projekt Red (100%)"), vjust = 1.5, hjust = -0.06, size = 3.5) +
  geom_point(data = max.w2, aes(sdp, iportfolio), size = 3, col = "black") +
  geom_text(data = max.w2, aes(sdp, iportfolio, label = "GBP (100%)"), vjust = 1.5, hjust = -0.06, size = 3.5) +
  geom_point(data = max.w3, aes(sdp, iportfolio), size = 3, col = "black") +
  geom_text(data = max.w3, aes(sdp, iportfolio, label = "Pallad (100%)"), vjust = 1.5, hjust = -0.06, size = 3.5) +
  geom_point(data = max.w4, aes(sdp, iportfolio), size = 3, col = "black") +
  geom_text(data = max.w4, aes(sdp, iportfolio, label = "ETF SP500 (100%)"), vjust = 1.5, hjust = -0.06, size = 3.5) +
  geom_point(aes(x = 0, y = rf), size = 5, col = "pink") +
  coord_cartesian(xlim = c(0, 0.150), ylim = c(-0.0025, 0.0225)) +
  annotate("text", x = 0.07, y = -0.001, label = "MR", size = 4.5) +
  annotate("text", x = 0, y = 0.004, label = "RF", size = 4.5) +
  annotate("text", x = 0.087, y = 0.03, label = "CML", size = 4.5) +
  coord_cartesian(xlim = c(0, 0.170), ylim = c(-0.02, 0.04)) +
  labs(x = "Ryzyko portfela [%]", y = "Stopa zwrotu portfela [%]") +
  theme(
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  )



