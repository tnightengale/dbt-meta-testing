{% macro _evaluate_required_tests(models_to_evaluate) %}

    {# /*
    Evaluate if each model meets +required_tests minimum.
    */ #}

    {% set tests_per_model = _tests_per_model() %}
    {% set errors = [] %}

    {{ logger("models_to_evaluate: " ~ models_to_evaluate | map(attribute="name") | list) }}
    {% for model in models_to_evaluate %}

        -- If required_tests is dictionary
        {% if model.config.required_tests is mapping %}
        {{ logger(model.name ~ " if reached") }}


            {% for test_key in model.config.required_tests.keys() %}

                -- If the model has less tests than required by the config
                {% set full_model = model.unique_id %}
                {{ logger(tests_per_model[full_model][test_key] | length) }}

                {% set provided_test_count = tests_per_model[full_model][test_key] | length %}

                {% set required_test_count = model.config.required_tests[test_key] %}

                {{ logger(
                    "test_key_loop | test_key: " ~ test_key ~ 
                    " model: " ~ model.name ~
                    " provided_test_count: " ~ provided_test_count ~
                    " required_test_count: " ~ required_test_count) }}

                {% if provided_test_count < required_test_count %} 
                    {% do errors.append(
                        "Model: '" ~ model.name ~ 
                        "' Test: '" ~ test_key ~ "' Got: " ~ provided_test_count ~
                        " Expected: "  ~ required_test_count
                    ) %}
                {% endif %}
            
            {% endfor %}
        
        {% endif %}

    {% endfor %}


    {% if errors | length > 0 %}

        {{ exceptions.raise_compiler_error(
            "Insufficient test coverage from the 'required_tests' config on the following models: \n"
            ~ errors | join('\n')
        ) }} 

    {% endif %}

{% endmacro %}
