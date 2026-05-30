# retail-lakehouse-dbt

Production-grade retail data pipeline using dbt + Databricks | Medallion architecture (Bronze → Silver → Gold) | SCD Type 2 | CI/CD | 49 data tests

![Retail Analytics Lakehouse — Medallion Architecture](maha_dbt/retail_lakehouse_dbt.png)

---

## What's Inside

```
dbt_tuto/
├── maha_dbt/        # Main dbt project — retail analytics pipeline
├── tables/          # Source CSV data (dim & fact tables)
└── README.md        # This file
```

---

## The Project: maha_dbt

[`maha_dbt/`](maha_dbt/) is a fully working dbt project for a retail star schema. It covers every core dbt concept:

| Concept | Implementation |
|---|---|
| Sources | `dim_customer`, `dim_product`, `dim_store`, `dim_date`, `fact_sales`, `fact_returns` |
| Models | Bronze (views) → Silver (incremental) → Gold (tables) |
| Seeds | Date dimension, product categories, store regions, return reasons |
| Snapshots | SCD Type 2 history for customer, product, and store |
| Macros | Surrogate key, safe divide, cents-to-dollars, schema routing, grants |
| Tests | 49 data tests — `unique`, `not_null`, `relationships` |
| Analyses | Revenue trend, top products, RFM segmentation, store performance |
| Exposures | 4 downstream consumers documented |
| CI/CD | GitHub Actions — dev on PR, prod on merge |
| Docs | Full DAG with column descriptions via `dbt docs` |

See the full project documentation in [`maha_dbt/README.md`](maha_dbt/README.md).

---

## Source Data

The [`tables/`](tables/) folder contains the raw CSV files that are loaded into Databricks as source tables:

| File | Description |
|---|---|
| `fact_sales.csv` | Sales transactions |
| `fact_returns.csv` | Product returns |
| `dim_customer.csv` | Customer dimension |
| `dim_product.csv` | Product dimension |
| `dim_store.csv` | Store dimension |
| `dim_date.csv` | Date dimension |

---

## Quick Start

```bash
# 1. Set up environment
python -m venv .venv
.venv\Scripts\activate
pip install dbt-databricks==1.10.9

# 2. Configure credentials
cd maha_dbt
# Create .env with DBT_TOKEN, DBT_HOST, DBT_HTTP_PATH, DBT_PROD_CATALOG

# 3. Install packages
dbt deps

# 4. Run the pipeline
dbt build
```

Full setup instructions → [`maha_dbt/README.md`](maha_dbt/README.md)

---

## Key dbt Commands

```bash
dbt build                        # Full pipeline — seeds, models, tests, snapshots
dbt run --select tag:bronze      # Bronze layer only
dbt run --select tag:silver      # Silver layer only
dbt run --select tag:gold        # Gold layer only
dbt test                         # All data quality tests
dbt snapshot                     # SCD Type 2 history capture
dbt docs generate && dbt docs serve --port 8083   # Documentation
dbt build --target prod          # Deploy to production
```

---

## Author

**Muhammed John** — muhammedjohn3@gmail.com
