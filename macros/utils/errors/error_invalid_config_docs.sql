{% macro _error_invalid_config_docs() %}
   
   {{ exceptions.raise_compiler_error(
                "Invalid 'required_docs' configuration. " ~
                "Expected boolean. Received: '" ~ varargs[0] ~ "' " ~
                "on model '" ~ varargs[1]~ "'") }}

{% endmacro %}
