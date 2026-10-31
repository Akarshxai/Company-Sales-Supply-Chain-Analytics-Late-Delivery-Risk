# Company Sales, Supply Chain Analytics & Late Delivery Prediction

**An End-to-End Data Analytics, Business Intelligence & Machine Learning Project**

Analyzing business performance, customer behavior, product profitability, supply chain operations, and predicting late delivery risks using Python, MySQL, Power BI, and Machine Learning.

---

## Project Overview

Supply chain inefficiencies, delayed deliveries, low-profit products, and inconsistent business performance can negatively affect customer satisfaction and organizational profitability.

This project uses the **DataCo Smart Supply Chain Dataset** to perform comprehensive business and operational analysis. It combines Python-based data preparation, SQL-driven business intelligence, interactive Power BI dashboards, and machine learning models to uncover actionable insights and predict late delivery risks.

The project follows a complete end-to-end analytics workflow, transforming raw supply chain data into meaningful business insights and predictive intelligence.

## Business Objectives

- Analyze overall company sales, revenue, and profitability.
- Identify high-performing and underperforming products and categories.
- Understand customer purchasing behavior and regional performance.
- Investigate late deliveries and their relationship with shipping modes and regions.
- Identify operational inefficiencies affecting supply chain performance.
- Analyze factors associated with late delivery risks.
- Develop and evaluate machine learning models for late delivery prediction.
- Provide actionable recommendations to improve business and logistics operations.

## Technology Stack

| Technology | Application |
|---|---|
| Python | Data analysis and preprocessing |
| Pandas & NumPy | Data cleaning and manipulation |
| Matplotlib & Seaborn | Exploratory data visualization |
| Jupyter Notebook | Interactive analysis |
| MySQL | Database management and business analysis |
| SQL | Joins, CTEs, subqueries and window functions |
| Power BI | Interactive dashboards and reporting |
| DAX | KPI calculations and measures |
| Scikit-learn | Machine learning |
| Random Forest | Predictive classification |
| Git & GitHub | Version control and project management |

## Project Structure

```text
Company-Sales-Supply-Chain-Analytics/
│
├── SQL queries/
│   ├── Table_splitting.sql
│   ├── checking_data_before_table_splitting.sql
│   ├── some_business_insights.sql
│   └── some_useful_insights.sql
│
├── data/
│   ├── DataCoSupplyChainDataset.csv
│   └── DataCoSupplyChainDataset_Cleaned.csv
    └── DATASET_SOURCE.md
│
├── machine learning/
│   ├── ml_outputs/
│   │   ├── dataco_random_forest_model
│   │   ├── model_comparison.csv
│   │   └── sample_predictions.csv
│   │
│   └── Late_Delivery_Prediction.ipynb
│
├── powerbi/
│   ├── Screenshot of Dashboard/
│   │   ├── 01 Sales and Profit Overview.png
│   │   ├── 02 Customer & Regional Performance.png
│   │   ├── 03 Product & Category Analysis.png
│   │   └── 04 Delivery & Logistics Performance.png
│   │
│   └── Supply_chain_Dashboard.pbix
│
├── python/
│   ├── Supply_Chain_EDA.ipynb
│   ├── data_cleaning.ipynb
│   ├── mysql_connection.ipynb
│   └── short_summary.ipynb
│
├── .gitignore
├── Integrated_Findings_and_Recommendations.md
├── README.md
└── requirements.txt
```

## Project Workflow

### 1. Data Cleaning & Preprocessing — Python

Performed data preparation and quality checks to ensure data consistency and reliability.

Key activities:

- Inspected dataset structure, dimensions, and data types.
- Identified and handled missing values.
- Checked duplicate records and data consistency.
- Removed unnecessary and irrelevant columns.
- Standardized column names.
- Converted date columns into appropriate date formats.
- Reviewed numerical and categorical variables.
- Prepared the cleaned dataset for further analysis.

**Notebook:** `python/data_cleaning.ipynb`

### 2. Exploratory Data Analysis — Python

Conducted exploratory analysis to understand business patterns and investigate operational issues.

Key analysis areas:

- Sales and profit distributions.
- Customer and product performance.
- Regional delivery patterns.
- Shipping mode performance.
- Late delivery risk distribution.
- Order and delivery trends.
- Outlier identification and investigation.
- Relationships between business and operational variables.

**Notebook:** `python/Supply_Chain_EDA.ipynb`

### 3. Database Management & Business Analysis — MySQL

Organized the dataset into relational tables and performed business-focused SQL analysis.

SQL concepts and techniques:

- Database and table creation.
- Table splitting and normalization.
- Primary and foreign key relationships.
- INNER JOIN, LEFT JOIN and other joins.
- Aggregate functions and GROUP BY.
- CASE statements and conditional analysis.
- Subqueries and Common Table Expressions (CTEs).
- Window functions: RANK(), DENSE_RANK(), LAG() and SUM() OVER().
- Month-over-month growth analysis.
- Cumulative monthly sales.
- Product and customer ranking.
- Regional and shipping mode comparisons.
- Pareto analysis of product sales.
- High-sales, low-profit product identification.

**SQL files:** `SQL queries/`

### 4. Interactive Business Intelligence Dashboard — Power BI

Developed a four-page interactive Power BI dashboard to monitor business performance and supply chain operations.

#### Dashboard Pages

**Page 1 — Sales & Profit Overview**

- Total sales and profit.
- Total orders and quantity.
- Average order value.
- Profit margin.
- Sales and profitability trends.

**Page 2 — Customer & Regional Performance**

- Customer performance analysis.
- Regional sales and profitability.
- Customer purchasing behavior.
- High-value customer identification.

**Page 3 — Product & Category Analysis**

