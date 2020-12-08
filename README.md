R es un ecosistema gigantesco, el cual aloja cientos y cientos de librerías para una cantidad enorme de propósitos. En este extenso documento, os quiero traer algunas de las librerías más útiles y no muy conocidas, para que realices un análisis de tus datos de una forma **eficiente, sencilla y con una fantástica presentación**. Las librerías se dividen por apartados según su propósito y la mayoría usarán el mismo data.frame de ejemplo, ``Credit`` del paquete ``ISLR``.

{EN CONSTRUCCIÓN}

![Captura](https://user-images.githubusercontent.com/54073772/101477538-a3e7a900-394f-11eb-80c7-e2ed0f2a8ebc.PNG)

## Tabla de contenidos

- [Análisis descriptivo y visualización](#análisis-descriptivo-y-visualización)
  * [SummaryTools](#summarytools)
  * [Reactable](#reactable)
  * [Esquisse](#esquisse)
- [Ingeniería de características](#ingeniería-de-características)
  * [Boruta](#boruta)
  * [Mice](#mice)
- [Machine Learning](#machine-learning)
  * [Mlr](#mlr)


# Análisis descriptivo y visualización

El tratamiento inicial de los datos y su correcta compresión es uno de los pasos más importantes dentro de un estudio de ciencia de datos. Por ello, es muy necesario valerse de librerías que nos **permitan la mejor compresión inicial en los datos.**

## SummaryTools

Ofrece un conjunto coherente de funciones centradas en la exploración de datos y la presentación de informes sencillos. Aunque tiene varias funcionalidades, os quiero mostrar la que me ha parecido más interesante, ``dfSummary()``

Esta función nos permite visualizar las variables alojadas en un dataframe, mostrando:
-	El tipo de dato (Character, Integer, Numeric…) y su frecuencia.
-	Estadísticos (Media, Mediana, IQR).
-	Gráficos de distribución.
-	Valores nulos

A modo de ejemplo vamos a usar el dataset ``Credit`` del paquete ``ISLR``. Esta base de datos de ejemplo incluye 10000 observaciones sobre clientes con diversas variables como los ingresos, balance, genero, etnia, etc.

```r
library(ISLR)
library(summarytools)
library(dplyr)

# Seleccionamos algunas columnas 
Datos <- Credit %>% select(Ethnicity, Balance, Income, Limit, Rating)
view(dfSummary(Datos))
```

El código de arriba nos muestra el siguiente resultado:

![Captura](https://user-images.githubusercontent.com/54073772/100374735-031ef280-300d-11eb-8d1b-c0f52f287281.PNG)

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

[Documentación acerca de SummaryTools](https://cran.r-project.org/web/packages/summarytools/vignettes/Introduction.html)


## Reactable

El paquete reactable nos permite crear tablas interactivas con una cantidad increíble de personalización. Nos permite filtrar, ordenar, agrupar, crear medidas de agregación, etc. A modo de ejemplo, volvemos a usar el dataset ``Credit`` de ``ISLR`` para mostrar un par de funcionalidades (en su web oficial podemos consultar una gran cantidad de funciones).

Convertimos toda el dataset en una tabla con ``reactable()`` y añadimos un par de opciones, que aparezca una barra de búsqueda y ordenar de forma descendente los ingresos.

```r
library(reactable)
Datos <- Credit 
reactable(Datos, searchable = TRUE,
          defaultSortOrder = "desc",
          defaultSorted = "Income")
```
![Captura](https://user-images.githubusercontent.com/54073772/100374079-082f7200-300c-11eb-8918-83d1730ca65e.PNG)

Este segundo ejemplo es más interesante, ya que, con la librería, podemos agrupar y crear medidas de agregación con los datos. Un ejemplo sería **agrupar por etnia y añadir la media de ingresos, balance y edad, así como las frecuencias para género, estudiante o casado.**
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
![1](https://user-images.githubusercontent.com/54073772/100375296-db7c5a00-300d-11eb-9212-c3f5f832ca6a.gif)

La librería ha sido desarrollada por Greg Lin y puedes consultar toda la información en el siguiente link:

[Documentación acerca de Reactable](https://glin.github.io/reactable/index.html)

## Esquisse

**¿Te imaginas poder crear visualizaciones como en Tableau pero en R?** El paquete Esquisse implementa un formato sencillo de crear gráficos de “arrastrar y soltar” para un mapeo rápido de tus variables.
Es extremadamente sencillo de usar y muy practico si queremos realizar un análisis rápido. OJO porque es muy limitado y sus opciones se quedan algo cortas. Sin embargo, para alguien que busque mostrar visualizaciones rápidamente sin tener que escribir código puede llegar a darle un entendimiento inicial muy útil.

La forma de acceder es muy sencilla:
```r
library(esquisse)
esquisser()
```
Esto nos lleva a la siguiente ventana:

![3](https://user-images.githubusercontent.com/54073772/100375991-061ae280-300f-11eb-8280-f28402220bf0.gif)

Donde tendremos que seleccionar un data.frame cargado en el espacio de trabajo. En nuestro caso, seleccionamos el habitual Credit de ISLR.

Ahora, simplemente arrastramos las variables a su casilla correspondiente según como lo queremos visualizar. A modo de ejemplo, vamos a crear un histograma, mostrando los Ingresos por Etnia, y por género.

![2](https://user-images.githubusercontent.com/54073772/100376243-76c1ff00-300f-11eb-930c-6af695b485c1.gif)

Esquisse ha sido desarrollado por Fanny Meyer, puedes consultar sobre el paquete en el siguiente link:

[Documentación sobre Esquisse](https://dreamrs.github.io/esquisse/index.html)

# Ingeniería de características 

El segundo paso importante dentro de un trabajo de ciencia de datos es conocer en profundidad nuestras variables, tratarlas en el caso de que existan valores nulos, atípicos, etc y por último seleccionar aquellas que sean significativas. 

## Boruta

Boruta es un algoritmo de selección de características basado en Random Forest. Esto tiene la ventaja de decidir claramente que variables son las más importantes de cara a producir un modelo más preciso, evitando añadir ruido o variables inútiles. Por su parte, *Random Forest* es un algoritmo denominado en inglés “ensemble algorithms”, estos algoritmos combinan múltiples modelos para crear predicciones más potentes, aunque también significa aumentar el coste computacional. 

**¿Cómo funciona Boruta?** Boruta compara de forma iterativa la importancia de los atributos con la importancia de unos atributos de “sombra” que son creados a partir de los originales. Aquellos atributos que son significativamente peores que las sombras son consecutivamente eliminados y reciben la calificación de Rejected. Por otras parte, aquellos que si son significativos reciben la calificación de Confirmed. Por último, también pueden recibir la calificación de Tentative, pero, **¿qué es Tentative?** Recibirán esta calificación cuando las variables tengan una importancia tan cercana a sus mejores rasgos de sombra que Boruta no será capaz de tomar una decisión con la confianza deseada en el número predeterminado de ejecuciones de Random Forest.

Podemos variar los parámetros ``maxRuns`` o ``pValue`` para clarificar cuales variables son tentativas y decidir finalmente si se rechazan o se confirman, en algunos casos su importancia fluctúa demasiado como para que converja Boruta. En su lugar, puede utilizar la función ``TentativeRoughFix``, que realizará otra prueba más débil para tomar una decisión final, o simplemente tratarlos como indecisos en un análisis posterior.

Para mostrar el funcionamiento del paquete y como estamos acostumbrados a usar el paquete Credit, vamos a volver a usarlos para seleccionar las mejores características que expliquen el comportamiento de la variable de respuesta Balance.

```r
library(Boruta)

Datos <- Credit %>% select(-ID)
```
Usamos ``Boruta()`` para realizar la selección de características, pudiendo variar algunos parámetros según nuestras necesidades, algunos son:

-	``maxRuns``: Número máximo de ejecuciones que realiza el algoritmo. Cuanto más alto el maxRuns, más selectivo es en la elección de las variables. El valor por defecto es 100.
-	``pValue``: nivel de confianza, por defecto es 0.01
-	``doTrace``: Nivel de verbosidad. Controla la cantidad de salida impresa en la consola. Cuanto más alto sea el valor, más detalles de registro obtendrá. Varía entre 0 y 2. 

```r
boruta_output <- Boruta(Balance ~., data = Datos, doTrace = 0)
names(boruta_output)
```
Hemos almacenado el resultado en boruta_output, el cual almacena varios objetos como “finalDecision” el cual muestra el resultado final para cada variable, en tres estados: Rejected - Confirmed - Tentative 

La mejor forma de ver el resultado es gráficamente, pudiendo usar ``plot()`` y llamando al objeto boruta para mostrar el resultado:
```r
plot(boruta_output, cex.axis=.7, xlab="", main="Variable Importance")
```

![1](https://user-images.githubusercontent.com/54073772/100378542-9c510780-3013-11eb-9b3e-b85888e9329e.png)

Como bien decíamos al principio, Boruta crea una variable Shadow a partir de las variables originales para calificar la importancia de estas. Aquellas variables que superan shadowMax reciben la calificación de Confirmed.

Y como bien vemos, estas variables son Rating, Income, Limit y Student. Age también entraría, aunque por poco. 

Importance es la calificación de cada variable, cuanto más alto es el valor, mayor importancia y por tanto mayor relación con la variable de respuesta. Este valor está basado en el Z-Score dado por Random Forest.

Igualmente, con ``getSelectedAttributes`` y ``withTentative = TRUE`` seleccionamos las variables significativas.
```r
boruta_signif <- getSelectedAttributes(boruta_output, withTentative = TRUE)
print(boruta_signif)
```

[1] "Income"  "Limit"   "Rating"  "Age"     "Student"

En ``attStats`` se almacenan los scores de las variables, así como la decisión tomada, para cada una de las variables. meanlmp es la media de puntuación que ha recibido cada variable en el Z-Score.
```r
stats <- attStats(boruta_output)
result <- stats %>%
                select(meanImp, decision) %>%
                arrange(desc(meanImp))
pander::pander(result)
```

![Captura](https://user-images.githubusercontent.com/54073772/100618129-b3e20600-331b-11eb-9055-f1c2b21465b9.PNG)

El elevado valor del Z-Score nos ayuda a clarificar cuales variables son las más importantes, y aunque el modelo consideré la variable Age como “Confirmed”, queda muy lejos en importancia frente a las 4 primeras variables.

La librería ha sido desarrollada por Miron Bartosz Kursa y puedes ampliar conocimientos aquí:

[Documentación sobre Boruta](https://www.datacamp.com/community/tutorials/feature-selection-R-boruta)

## Mice

Proporciona una serie de características avanzadas para el tratamiento de valores nulos. mice tiene varias formas de imputar los valores nulos, podemos consultar los diferentes métodos con ``methods(mice)``. La ventaja de mice es su versatilidad, podemos probar varios métodos de imputación y ver cual se ajusta mejor a los datos y cual obtiene una mayor precisión.

mice se divide en dos partes diferenciadas, por un lado, tenemos ``mice(df)``, que produce múltiples copias completas del ``df``, cada una con diferentes imputaciones de los datos que faltan. La función ``complete()`` devuelve uno o varios de estos conjuntos de datos imputados, siendo el predeterminado el primero, pero pudiendo escoger entre varias de las imputaciones hechas por el modelo.

A la hora de imputar, tenemos entonces un par de notaciones a tener en cuenta:
•	``m = 5`` viene referido al número de veces que se imputa. Cinco es el valor por defecto.
•	``meth = ‘rf’`` viene referido al método de imputación. En el ejemplo que vamos a mostrar vamos a usar Random Forests.

Vamos a probar mice con el paquete ``Credit``, de forma aleatoria, convertimos a nulos 20 observaciones de la variable ``Income`` y ``Limit``.

```r
library(mice)
library(ISLR)
library(DMwR)

Datos <- Credit
Datos[sample(1:nrow(Datos), 20), "Income"] <- NA
Datos[sample(1:nrow(Datos), 20), "Age"] <- NA
```

En ``MiceM`` vamos a guardar el modelo, usando el método de Random Forest y estableciendo el número de imputaciones creadas a 5. Hay que tener cuidado de no incluir la variable de respuesta al imputar, ya que al imputar en un entorno de prueba/producción, si sus datos contienen valores perdidos, no se podrá usar la variable de respuesta desconocida en ese momento. 

```r
miceM <- mice(Datos[, !names(Datos) %in% "Balance"], meth = "rf", m = 5)
miceout <- complete(miceM, 3)
```
En ``miceout`` guardamos el resultado obtenido por la imputación. El siguiente paso será evaluar el modelo, por lo que en ``actuals`` guardamos las observaciones reales y en ``predict`` guardamos las observaciones imputadas. Finalmente, con ``regr.eval()`` del paquete ``DMwr`` evaluamos la imputación.

```r
actuals <- Credit$Age[is.na(Datos$Age)]
predict <- miceout$Age[is.na(Datos$Age)]

regr.eval(actuals, predict)
```

```r
     mae         mse        rmse        mape 
 16.4000000 466.8000000  21.6055548   0.3680147

```

Podemos alternar entre los métodos de imputación con meth o entre las imputaciones creadas al establecer m. Es muy difícil obtener resultados totalmente fiables, por ello se recomienda que se tenga en consideración usar otros métodos de imputación, como los que ofrece ``rpart``, o imputando con la media/mediana/moda. 

mice es un paquete creado por Stef van Buuren, puedes consultar todo lo concerniente al paquete en el siguiente enlance 

[Documentación sobre mice](https://cran.r-project.org/web/packages/mice/mice.pdf)

# Machine Learning
## Mlr

Uno de los problemas habituales a la hora de realizar Machine Learning en R ha sido la gran cantidad de paquetes diferentes para realizar esta función, véase ``caret``, ``glmnet`` o ``randomforest``. Esto puede suponer un problema si realmente queremos unificar nuestro código y nuestras tareas, por ello, el paquete ``mlr`` nos ofrece una solución completa, juntado los algoritmos de ML en un solo paquete, además de una gran cantidad de opciones ya sea para manejar hiperparametros, visualizaciones, ingeniería de características… 

Se podría decir que el funcionamiento del paquete pasa por tres procesos:

**Crear una tarea. Crear un learner. Entrenarlo.**

### Crear una tarea

Crear una tarea viene referido a cargar nuestros datos en el paquete. En este primer paso seleccionamos la variable a predecir, además, ``mlr`` nos pedirá que le asignemos un nombre a nuestra tarea, este nombre nos servirá más adelante para llamar a los resultados o realizar visualizaciones.

Según el tipo de algoritmo que vayamos a usar existe una tarea específica, por ejemplo ``RegrTask()`` para problemas de regresión o ``ClassifTask()`` para problemas de clasificación.

### Crear un learner

Ya hemos creado una tarea, en la cual hemos decidido nuestra variable de respuesta y el tipo de problema al que nos vamos a enfrentar (regresión, clasificación…). En este segundo paso vamos a seleccionar el algoritmo especifico que queremos entrenar, ya sea una regresión lineal, un árbol de decisión, k-medias… Además de poder establecer hiperparámetros (el número de arboles a crear por un algoritmo bagging, el número de clúster por k-medias…), también podemos asignarle un nombre a nuestro learner para acceder a información de el. 

### Entrenamiento 

El último paso natural después de crear una tarea y un learner, entrenar el modelo, para ello, simplemente usamos ``task()`` pasándole la tarea, y el learner escogido.

### Ejemplo con Credit

Vamos a ver un ejemplo sencillo, mlr es un paquete gigantesco, y al unir tantísimos algoritmos y características, puede ser algo agotador explorar las tantísimas opciones y combinaciones, por lo que nos vamos a centrar en lo básico. En concreto, vamos a realizar una predicción sobre la variable de respuesta Balance de nuestro conocido paquete Credit, y vamos a entrenar un modelo lineal integrando glmnet dentro del paquete mlr.


