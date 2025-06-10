# 📊 Customer Segmentation Using K-Means and Decision Tree

## 🧾 Project Description

An **online retail company based in the United Kingdom** aims to segment its customers to develop more effective marketing strategies. For this purpose, a dataset containing all transactions made between **December 1, 2010, and December 9, 2011** is used.

The dataset includes:
- Customer codes (`CustomerID`)
- Invoice numbers (`InvoiceNo`)
- Product quantities and unit prices
- Transaction dates
- Country information

📥 The original dataset can be obtained from this [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Online+Retail).

---

## 🔍 Objectives & Methodology

The segmentation process includes the following steps:

### 1. Data Cleaning
- Removal of **null, empty, or invalid values**
- Filtering out **returns and credit notes**
- Date formatting and standardization

> 📌 This step was performed using **MySQL** to ensure a reliable foundation for analysis.

### 2. RFM Analysis (Recency, Frequency, Monetary)
- **Recency**: Days since the customer's last purchase
- **Frequency**: Total number of purchases
- **Monetary**: Total amount spent by the customer

> 📊 This analysis provides insight into customer behavior.

### 3. Clustering with K-Means
- Scaling the RFM metrics
- Finding the optimal number of clusters (elbow and silhouette methods)
- Assigning each customer to a cluster

### 4. Classification with Decision Tree
- Training a model using the labeled cluster data
- Creating a decision tree to classify **new customers**

### 5. Dashboard Visualization
- An interactive **Tableau dashboard** was created
- Cluster characteristics were visualized to support marketing decisions

---

## 🛠️ Technologies Used

| Tool        | Purpose                            |
|-------------|------------------------------------|
| **MySQL**   | Data cleaning and transformation   |
| **R**       | RFM analysis, clustering, modeling |
| **Tableau** | Data visualization and dashboard   |

---

## 📁 Repository Structure

```
├── sql/
│   └── data_cleaning_retail.sql
├── r/
│   └── customer_segmentation_kmeans_tree.R
├── tableau/
│   └── segmentation_dashboard.twbx
├── data/
│   └── retail_clean.csv
├── README.md
```
