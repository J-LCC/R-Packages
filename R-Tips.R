# ---- ANALISIS DESCRIPTIVO Y VISUALIZACIONES
# ------- SummaryTools --------------

# Provee una forma facil de realizar analisis descriptivo

# Una de las funciones más utiles es dfSummary()
# Con esta función mostramos los estadisticos principales, tipo de dato, valores nulos

# Mostramos un ejemplo con Defaul dataset

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


Datos <- Credit 


# El paquete nos ofrece una cantidad muy grande de opciones
# Podemos, ordenar por ingresos y añadir una barra de busqueda

reactable(Datos, searchable = TRUE,
          defaultSortOrder = "desc",
          defaultSorted = "Income")

# Y lo más interesante, agregar funciones de agregación

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

#install.packages("esquisse")


esquisse::esquisser()

datos <- Credit






# ----- INGENIERÍA DE CARACTERÍSTICAS -----
# ------------------ BORUTA ----------------------

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





