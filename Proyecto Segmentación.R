## PROYECTO DE SEGMENTACIÓN DE CLIENTES MEDIANTE USO DE K-MEANS Y DECISION TREES

## Dataset obtenido de https://archive.ics.uci.edu/dataset/352/online+retail

## Carga de Librerías
library(tidyverse)
library(lubridate)
library(cluster)
library(factoextra)
library(rpart)
library(rpart.plot)
library(readxl)
library(ggplot2)
library(caret)
library(dplyr)
library(openxlsx)

## Carga de base de datos
datos <- read.xlsx("C:/Users/luism/Downloads/Databases/Segmentación/Retail_clean.xlsx")

## Dar formato de fecha a InvoiceDate
datos_clean <- mutate(InvoiceDate = as.Date(as.numeric(InvoiceDate), origin = "1899-12-30"))

## Cálculo de métricas RFM para segmentación
# Fecha de análisis (última fecha disponible + 1)
ref_fecha <- max(datos_clean$InvoiceDate, na.rm = TRUE) + 1

#Cáculo de cada métrica RFM
rfm_data <- datos_clean %>%
  group_by(CustomerID) %>%
  summarise(
    Recency = as.numeric(ref_fecha - max(InvoiceDate)),
    Frequency = n_distinct(InvoiceNo),
    Monetary = sum(Quantity * UnitPrice)
  )

## Escalar las métricas RFM para aplicar clustering (Se excluye CustomerID ya que no es una métrica RFM)
rfm_scaled <- scale(rfm_data[, 2:4])  # sin CustomerID

# Encontrar número óptimo de clústeres mediante método de codo
fviz_nbclust(rfm_scaled, kmeans, method = "wss") + labs(title = "Número óptimo de Clusters (Método de codo")  # Elbow method

# Encontrar número óptimo de clústeres mediante método silhouette
fviz_nbclust(rfm_scaled, kmeans, method = "silhouette") +
  labs(title = "Número óptimo de Clusters (Método Silhouette)")

#Se obtiene que el número óptimo de clusters es 4
k_optimo <- 4

# Clasificación de clientes en los 4 clusters
set.seed(123)
km <- kmeans(rfm_scaled, centers = k_optimo, nstart = 25)

rfm_data$Segment <- as.factor(km$cluster)

# Crear conjunto de entrenamiento (70%) y prueba (30%) para árbol de decisión
set.seed(123)
train_index <- createDataPartition(rfm_data$Segment, p = 0.7, list = FALSE)
train_data <- rfm_data[train_index, ]
test_data <- rfm_data[-train_index, ]

# Entrenamiento del árbol
tree_model <- rpart(Segment ~ Recency + Frequency + Monetary, data = train_data, method = "class")

# Visualización
rpart.plot(tree_model, type = 2, extra = 104, fallen.leaves = TRUE)

# Predicción sobre conjunto de prueba
preds <- predict(tree_model, test_data, type = "class")

# Evaluación del modelo mediante matriz de confusión
confusionMatrix(preds, test_data$Segment)

# Visualización de clusters en 2D
fviz_cluster(km, data = rfm_scaled, geom = "point", ellipse.type = "convex", labelsize = 8)

# Resumen de promedio por clúster
rfm_summary_stats <- rfm_data %>%
  group_by(Segment) %>%
  summarise(
    Count = n(),
    
    Avg_Recency = mean(Recency),
    
    Avg_Frequency = mean(Frequency),
    
    Avg_Monetary = mean(Monetary)
  ) %>%
  arrange(Segment)

print(rfm_summary_stats)

## Agregar los segmentos a los clientes de la base original limpia
df_segmented <- datos_clean %>%
  left_join(dplyr::select(rfm_data, CustomerID, Segment), by = "CustomerID")

## Crear una hoja de excel con los datos limpios y segmentados para generación de dashboards
write.xlsx(df_segmented, file = "C:/Users/luism/Downloads/Databases/Segmentación/df_segmented.xlsx")
write.xlsx(rfm_data, file = "C:/Users/luism/Downloads/Databases/Segmentación/rfm_data.xlsx")
