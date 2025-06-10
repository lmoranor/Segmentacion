# Segmentacion de Clientes mediante K-means y modelo de Árbol de Decisión para clasificación

Una empresa de retail online, ubicada en Reino Unido, desea segmentar a sus clientes para obtener datos importantes para el desarrollo de una estrategia de marketing. Para ello, dispone de la base de datos con todas las transacciones realizadas entre el 01/12/2010 y 09/12/20211. La base de datos contiene información como códigos de clientes, números de transacción, precios y cantidades vendidas y la fecha de transacción. Dicha base de datos puede obtenerse de [aquí](https://archive.ics.uci.edu/dataset/352/online+retail). 


Para realizar la segmentación, se utilizará el análisis RFM (Recency, Frequency, Monetary) de cada uno de los clientes. Luego, se determinará el número de grupos de clientes y la asignación de cada cliente en dichos grupos mediante un análisis cluster de k-means. Como siguiente paso, se va a generar un árbol de decisión para clasificar fácilmente futuros clientes de la empresa. Finalmente, se creará un dashboard con los resultados obtenidos y entender las características de cada segmento y demás información adicional que aportará a la toma de decisión de las estrategias de marketing deseadas. 



Por supuesto, como primer paso, se realizará la limpieza de los datos ya que se han detectado valores nulos o vacíos, facturas con devoluciones y errores en ciertos formatos de datos. La limpieza de los datos se realizó mediante el uso del software MySQL, el análisis cluster y generación del árbol de decisión se realizaron mediante el software R. Finalmente, el dashboard se generó en Tableau. 
