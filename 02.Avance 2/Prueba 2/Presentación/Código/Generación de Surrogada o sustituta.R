setwd("D:/03.Gits/03.Tesis Civil/02.Avance 2/Prueba 2/Presentación/Código")
#Leyendo los datos
data<-read.csv("dataset.csv")
str(data)
#Función para normalizar los datos
normalize <-function(x){
  
  return((x-min(x))/(max(x)-min(x)))
  
}


library(dplyr)
df_new <- data %>% mutate(across(c('Drift'), round, 3))
df_filtrado <- data %>% filter(Drift==0.005) 
df_
D_Target<-(0.005-min(data[1]))/(max(data[1])-min(data[1]))

#Normalizando los datos
data_norm <- as.data.frame(lapply(data, normalize))
#Histograma de masas normalizado
hist(data_norm$MasaPropia,col = "red")
#comparación entre datos reales y normalizados
summary(data_norm$MasaPropia)
summary(data$MasaPropia)

#Histograma de drifts Normalizado
hist(data_norm$Drift,col = "red")
#comparación entre datos reales y normalizados
summary(data_norm$Drift)
summary(data$Drift)

#Correlación de Drift vs columnas
library(psych)
pairs.panels(data_norm[1:5])

#Correlación de Drift vs vigas
library(psych)
pairs.panels(data_norm[c(1,6,7,8,9)])

#Correlación de Masa, algún elemento
library(psych)
pairs.panels(data_norm[c(10,2)])

#Correlación de Masa, Drift
library(psych)
pairs.panels(data_norm[c(10,1)])

#Creación de datos de entrenamiento y de prueba
p<-0.75
set.seed(123)
inTraining <- sample.int(n = nrow(data_norm),
                         size = floor(p * nrow(data_norm)), 
                         replace = FALSE)
data_train <- data_norm[inTraining, ]
data_test <- data_norm[-inTraining, ]

#comparación entre datos de entrenamiento y prueba
head(data_train)
head(data_test)

#Creacion del modelo de regresion multilineal

mlg=lm(MasaPropia ~ pc1+pc2+pc3+pc4+pv1+pv2+pv3+pv4,data=data_train)#+pc1+pc2+pc3+pc4+pv1+pv2+pv3+pv4
#resultados del modelo
summary(mlg)

#predicciones con el modelo creado usando los datos de prueba
predicted_mlg = predict(mlg,newdata = data_test)
#coeficiente de correlación del modelo
cor(predicted_mlg, data_test$MasaPropia)
#Grafica de predicciones vs resultados esperados
dev.off()
plot(predicted_mlg, data_test$MasaPropia)

r<-.73#.73
q<-1#1
m<-.7#.7
mlg2=lm(Drift ~ I(pc1^(r))+I(pc2^(r))+I(pc3^(r))+I(pc4^(r))+I(pv1^(q))+I(pv2^(m))+I(pv3^(q))+I(pv4^(m)),data=data_train)#+pc1+pc2+pc3+pc4+pv1+pv2+pv3+pv4
#resultados del modelo
summary(mlg2)

#predicciones con el modelo creado usando los datos de prueba
predicted_mlg2 = predict(mlg2,newdata = data_test)
#coeficiente de correlación del modelo
cor(predicted_mlg2, data_test$Drift)
#Grafica de predicciones vs resultados esperados
dev.off()
plot(predicted_mlg2, data_test$Drift)










#Construccion de la red neuronal
library(neuralnet)
set.seed(123) 

data_model<-neuralnet(formula = D ~ z + t,
                      data = data_train)

#Plot de data_model con args
plot(data_model, rep="best")

#Plot de data_model sin args
library(NeuralNetTools)
par(mar = numeric(4), family = 'serif')
plotnet(data_model, alpha=0.6)

#Predicciones de la red neuronal usando los datos de prueba
model_results<-compute(data_model, data_test[2:3])

#quedandonos con los resultados de las predicciones
predicted_Dev<-model_results$net.result  

#Correlacion entre los valores predichos y los valores esperados de la red neuronal
cor(predicted_Dev, data_test$D)
dev.off()
plot(predicted_Dev, data_test$D)