- Product-wise sales and profit.
- Top-performing products.
- Category performance.
- High-sales, low-profit products.
- Product profitability comparisons.

**Page 4 — Delivery & Logistics Performance**

- Delivery status distribution.
- Late delivery performance.
- Shipping mode analysis.
- Regional delivery performance.
- Logistics and operational inefficiencies.

### Dashboard Previews

#### 01. Sales & Profit Overview

![Sales and Profit Overview](powerbi/Screenshot%20of%20Dashboard/01%20Sales%20and%20Profit%20Overview.png)

#### 02. Customer & Regional Performance

![Customer and Regional Performance](powerbi/Screenshot%20of%20Dashboard/02%20Customer%20%26%20Regional%20Performance.png)

#### 03. Product & Category Analysis

![Product and Category Analysis](powerbi/Screenshot%20of%20Dashboard/03%20Product%20%26%20Category%20Analysis.png)

#### 04. Delivery & Logistics Performance

![Delivery and Logistics Performance](powerbi/Screenshot%20of%20Dashboard/04%20Delivery%20%26%20Logistics%20Performance.png)

**Dashboard file:** `powerbi/Supply_chain_Dashboard.pbix`

### 5. Machine Learning — Late Delivery Prediction

Developed a classification workflow to predict late delivery risks using the available supply chain data.

Key activities:

- Prepared data for machine learning.
- Selected relevant predictive features.
- Performed feature preprocessing.
- Trained multiple classification models.
- Compared model performance.
- Evaluated predictions using classification metrics.
- Generated sample predictions.
- Saved trained model and prediction outputs.

**Notebook:** `machine learning/Late_Delivery_Prediction.ipynb`

**Model outputs:** `machine learning/ml_outputs/`

#### Model Performance Comparison

Three classification algorithms were evaluated:

| Model | Accuracy | Precision | Recall | F1 Score |
|---|---:|---:|---:|---:|
| Random Forest | 69.97% | 88.19% | 54.94% | **67.70%** |
| Decision Tree | 69.83% | 88.24% | 54.61% | 67.47% |
| Logistic Regression | 69.86% | **88.73%** | 54.28% | 67.35% |

**Key observations:**

- Random Forest achieved the highest F1 score (67.70%) and recall (54.94%).
- Logistic Regression achieved the highest precision (88.73%).
- All three models demonstrated similar accuracy, approximately 70%.
- The relatively lower recall indicates opportunities to improve the identification of actual late deliveries.

**Best-performing model based on F1 score: Random Forest.**

*Note: Model performance depends on the selected classification threshold, positive class definition, preprocessing, and evaluation methodology.*

## Key Business Analysis Areas

| Business Area | Analytical Focus |
|---|---|
| Sales Performance | Revenue, profit and monthly trends |
| Customer Analysis | Customer contribution and purchasing behavior |
| Product Analysis | Product rankings and profitability |
| Regional Analysis | Geographic sales and delivery performance |
| Logistics Analysis | Shipping modes and delivery duration |
| Late Delivery Analysis | Delivery risk and operational patterns |
| Predictive Analytics | Late delivery classification |

## Business Findings & Recommendations

The project combines Python analysis, SQL business intelligence, Power BI reporting, and predictive modeling to support data-driven business decisions.

The detailed findings and recommendations are documented separately.

**[View Integrated Findings & Recommendations](Integrated_Findings_and_Recommendations.md)**

Key recommendation areas include:

- Improving delivery operations.
- Investigating regional delivery bottlenecks.
- Evaluating shipping mode effectiveness.
- Monitoring high-sales, low-profit products.
- Improving operational planning.
- Using predictive insights to identify potential delivery risks.

## How to Run This Project

### Prerequisites

- Python 3.x
- Jupyter Notebook
- MySQL Server and MySQL Workbench
- Power BI Desktop

### Step 1 — Clone the repository

```bash
git clone https://github.com/Akarshxai/Company-Sales-Supply-Chain-Analytics-Late-Delivery-Risk.git
```

### Step 2 — Navigate to the project directory

```bash
cd Company-Sales-Supply-Chain-Analytics-Late-Delivery-Risk
```

### Step 3 — Install Python dependencies

```bash
pip install -r requirements.txt
```

### Step 4 — Run Python notebooks

```bash
jupyter notebook
```

Start with data cleaning, followed by exploratory data analysis and machine learning.

### Step 5 — Run SQL analysis

- Set up MySQL Server.
- Import the cleaned dataset.
- Execute the SQL scripts in the `SQL queries` folder.
- Follow the table creation and analysis workflow.

### Step 6 — Open the Power BI dashboard

Open:

`powerbi/Supply_chain_Dashboard.pbix`

Update the data source path if required and refresh the dataset.

## Dataset Information

**Dataset:** DataCo Smart Supply Chain Dataset

The dataset contains information related to:

- Orders and sales.
- Customers and products.
- Shipping and delivery.
- Product categories.
- Profitability.
- Regional operations.

Dataset source: Add the original dataset download or Kaggle source link here.

The repository includes the original and cleaned dataset files. For reproducibility, use the appropriate dataset version for each notebook and SQL workflow.

## Future Improvements

- Improve predictive model performance through feature engineering and hyperparameter tuning.
- Experiment with additional classification algorithms.
- Implement model explainability using feature importance and SHAP.
- Develop automated reporting and monitoring.
- Deploy the late delivery prediction model as an interactive application.
- Integrate predictive outputs into the Power BI reporting workflow.

## Author

**Akarsh Gupta**

Aspiring Data Analyst | Python | SQL | Power BI | Excel | Machine Learning

GitHub: [Akarshxai](https://github.com/Akarshxai)

---

*This project demonstrates an end-to-end approach to business analytics, supply chain analysis, business intelligence, and predictive analytics.*
