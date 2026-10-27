# Retail Sales Analytics & Profitability Dashboard

An end-to-end retail analytics project using **Python, PostgreSQL/SQL,
and Power BI** to explore sales, profitability, customer behavior,
product performance, regional trends, and shipping metrics.

> **Project focus:** turn raw retail transaction data into a cleaned,
> analysis-ready dataset, structured relational tables, reusable SQL
> analysis, and an interactive business intelligence dashboard.

## Overview

This project uses the Superstore dataset to analyze business performance
across orders, customers, products, categories, regions, and time. The
workflow covers data profiling, data cleaning, exploratory data analysis
(EDA), ETL preparation, SQL-based business analysis, and Power BI
reporting.

## Tools & Technologies

-   **Python:** pandas, NumPy
-   **Data visualization / EDA:** Matplotlib, Seaborn
-   **Database / SQL:** PostgreSQL-compatible SQL
-   **Business intelligence:** Microsoft Power BI
-   **Analysis areas:** sales, profit, customer and product performance,
    regional analysis, time-series trends, shipping, discounts, and
    business KPIs

## Workflow

``` text
Raw Superstore Dataset
        ↓
Python Data Profiling & Cleaning
        ↓
Exploratory Data Analysis (EDA)
        ↓
ETL Preparation & Relational Table Design
        ↓
SQL Business Analysis & Views
        ↓
Power BI Interactive Dashboard
        ↓
Business Insights
```

## Project Structure

``` text
retail-sales-analytics/
├── README.md
├── notebooks/
│   ├── 01_Data_Profiling.ipynb
│   ├── 02_EDA.ipynb
│   └── 03_ETL_SQL.ipynb
├── sql/
│   ├── 01_sales_analysis.sql
│   ├── 02_customer_analysis.sql
│   ├── 03_product_analysis.sql
│   ├── 04_regional_analysis.sql
│   ├── 05_time_analysis.sql
│   ├── 06_advanced_sql.sql
│   ├── 07_views.sql
│   └── 08_business_kpis.sql
├── powerbi/
│   └── retail_sales_dashboard.pbix
├── screenshots/
│   ├── executive-overview.png
│   ├── sales-analysis.png
│   ├── customer-intelligence.png
│   └── product-performance.png
└── data/
    ├── raw/
    └── cleaned/
```

*The structure above is a suggested repository layout. Rename files or
folders to match the actual repository. Add the Power BI file and
screenshots only if you intend to publish them.*

## 1. Data Profiling & Cleaning --- Python

The `01_Data_Profiling.ipynb` notebook inspects the source data and
prepares a cleaned dataset.

Work includes: - Reviewing row and column counts, data types,
descriptive statistics, unique values, and memory usage. - Checking
missing values and duplicate records. - Separating numerical and
categorical columns for profiling. - Converting order and shipping dates
to datetime values. - Inspecting negative sales/profit values and
discount distributions. - Trimming whitespace from text columns. -
Creating derived fields such as delivery days, order year, month, month
number, quarter, weekday, profit margin, sales buckets, and discount
categories. - Exporting a cleaned CSV for downstream analysis.

## 2. Exploratory Data Analysis (EDA) --- Python

The `02_EDA.ipynb` notebook investigates patterns and potential
relationships in the cleaned data.

Analysis includes: - Overall sales, profit, order, customer, and product
summaries. - Sales and profit distributions and boxplots to inspect
outliers. - Sales and profit by category and sub-category. - Regional
performance and state-level sales comparisons. - Customer segment
contribution. - Shipping mode analysis. - Monthly and quarterly sales
trends. - Delivery-time summaries. - Discount versus profit
scatterplot. - Correlation heatmap and pairwise relationships among
numerical variables. - Top-selling products and products with the lowest
overall profit.

## 3. ETL Preparation & Relational Data Design

The `03_ETL_SQL.ipynb` notebook separates the cleaned transaction data
into analysis-friendly tables:

-   **Customers:** customer ID, customer name, and segment.
-   **Products:** product ID, product name, category, and sub-category.
-   **Orders:** order dates, shipping dates and mode, customer ID, and
    geographic fields.
-   **Order items / sales:** row ID, order ID, product ID, sales,
    quantity, discount, and profit.

The notebook exports these tables as CSV files for loading into a
relational database. This separates customer, product, order, and
transaction-level information and supports SQL joins for analysis.

## 4. SQL Analysis

The SQL scripts contain queries organized by business question.

  -----------------------------------------------------------------------
  Script                              Main analysis
  ----------------------------------- -----------------------------------
  `01_sales_analysis.sql`             Revenue, profit, order count,
                                      customer count, and average order
                                      value

  `02_customer_analysis.sql`          Customer revenue and profit
                                      rankings, order frequency,
                                      segments, and lifetime sales

  `03_product_analysis.sql`           Best-selling and loss-making
                                      products, category performance,
                                      discounts, margins, and rankings

  `04_regional_analysis.sql`          Revenue, profit, margin, state/city
                                      comparisons, and regional
                                      contribution

  `05_time_analysis.sql`              Monthly, quarterly, and yearly
                                      trends; running totals; growth;
                                      moving averages; delivery time

  `06_advanced_sql.sql`               Subqueries, CTEs, `CASE`, `EXISTS`,
                                      ranking functions, `LAG`, `LEAD`,
                                      and window calculations

  `07_views.sql`                      Reusable views for customer,
                                      product, regional, monthly,
                                      category, shipping, and executive
                                      KPI summaries

  `08_business_kpis.sql`              Executive KPIs, average order
                                      value, profit margin,
                                      segment/category/region
                                      performance, and dashboard dataset
  -----------------------------------------------------------------------

