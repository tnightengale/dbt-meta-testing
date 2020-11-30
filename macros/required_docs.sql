{% macro required_docs() %}

-- Filter models with required_docs config
{% set filtered_models = _fetch_configured_models('required_docs') %}

-- Check that all configured tests are defined
{{ _validate_required_docs(filtered_models) }}

-- Evaluate if any models fail their test minimums
{{ _evaluate_required_docs(filtered_models) }}

{% endmacro %}