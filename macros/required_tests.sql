{% macro required_tests() %}

    -- Fetch models based on config and `models` var
    {% set filtered_models = _fetch_configured_models('required_tests') %}

    -- Validate configuration
    {{ _validate_required_tests(filtered_models) }}

    -- Evaluate configuration
    {{ _evaluate_required_tests(filtered_models) }}

{% endmacro %}