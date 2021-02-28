/*
Test case for full required_tests run.
*/

{{ refs_block() }}
{% if execute %}

    {% set actual_output = dbt_meta_testing.required_tests() %}

    {% set expected_output = dbt_meta_testing.errors_invalid_config_tests(true, "model_1") %}

    {{ evaluate_case(actual_output, expected_output) }}

{% endif %}
