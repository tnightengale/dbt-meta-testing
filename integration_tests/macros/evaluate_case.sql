{% macro evaluate_case() %}

-- depends_on: {{ ref('dbt_meta_testing_integration_tests', 'model_1') }}
-- depends_on: {{ ref('dbt_meta_testing_integration_tests', 'model_2') }}
-- depends_on: {{ ref('dbt_meta_testing_integration_tests', 'model_3') }}

    {% if execute %}

        {{ log("Actual Output: " ~ varargs[0], info=true) }}

        {{ log("Expected Output: " ~ varargs[1], info=true) }}

        {% set output_equals_expected = varargs[0] == varargs[1] %}

        select
            1 as result
        {# /* Filter to 0 records if test passes. */ #}
        {% if output_equals_expected %} where result != 1 {% endif %}

    {% endif %}

{% endmacro %}
