/*
Test case for full required_docs run.
*/

{{ refs_block() }}
{% if execute %}

    {% set missing_model_errors = ["model_3", "model_2"] %}
    {% set missing_columns_errors = [["model_3", "id"], ["model_3", "new"], ["model_2", "new"]] %}
    {% set missing_description_errors = [["model_1", "id"]] %}

    {% set actual_output = dbt_meta_testing.required_docs() %}

    {% set expected_output = dbt_meta_testing.error_required_docs(
            missing_model_errors, 
            missing_columns_errors, 
            missing_description_errors) %}

    {{ evaluate_case(actual_output, expected_output) }}

{% endif %}
