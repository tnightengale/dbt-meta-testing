{% macro _error_invalid_config_docs() %}
   
   {{ _format_raise_error(
                "Invalid 'required_docs' configuration. " ~
                "Expected boolean. Received: '" ~ varargs[0] ~ "' " ~
                "on model '" ~ varargs[1]~ "'") }}

{% endmacro %}
