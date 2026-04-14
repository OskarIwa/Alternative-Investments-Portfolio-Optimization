portfolio <- read.csv2("Zmiana portfela w czasie/2015-2025.csv", fill = TRUE)

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
data <- cbind(w1, w2, w3, w4, iportfolio, sdp, sharp)
data <- as.data.frame(data)
#finding interesting portfolios
min.risk <- subset(data, data$sdp==min(data$sdp))
max.effectivness <- subset(data, data$sharp==max(data$sharp))
des <- c("Minimal risk portfolio", "Maximum efficiency portfolio")
#Creating table with results 3 portfolios and showing results in console
results <- cbind(rbind(min.risk, max.effectivness), des)
write.csv(x=results, file = "results.csv", row.names=FALSE)