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




