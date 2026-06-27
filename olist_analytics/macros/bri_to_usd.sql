{% macro clean_price(price) %}
    {{ return(price | replace('R$', '') | replace('.', '') | replace(',', '.') | float) }}
{% endmacro %}