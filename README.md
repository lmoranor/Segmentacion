📊 Segmentación de Clientes con K-Means y Árbol de Decisión
🧾 Descripción del Proyecto
Una empresa de retail online ubicada en el Reino Unido desea segmentar a sus clientes para definir estrategias de marketing más efectivas. Para ello, se dispone de una base de datos que contiene todas las transacciones realizadas entre el 1 de diciembre de 2010 y el 9 de diciembre de 2011.

La base de datos incluye:

Código de cliente (CustomerID)

Número de factura (InvoiceNo)

Cantidades y precios de productos

Fechas de transacción

Información del país

Puedes obtener la base de datos original desde este repositorio de UCI Machine Learning.

🔍 Objetivos y Metodología
La segmentación se realiza mediante los siguientes pasos:

1. Limpieza de Datos
Eliminación de valores nulos, vacíos o inválidos

Filtrado de facturas con devoluciones y errores en el formato

Conversión de fechas y normalización de datos

📌 Esta etapa se realizó en MySQL para asegurar una base sólida antes del análisis.

2. Análisis RFM (Recency, Frequency, Monetary)
Recency: Días desde la última compra del cliente

Frequency: Número total de compras realizadas

Monetary: Valor total gastado por el cliente

📊 Se usó este análisis para representar el comportamiento de compra de los clientes.

3. Segmentación con K-Means
Escalamiento de las variables RFM

Determinación del número óptimo de clusters (método del codo y silueta)

Asignación de cada cliente a un cluster

4. Clasificación con Árbol de Decisión
Entrenamiento de un modelo con los datos etiquetados por el clustering

Creación de un árbol de decisión para clasificar nuevos clientes automáticamente

5. Visualización en Dashboard
Se desarrolló un dashboard interactivo en Tableau

Se visualizaron los segmentos y sus características para facilitar la toma de decisiones de marketing

🛠️ Tecnologías Utilizadas
Herramienta	Propósito
MySQL	Limpieza y transformación de datos
R	Análisis RFM, clustering, modelos
Tableau	Visualización y dashboard final
