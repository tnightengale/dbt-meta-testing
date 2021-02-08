
{% set output_yaml %}
models_missing_descriptions: [model_1, model_2]
models_missing_columns: [[model_3, id], [model_3, new], [model_2, new]]
columns_missing_descriptions: [[model_1, id]]
{% endset %}

{% set actual_output = dbt_meta_testing.required_docs() %}

{% set expected_output = fromyaml(output_yaml) %}

{{ evaluate_case(actual_output, expected_output) }}
