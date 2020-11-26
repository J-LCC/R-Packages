# Paquetes de R para la ciencia de datos

R es un ecosistema gigantesco, el cual aloja cientos y cientos de librerías para una cantidad enorme de propósitos. En este extenso documento, os quiero traer algunas de las librerías más útiles y no muy conocidas, para que realices un análisis de tus datos de una forma **eficiente, sencilla y con una fantástica presentación**. Las librerías se dividen por apartados según su propósito y la mayoría usarán el mismo data.frame de ejemplo, Credit del paquete ISLR.

![Captura](https://user-images.githubusercontent.com/54073772/100348219-ea034b00-2fe6-11eb-8190-7a7d54218022.PNG)

## Tabla de contenidos

- [Análisis descriptivo](#análisis-descriptivo)
  * [SummaryTools](#summarytools)
  * [Reactable](#reactable)
  * [Esquisse](#esquisse)
- [Ingeniería de características](#ingeniería-de-características)
  * [Boruta](#boruta)


## Análisis descriptivo y visualización

### SummaryTools

```r
library(ISLR)
library(summarytools)
library(dplyr)

# Seleccionamos algunas columnas 
Datos <- Credit %>% select(Ethnicity, Balance, Income, Limit, Rating)
view(dfSummary(Datos))
```

### Reactable

### Esquisse


## Ingeniería de características 

### Boruta
