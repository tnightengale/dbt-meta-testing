{% macro evaluate_required_tests(models_to_evaluate) %}
	{{ return(adapter.dispatch("evaluate_required_tests", "dbt_meta_testing")(models_to_evaluate))}}
{% endmacro %}

{% macro default__evaluate_required_tests(models_to_evaluate) %}

    {# /*
    Evaluate if each model meets +required_tests minimum.
    */ #}
    
    {% set tests_per_model = dbt_meta_testing.tests_per_model() %}
    {% set test_errors = [] %}

    {% for model in models_to_evaluate %}{% if model.config.required_tests is mapping %}
        {% for test_key in model.config.required_tests.keys() %}

            {% set provided_test_list = tests_per_model[model.unique_id] %}

            {% set required_test_count = model.config.required_tests[test_key] %}
            {% set matching_test_count = dbt_meta_testing.get_regex_match_count(provided_test_list, test_key) %}
            
            {% if matching_test_count < required_test_count %} 
                {% do test_errors.append((model.name, test_key, matching_test_count, required_test_count)) %}
            {% endif %}
            
        {% endfor %}{% endif %}
    {% endfor %}


    {% if test_errors | length > 0 %}
        {% set result = dbt_meta_testing.error_required_tests(test_errors) %}
    {% else %}
        {% set result = none %}
    {% endif %}

    {{ return(result) }}

{% endmacro %}
