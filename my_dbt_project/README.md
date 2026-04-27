# 🛒 Groceries Sales — Data & BI Project

A dbt project that transforms raw groceries transactional data in PostgreSQL into a clean star schema optimized for business intelligence reporting and dashboards.

---

## Business Context

This project answers the core business questions for a groceries retail operation:

- Which products and categories drive the most revenue?
- Who are the top customers and where are they located?
- Which employees close the most sales?
- How does discounting affect order value and volume?
- What are the revenue trends over time?

---

## Architecture

```
PostgreSQL (raw)         dbt                        BI Layer
─────────────────   ──────────────────────   ──────────────────────
sales               stg_sales   ──────────►  fct_sales
products            stg_products             dim_customer
customers    ──►    stg_customers    ──────►  dim_employee
employees           stg_employees            dim_product
categories          stg_categories           dim_location
cities              stg_cities               dim_date
                                                   │
                                             Power BI / Jupyter
```

---

## Star Schema

```
              dim_date
                 │
dim_customer ────┤
dim_employee ────┼──── fct_sales
dim_product  ────┤
dim_location ────┘
```

### Fact Table

| Model | Grain | Measures |
|---|---|---|
| `fct_sales` | One row per transaction | `quantity`, `total_price`, `discount`, `discount_amount` |

### Dimensions

| Model | Grain | BI Use |
|---|---|---|
| `dim_customer` | One row per customer | Customer segmentation, city filtering |
| `dim_employee` | One row per employee | Sales rep performance, tenure analysis |
| `dim_product` | One row per product | Product mix, category drilldown |
| `dim_location` | One row per city | Geographic revenue breakdown |
| `dim_date` | One row per date | Time intelligence — YTD, MTD, QoQ |

---

## BI Layer

### Schemas in PostgreSQL

| Schema | Contents | Connects to |
|---|---|---|
| `public` | Raw source tables | — |
| `public_staging` | Cleaned views | Internal dbt only |
| `public_marts` | Star schema tables | Power BI, Jupyter |

### Connecting Power BI

1. Open Power BI Desktop
2. **Get Data → PostgreSQL**
3. Server: `localhost` Port: `5432`
4. Database: `groceries`
5. Import tables from `public_marts` schema:
   - `fct_sales`
   - `dim_customer`
   - `dim_employee`
   - `dim_product`
   - `dim_location`
   - `dim_date`
6. Define relationships on matching keys in the Model view

### Recommended Relationships (Power BI Model View)

```
fct_sales[customer_id]   → dim_customer[customer_id]
fct_sales[employee_id]   → dim_employee[employee_id]
fct_sales[product_id]    → dim_product[product_id]
fct_sales[location_id]   → dim_location[location_id]
fct_sales[date_id]       → dim_date[date_id]
```

All relationships are many-to-one from fact to dimension.

### Key DAX Measures to Build

```dax
Total Revenue = SUM(fct_sales[total_price])

Total Transactions = COUNTROWS(fct_sales)

Avg Order Value = DIVIDE([Total Revenue], [Total Transactions])

Total Discount Amount = SUM(fct_sales[discount_amount])

Revenue YTD = TOTALYTD([Total Revenue], dim_date[full_date])

Revenue MTD = TOTALMTD([Total Revenue], dim_date[full_date])

Revenue vs Prior Month =
VAR current = [Total Revenue]
VAR prior = CALCULATE([Total Revenue], DATEADD(dim_date[full_date], -1, MONTH))
RETURN DIVIDE(current - prior, prior)
```

### Suggested Dashboard Pages

| Page | Visuals |
|---|---|
| **Executive Summary** | Revenue KPI, transactions KPI, AOV KPI, monthly trend line |
| **Product Performance** | Top 10 products bar, category pie, price vs quantity scatter |
| **Customer Analysis** | Top customers table, revenue by city map, customer count trend |
| **Employee Performance** | Revenue per rep bar, sales count, avg discount per rep |
| **Time Intelligence** | YTD vs prior year, monthly heatmap, day-of-week breakdown |

---

## Reports & Dashboards

| Report | Description | Tool | Status |
|---|---|---|---|
| Executive Summary | Revenue, transactions, AOV KPIs | Power BI | 🔜 Coming soon |
| Product Performance | Top products and category mix | Power BI | 🔜 Coming soon |
| Customer Analysis | Segmentation and geography | Power BI | 🔜 Coming soon |
| Employee Performance | Sales rep leaderboard | Power BI | 🔜 Coming soon |
| EDA Notebook | Exploratory analysis | Jupyter | ✅ Done |

---

## Project Structure

```
my_dbt_project/
├── models/
│   ├── staging/          # Views — clean raw tables
│   │   ├── sources.yml
│   │   ├── schema.yml
│   │   └── stg_*.sql
│   └── marts/            # Tables — star schema
│       ├── schema.yml
│       ├── dim_*.sql
│       └── fct_sales.sql
├── notebooks/
│   └── groceries_analysis.ipynb
├── reports/              # Power BI .pbix files go here
├── analyses/
├── macros/
├── seeds/
├── snapshots/
├── tests/
├── dbt_project.yml
└── README.md
```

---

## Setup & Running

### Prerequisites
- PostgreSQL on `localhost:5432`
- dbt-postgres: `pip install dbt-postgres`
- Database: `groceries`

### profiles.yml
Place at `C:\Users\<you>\.dbt\profiles.yml`:

```yaml
my_dbt_project:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: postgres
      password: "<your_password>"
      port: 5432
      dbname: groceries
      schema: public
      threads: 1
```

### Commands

```bash
dbt debug              # verify connection
dbt run                # build all models
dbt run --full-refresh # force rebuild
dbt test               # run data quality tests
dbt docs generate      # generate docs site
dbt docs serve         # open docs in browser
```

### Run specific layers

```bash
dbt run --select staging         # staging views only
dbt run --select marts           # mart tables only
dbt run --select fct_sales       # single model
dbt run --select dim_date+       # model and all downstream
```

---

## Data Tests

Primary keys tested for `unique` and `not_null` across all staging and mart models:

```bash
dbt test
```

---

## Author

Built as part of the ALX Africa Data Engineering program.  
Domain focus: Retail analytics · FinTech · Healthcare AI
