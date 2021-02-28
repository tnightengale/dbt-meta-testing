{% macro required_docs(models=none) %}
	{{ return(adapter.dispatch("required_docs", dbt_meta_testing._get_meta_test_namespaces())(models))}}
{% endmacro %}

{% macro default__required_docs(models) %}

    -- Fetch models based on config and `models` var
    {% set filtered_models = dbt_meta_testing.fetch_configured_models('required_docs', models) %}

    -- Validate configuration
    {% set any_error = dbt_meta_testing.validate_required_docs(filtered_models) %}
    {% if any_error is not none %}

        {% set result = dbt_meta_testing.format_raise_error(any_error) %}
        
    -- Evaluate configuration
    {% else %}

        {% set any_error = dbt_meta_testing.evaluate_required_docs(filtered_models) %}
        {% if any_error is not none %}
        
            {% set result = dbt_meta_testing.format_raise_error(any_error) %}

        {% else %}

            {% set result = "Success: `required_docs` passed." %}

        {% endif %}

    {% endif %}

    {{ return(result) }}

{% endmacro %}
