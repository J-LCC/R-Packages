# ---- ANALISIS DESCRIPTIVO Y VISUALIZACIONES
# ------- SummaryTools --------------

# Provee una forma facil de realizar analisis descriptivo

# Una de las funciones más utiles es dfSummary()
# Con esta función mostramos los estadisticos principales, tipo de dato, valores nulos

# Mostramos un ejemplo con Credit dataset

# Cargamos las librerías necesarias

library(ISLR)
library(summarytools)
library(dplyr)

# Uso de la función dfSummary()

Datos <- Credit %>% select(Ethnicity, Balance, Income, Limit, Rating)

view(dfSummary(Datos))


# Agrupamos con stby() por etnia


stats_por_etnia <- stby(data = Datos,
                           INDICES = Datos$Ethnicity,
                           FUN = descr, stats = "common", transpose = TRUE)

view(stats_por_etnia)

# Limpiamos en entorno de trabajo

rm(list = ls())

# ------------- REACTABLE ----------------------

# Nos permite crear tablas interactivas y realizar varios calculos de agrupación y agregación

library(reactable)
library(ISLR)


Datos <- Credit 


# El paquete nos ofrece una cantidad muy grande de opciones
# Podemos, ordenar por ingresos y añadir una barra de busqueda

reactable(Datos, searchable = TRUE,
          defaultSortOrder = "desc",
          defaultSorted = "Income")

# Y lo más interesante, agregar funciones de agregación
# Por ejemplo, agrupar por etnia y calcular para cada clase, la media de ingresos y balance
# y las frecuencia de las variables categoricas

Datos <- Credit %>% select(Income,Balance,Age,Gender, Student, Married, Ethnicity)


reactable(Datos, groupBy = "Ethnicity", columns = list(
        Income = colDef(aggregate = "mean", format = colFormat(digits = 1)),
        Balance = colDef(aggregate = "mean", format = colFormat(digits = 1)),
        Age = colDef(aggregate = "mean", format = colFormat(digits = 0)),
        Gender = colDef(aggregate = "frequency"),
        Student = colDef(aggregate = "frequency"),
        Married = colDef(aggregate = "frequency")
))


# Limpiamos en entorno de trabajo

rm(list = ls())

# --------------------- Esquisse ------------------------------------

# Es una librería que nos permite crear graficos en una ventana interactiva
# Aunque es limitado, permite un análisis rápido


esquisse::esquisser()

datos <- Credit






# ----- INGENIERÍA DE CARACTERÍSTICAS -----
# ------------------ BORUTA ----------------------

# Boruta nos permite una selección efectiva de variables mediante un algoritmo interactivo
library(Boruta)
library(ISLR)
library(dplyr)

Datos <- Credit %>% select(-ID)


# Ejecutamos Boruta, con doTrace=0, esto controla la cantidad de output mostrado

set.seed(77)
boruta_output <- Boruta(Balance ~., data = Datos, doTrace = 0) 

# El resultado almacena 10 objetos

names(boruta_output)

# Rapidamente podemos ver el resultado graficamente

plot(boruta_output, las = 2, xlab="", main="Variable Importance")

# Vemos que Rating, Income, Limit y Student son las más significativas

boruta_signif <- getSelectedAttributes(boruta_output, withTentative = TRUE)
print(boruta_signif)  

# en attStats se almacena la decisión y el score de cada variable

stats <- attStats(boruta_output)

result <- stats %>%
                select(meanImp, decision) %>%
                arrange(desc(meanImp))

pander::pander(result)


# Limpiamos en entorno de trabajo

rm(list = ls())




# ----------------- mice ----------------------------

# mice realiza multiples imputaciones de NAs
# mice() crea el modelo, dm controla el número de veces que se imputa
# complete() aplica la imputación a los datos

library(mice)
library(ISLR)
library(DMwR)

methods(mice)



# Vamos a usar Credit y asignar unos cuantos valores nulos de forma aleatoria
Datos <- Credit

Datos[sample(1:nrow(Datos), 20), "Income"] <- NA
Datos[sample(1:nrow(Datos), 20), "Age"] <- NA

# Usamos imputación por random forest, estableciendo m a su valor de por defecto 5

miceM <- mice(Datos[, !names(Datos) %in% "Balance"], meth = "rf", m = 5)

miceout <- complete(miceM, 3)

# Evaluamos la calidad de la precisión

actuals <- Credit$Age[is.na(Datos$Age)]
predict <- miceout$Age[is.na(Datos$Age)]

regr.eval(actuals, predict)


# Limpiamos en entorno de trabajo

rm(list = ls())





# ------------- mlr ------------------------

# Cargamos los datos de Boston

library(mlbench)
library(mlr)


# Cargamos los datos
Boston <- BostonHousing2[,-1]

# Creamos una tarea

reg.task <- makeRegrTask(id = "cred", data = Boston, target = "medv")
reg.task

# Con listLearners("regr") listamos los que hay disponibles

listLearners("regr")


# Creamos un learner de regresión basado en lm

reg.learner <- makeLearner("regr.lm")

# Realizamos una selección de las mejores caracteristicas 
# mlr permite esta opción

# Usamos el método del paquete party "party_cforest.importance"
fv <- generateFilterValuesData(reg.task, method = "party_cforest.importance")

filtered.task <- filterFeatures(reg.task, fval = fv, perc = 0.25)
filtered.task

# Entrenamos un modelo lineal simple y extraemos el modelo

mod <- train(reg.learner, filtered.task)

getLearnerModel(mod)

# Realizamos predicciones y vemos el mse

n <- getTaskSize(reg.task)

mod <- train(reg.learner, task = reg.task, subset = seq(1, n, 2))
pred <- predict(mod, task = reg.task, subset = seq(2, n, 2))

performance(pred)

# Esto seria lo más simple que podemos realizar, en la realidad hay que tener en cuenta mas cosas

# Vamos a usar k-fold cross validation para aumentar la precisión
# Funciona como crear un learner, creamos un método de resampling 

rdesc <- makeResampleDesc("CV", iters = 5)
rdesc

r <- resample("regr.lm", filtered.task, rdesc)
