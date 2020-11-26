# Paquetes de R para la ciencia de datos

R es un ecosistema gigantesco, el cual aloja cientos y cientos de librerías para una cantidad enorme de propósitos. En este extenso documento, os quiero traer algunas de las librerías más útiles y no muy conocidas, para que realices un análisis de tus datos de una forma **eficiente, sencilla y con una fantástica presentación**. Las librerías se dividen por apartados según su propósito y la mayoría usarán el mismo data.frame de ejemplo, Credit del paquete ISLR.

![Captura](https://user-images.githubusercontent.com/54073772/100348219-ea034b00-2fe6-11eb-8190-7a7d54218022.PNG)

## Tabla de contenidos

- [Análisis descriptivo y visualización](#análisis-descriptivo-y-visualización)
  * [SummaryTools](#summarytools)
  * [Reactable](#reactable)
  * [Esquisse](#esquisse)
- [Ingeniería de características](#ingeniería-de-características)
  * [Boruta](#boruta)


## Análisis descriptivo y visualización

El tratamiento inicial de los datos y su correcta compresión es uno de los pasos más importantes dentro de un estudio de ciencia de datos. Por ello, es muy necesario valerse de librerías que nos **permitan la mejor compresión inicial en los datos.**

### SummaryTools

Ofrece un conjunto coherente de funciones centradas en la exploración de datos y la presentación de informes sencillos. Aunque tiene varias funcionalidades, os quiero mostrar la que me ha parecido más interesante, ``dfSummary()``

Esta función nos permite visualizar las variables alojadas en un dataframe, mostrando:
-	El tipo de dato (Character, Integer, Numeric…) y su frecuencia.
-	Estadísticos (Media, Mediana, IQR).
-	Gráficos de distribución.
-	Valores nulos

A modo de ejemplo vamos a usar el dataset Credit del paquete ISLR. Esta base de datos de ejemplo incluye 10000 observaciones sobre clientes con diversas variables como los ingresos, balance, genero, etnia, etc.

```r
library(ISLR)
library(summarytools)
library(dplyr)

# Seleccionamos algunas columnas 
Datos <- Credit %>% select(Ethnicity, Balance, Income, Limit, Rating)
view(dfSummary(Datos))
```

El código de arriba nos muestra el siguiente resultado:

![Capture](https://user-images.githubusercontent.com/54073772/100373237-be925780-300a-11eb-8eda-7b1be1c9a8b8.png)

Otra función muy útil es agrupar los estadísticos en torno a una categoría que seleccionemos. Utilizamos stby(), donde podemos usar varios parámetros:
-	``INDICES = Datos$Ethnicity`` agrupa en torno a la variable que le pasemos.
-	``FUN = descr`` calcula los estadísticos principales.
-	``Stats = “common”`` muestra los estadísticos calculados más comunes.
-	``transpose = TRUE`` para trasponer los resultados.


```r
stats_by_ethnicity <- stby(data = Datos,
                           INDICES = Datos$Ethnicity,
                           FUN = descr, stats = "common", transpose = TRUE)
view(stats_by_ethnicity)
```

![2](https://user-images.githubusercontent.com/54073772/100369372-19c14b80-3005-11eb-928a-8aabfc7bd807.png)

La librería ha sido desarrollada por Dominic Comtois, puedes consultar todas sus funcionalidades en el siguiente link: 

https://cran.r-project.org/web/packages/summarytools/vignettes/Introduction.html#descr


### Reactable

El paquete reactable nos permite crear tablas interactivas con una cantidad increíble de personalización. Nos permite filtrar, ordenar, agrupar, crear medidas de agregación, etc. A modo de ejemplo, volvemos a usar el dataset Credit de ISLR para mostrar un par de funcionalidades (en su web oficial podemos consultar una gran cantidad de funciones).

Convertimos toda el dataset en una tabla con ``reactable()`` y añadimos un par de opciones, que aparezca una barra de búsqueda y ordenar de forma descendente los ingresos.

```r
library(reactable)
Datos <- Credit 
reactable(Datos, searchable = TRUE,
          defaultSortOrder = "desc",
          defaultSorted = "Income")
```
![Captura](https://user-images.githubusercontent.com/54073772/100374079-082f7200-300c-11eb-8918-83d1730ca65e.PNG)

Este segundo ejemplo es más interesante, ya que, con la librería, podemos agrupar y crear medidas de agregación con los datos. Un ejemplo sería agrupar por etnia y añadir la media de ingresos, balance y edad, así como las frecuencias para género, estudiante o casado.
```r
Datos <- Credit %>% select(Income, Balance, Age, Gender, Student, Married, Ethnicity)

reactable(Datos, groupBy = "Ethnicity", columns = list(
        Income = colDef(aggregate = "mean", format = colFormat(digits = 1)),
        Balance = colDef(aggregate = "mean", format = colFormat(digits = 1)),
        Age = colDef(aggregate = "mean", format = colFormat(digits = 0)),
        Gender = colDef(aggregate = "frequency"),
        Student = colDef(aggregate = "frequency"),
        Married = colDef(aggregate = "frequency")
))
```



### Esquisse


## Ingeniería de características 

### Boruta
