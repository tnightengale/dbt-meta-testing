{% macro refs_block() %}

    -- depends_on: {{ ref('dbt_meta_testing_integration_tests', 'model_1') }}
    -- depends_on: {{ ref('dbt_meta_testing_integration_tests', 'model_2') }}
    -- depends_on: {{ ref('dbt_meta_testing_integration_tests', 'model_3') }}

{% endmacro %}
