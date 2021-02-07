
-- {% set output_yaml %}
-- models_missing_descriptions: [model_1, model_2]
-- models_missing_columns: [[model_3, id], [model_3, new], [model_2, new]]
-- columns_missing_descriptions: [[model_1, id]]
-- {% endset %}

-- {{ required_docs() }}

-- {% set expected_output = fromyaml(output_yaml) %}

-- {% set result = evaluate_case(output, expected_output) %}

-- {% if result != true %}

--     select 1 as error

-- {% endif %}
