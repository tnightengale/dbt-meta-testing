{% macro _error_invalid_config_missing_test() %}

{{ _format_raise_error(
    "Invalid +required_tests config. Could not find test: '" ~ vararg[0] ~ "'") }}

{% endmacro %}
