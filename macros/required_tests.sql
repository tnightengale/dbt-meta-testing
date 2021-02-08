{% macro required_tests() %}
	{{ return(adapter.dispatch("required_tests", packages=dbt_meta_testing._get_meta_test_namespaces())())}}
{% endmacro %}

{% macro default__required_tests() %}

    -- Fetch models based on config and `models` var
    {% set filtered_models = fetch_configured_models('required_tests') %}

    -- Validate configuration
    {{ dbt_meta_testing.validate_required_tests(filtered_models) }}

    -- Evaluate configuration
    {{ dbt_meta_testing.evaluate_required_tests(filtered_models) }}

{% endmacro %}
