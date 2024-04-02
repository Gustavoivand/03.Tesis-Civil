setwd("D:/03.Gits/03.Tesis Civil/01.Avance 1")
#Leyendo los datos
data<-read.csv("dataset.csv")
str(data)
#Función para normalizar los datos
normalize <-function(x){
  
  return((x-min(x))/(max(x)-min(x)))
  
}
#Normalizando los datos
data_norm <- as.data.frame(lapply(data, normalize))
#Histograma de deflexiones normalizado
hist(data_norm$D,col = "red")
#comparación entre datos reales y normalizados
summary(data_norm$D)
summary(data$D)

#Comparación de correlaciones entre datos normalizados
library(psych)
pairs.panels(data_norm)

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
mlg=lm(D ~ z + t,data=data_train)
#resultados del modelo
summary(mlg)

#predicciones con el modelo creado usando los datos de prueba
predicted_mlg = predict(mlg,newdata = data_test)
#coeficiente de correlación del modelo
cor(predicted_mlg, data_test$D)
#Grafica de predicciones vs resultados esperados
dev.off()
plot(predicted_mlg, data_test$D)



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
