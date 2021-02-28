{% macro required_tests(models=none) %}
	{{ return(adapter.dispatch("required_tests", dbt_meta_testing._get_meta_test_namespaces())(models)) }}
{% endmacro %}

{% macro default__required_tests(models) %}


    -- Fetch models based on config and `models` var
    {% set filtered_models = dbt_meta_testing.fetch_configured_models('required_tests', models) %}


    -- Validate configuration
    {% set any_error = dbt_meta_testing.validate_required_tests(filtered_models) %}
    {% if any_error is not none %}
    
        {{ return(dbt_meta_testing.format_raise_error(any_error)) }}
        
    {% endif %}

    -- Evaluate configuration
    {% set any_error = dbt_meta_testing.evaluate_required_tests(filtered_models) %}

    {% if any_error is not none %}

        {% set result = dbt_meta_testing.format_raise_error(any_error) %}

    {% else %}

        {% set result = "Success. `required_tests` passed." %}
        {% if not var("running_intergration_tests", false) is true %}{{ log(result, info=true) }}{% endif %}

    {% endif %}

    {{ return(result) }}

{% endmacro %}