### SQL concepts used

-   Joins and aggregations
-   `GROUP BY`, `HAVING`, and sorting
-   Subqueries and common table expressions (CTEs)
-   Conditional classification with `CASE`
-   Window functions including `RANK`, `DENSE_RANK`, `ROW_NUMBER`,
    `LAG`, and `LEAD`
-   Running totals, moving averages, and period-over-period comparisons
-   Views for reusable analytical datasets
-   Business KPIs such as revenue, profit, profit margin, units sold,
    orders, and average order value

## 5. Power BI Dashboard

The Power BI dashboard is designed to make business performance easier
to explore. Based on the dashboard pages developed for this project, the
report covers:

-   **Executive Overview:** high-level KPIs and overall performance.
-   **Sales Analysis:** sales trends, category contribution, and
    sales/profit comparisons.
-   **Customer Intelligence:** customer rankings and segment-level
    performance.
-   **Product Performance:** product rankings, category/sub-category
    performance, and profitability.

If included in the repository, the `.pbix` file allows reviewers to
explore the report directly. Add screenshots in the `screenshots/`
directory and embed them below.

### Dashboard screenshots

Replace the image paths below with the actual screenshot filenames in
your repository.

![Executive Overview](screenshots/executive-overview.png)

![Sales Analysis](screenshots/sales-analysis.png)

![Customer Intelligence](screenshots/customer-intelligence.png)

![Product Performance](screenshots/product-performance.png)

## Business Questions Explored

-   How much revenue and profit did the business generate?
-   Which product categories and sub-categories contributed the most
    revenue and profit?
-   Which products generated the highest sales, and which products had
    negative overall profit?
-   How did revenue and profit vary by region, state, and city?
-   Which customers and customer segments contributed the most revenue?
-   How did sales change over time, including monthly and yearly trends?
-   How did discounts relate to profit in the observed data?
-   How long did orders take to ship, and how did delivery time vary?
-   Which KPIs should be surfaced in an executive dashboard?

## Key Metrics

The analysis and dashboard include metrics such as:

-   Total revenue
-   Total profit
-   Total orders
-   Total quantity sold
-   Total customers
-   Average order value
-   Profit margin
-   Revenue and profit by category, product, customer, and region
-   Monthly and yearly performance
-   Average delivery time
-   Average discount

**Note:** Add exact KPI values and conclusions only after verifying them
against the final dataset and Power BI report. Avoid copying example
values from an earlier draft if they do not match the version of the
data used here.

## How to Run the Project

### Requirements

-   Python 3
-   Jupyter Notebook or JupyterLab
-   pandas, NumPy, Matplotlib, and Seaborn
-   PostgreSQL (if running the SQL scripts in PostgreSQL)
-   Microsoft Power BI Desktop (to open the `.pbix` report)

### Python setup

1.  Clone or download this repository.

2.  Install the Python dependencies:

    ``` bash
    pip install pandas numpy matplotlib seaborn jupyter
    ```

3.  Place the source dataset in the expected `data/raw/` folder, or
    update the dataset path in each notebook.

4.  Run the notebooks in order:

    1.  `01_Data_Profiling.ipynb`
    2.  `02_EDA.ipynb`
    3.  `03_ETL_SQL.ipynb`

The original notebooks currently use local Windows file paths. Update
those paths to relative paths for your repository before sharing the
notebooks publicly.

### SQL setup

1.  Create a PostgreSQL database.
2.  Load the exported customer, product, order, and sales/order-item
    tables.
3.  Check that table and column names match those used in the SQL
    scripts.
4.  Run the SQL files in the order appropriate to your schema; create
    the base tables before running analysis queries and views.

Do not commit database passwords, connection strings, private
credentials, or `.env` files.

### Power BI

Open the `.pbix` file in Power BI Desktop and update the data source
connection if needed. If the dashboard connects to a local PostgreSQL
database, configure the connection for your own environment.

## Repository Notes & Limitations

-   The supplied Python notebooks document profiling, cleaning, EDA, and
    ETL preparation.
-   The supplied SQL scripts document business analysis and KPI queries.
-   Regression models and formal hypothesis tests (such as a t-test) are
    **not demonstrated in the supplied notebooks/scripts listed here**.
    If you performed these in another notebook, add that notebook and
    document the target variable, model, evaluation metrics, test
    hypotheses, p-value, and interpretation before listing them as
    project deliverables.
-   Results depend on the dataset version, cleaning decisions, and
    database schema.
-   The screenshots and `.pbix` filename shown in the suggested
    structure are placeholders until the actual files are added.

## Future Improvements

-   Make file paths relative and add a reproducible setup/configuration.
-   Add a data dictionary and SQL schema diagram.
-   Document verified findings with exact values and chart references.
-   Add automated data-quality checks.
-   Add a separate, reproducible modeling notebook if regression or
    statistical hypothesis testing is part of the final project.

## Author

**Vikram Ash**

-   GitHub: \[Add your GitHub profile/repository URL\]
-   LinkedIn: \[Add your LinkedIn profile URL\]

------------------------------------------------------------------------

If you found this project useful, feel free to explore the notebooks and
SQL scripts.
