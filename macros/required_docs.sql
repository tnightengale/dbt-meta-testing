{% macro required_docs() %}

    -- Fetch models based on config and `models` var
    {% set filtered_models = _fetch_configured_models('required_docs') %}

    -- Validate configuration
    {{ _validate_required_docs(filtered_models) }}

    -- Evaluate configuration
    {{ _evaluate_required_docs(filtered_models) }}

{% endmacro %}