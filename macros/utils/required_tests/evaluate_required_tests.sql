{% macro evaluate_required_tests(models_to_evaluate) %}
	{{ return(adapter.dispatch("evaluate_required_tests", packages=dbt_meta_testing._get_meta_test_namespaces())(models_to_evaluate))}}
{% endmacro %}

{% macro default__evaluate_required_tests(models_to_evaluate) %}

    {# /*
    Evaluate if each model meets +required_tests minimum.
    */ #}

    {% set tests_per_model = tests_per_model() %}
    {% set test_errors = [] %}

    {{ dbt_meta_testing.logger("models_to_evaluate: " ~ models_to_evaluate | map(attribute="name") | list) }}
    {% for model in models_to_evaluate %}

        -- If required_tests is dictionary
        {% if model.config.required_tests is mapping %}
        {{ dbt_meta_testing.logger(model.name ~ " if reached") }}


            {% for test_key in model.config.required_tests.keys() %}

                -- If the model has less tests than required by the config
                {% set full_model = model.unique_id %}
                {{ dbt_meta_testing.logger(tests_per_model[full_model][test_key] | length) }}

                {% set provided_test_count = tests_per_model[full_model][test_key] | length %}

                {% set required_test_count = model.config.required_tests[test_key] %}

                {{ dbt_meta_testing.logger(
                    "test_key_loop | test_key: " ~ test_key ~ 
                    " model: " ~ model.name ~
                    " provided_test_count: " ~ provided_test_count ~
                    " required_test_count: " ~ required_test_count) }}

                {% if provided_test_count < required_test_count %} 

                    {% do test_errors.append((model.name, test_key, provided_test_count, required_test_count)) %}

                {% endif %}
            
            {% endfor %}
        
        {% endif %}

    {% endfor %}


    {% if test_errors | length > 0 %}

        {{ dbt_meta_testing.error_required_tests(test_errors) }}

    {% endif %}

{% endmacro %}
