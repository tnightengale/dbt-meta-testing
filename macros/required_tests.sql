{% macro required_tests() %}

-- Filter models with required_tests_config
{% set filtered_models = _fetch_configured_models('required_tests') %}

-- Check that all configured tests are defined
{{ _validate_required_tests(filtered_models) }}

-- Evaluate if any models fail their test minimums
{{ _evaluate_required_tests(filtered_models) }}

{% endmacro %}