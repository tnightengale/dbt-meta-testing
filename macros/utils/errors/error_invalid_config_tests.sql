{% macro _errors_invalid_config_tests() %}

{{ _format_raise_error(
    "Invalid 'required_tests' configuration. " ~
    "Expected dict or None. Received: '" ~ varargs[0] ~ "' " ~
    "on model '" ~ varargs[1] ~ "'") }}

{% endmacro %}
