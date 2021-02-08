{% macro required_docs() %}
	{{ return(adapter.dispatch("required_docs", dbt_meta_testing._get_meta_test_namespaces())())}}
{% endmacro %}

{% macro default__required_docs() %}

{% if execute %}
    -- Fetch models based on config and `models` var
    {% set filtered_models = dbt_meta_testing.fetch_configured_models('required_docs') %}

    -- Validate configuration
    {{  dbt_meta_testing.validate_required_docs(filtered_models) }}

    -- Evaluate configuration
    {{  dbt_meta_testing.evaluate_required_docs(filtered_models) }}
{% endif %}
{% endmacro %}
