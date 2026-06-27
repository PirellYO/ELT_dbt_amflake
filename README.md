## .env installation

``` python - m venv venv ```

## activation of venv

``` venv/scripts/activate ```

## install the connector dbt-snowflake

``` pip install dbt-snowflake ```

## initialization of dbt project

``` dbt init olist_analytics ```

# fill user credentials and configs

## start dbt 
 - Validate the dbt connection // Check the profiles.yml
``` dbt debug ``` 
 - Install dependencies
``` dbt deps ```
 - Run 
``` dbt run ```

## Run seeder
``` dbt seed ```

## Run a specific model
``` dbt run --select "name_model" ```

## Run tests

``` dbt test ```

## Run snapshot

``` dbt snapshot ``` 

## Generate docs

``` dbt docs generate ```
``` dbt docs serve ```

## Utils commands

dbt run --select staging          # construire uniquement la couche staging
dbt run --select fct_orders+      # un modèle et tout ce qui en dépend
dbt build                         # seed + run + test + snapshot en une commande
dbt compile                       # générer le SQL sans l'exécuter

## Architecture

Fichiers CSV (Olist)
        |
        v
   Amazon S3                         (zone de dépôt)
        |
        v  COPY INTO
   Snowflake — schéma RAW            (copie fidèle de la source, jamais modifiée)
        |
        v  dbt
   ┌─────────────────────────────────────────────┐
   │  staging       vues, nettoyage et typage     │
   │  intermediate  logique métier, jointures     │
   │  marts         modèle en étoile (dim / fct)   │
   └─────────────────────────────────────────────┘
        |
        v
   Power BI / Looker

## Dataset

Link : https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce



