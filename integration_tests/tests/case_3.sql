/*
Test case for full required_tests on model_1.
*/

{{ refs_block() }}
{% if execute %}

    {% set actual_output = dbt_meta_testing.required_tests("model_3") %}

    {% set expected_output = dbt_meta_testing.error_required_tests([["model_3", "unique", 0, 1]]) %}

    {{ evaluate_case(actual_output, expected_output) }}

{% endif %}
