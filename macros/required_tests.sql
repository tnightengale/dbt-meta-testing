{% macro required_tests() %}

-- Filter models with test checks
{% set models_to_validate = _fetch_configured_models('required_tests') %}

-- Check that all configured tests are defined
{{ _validate_required_tests(models_to_validate) }}

-- #TO DO: Evaluate if any models fail their test minimums


{% endmacro %}