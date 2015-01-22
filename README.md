---
title: "Curso Analisis de Datos en R (basico)"
author: "Diego J. Lizcano"
framework: bootstrap
highlighter: prettify
hitheme: twitter-bootstrap
mode: selfcontained
github:
  branch: gh-pages
  repo: Curso_R_basico
  user: dlizcano
assets:
  css:
  - http://fonts.googleapis.com/css?family=Raleway:300
  - http://fonts.googleapis.com/css?family=Oxygen
widgets: R_basico
---

<style>
.container { width: 1000px; }

body{
  font-family: 'Oxygen', sans-serif;
  font-size: 16px;
  line-height: 24px;
}

h1,h2,h3,h4 {
  font-family: 'Raleway', sans-serif;
}

h3 {
  background-color: #D4DAEC;
  text-indent: 100px; 
}

h4 {
  text-indent: 100px;
}
</style>

<a href="https://github.com/dlizcano/Curso_R_basico"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png" alt="Fork me on GitHub"></a>

```{r echo=F, warning= F, message=F}
 opts_chunk$set(
 message = FALSE,
  warning = FALSE,
  error = FALSE,
  tidy = FALSE,
  cache = FALSE,
  results = 'asis'
)
```
# Análisis de datos en R 

## Introducción

En este curso aprenderemos a usar los aspectos básicos del lenguaje estadístico [`R`](http://cran.r-project.org/) con la interface [`RStudio`](http://www.rstudio.com/).  En el proceso usaremos datos proporcionados por: xxx a lo largo del curso aprenderemos a introducir datos, describirlos y sintetizar resultados en gráficas.  


## Antes de comenzar
Instale en su computadora [`R`](http://cran.r-project.org/). Posteriormente instale [`RStudio`](http://www.rstudio.com/).



## Contenido del curso

1. R como lenguage estadistico de programacion y sus paquetes (2 horas. Diego J. Lizcano)
2. Leer tablas y hacer graficas con plot (2 horas. Andres Romero)
3. Hay diferencias? Prueba t, Anova (2 horas. Peggy Loor)
4. Convierta su codigo en funcion (2 horas. Andres? Peggy?)
4. La regresion lineal (1 hora. Diego J. Lizcano)
5. Modelos GLM (1 hora. Diego J. Lizcano)
6. Aplicacion 1. Analisis de biodiversidad con los paquetes Vegan y BiodiversityR (2 horas. Andres?)
7. Aplicacion 2. Analisis de dietas (2 horas. Peggy ?)
8. Aplicacion 3. Analisis de distribucion de especies (2 horas Diego)


```{r}
require(igraph)
require(rCharts)

g <- graph.tree(40, children = 4)
plot (g)
```

## Lots More Sankey
Believe it or not, there is an entire site devoted to sankey diagrams.  For all the sankey you can handle, check out http://sankey-diagrams.com.  Here are a couple more sankeys generated from `rCharts`:  http://rcharts.io/viewer/?6001601#.UeWfuY3VCSo, http://rcharts.io/viewer/?6003605, http://rcharts.io/viewer/?6003575.

