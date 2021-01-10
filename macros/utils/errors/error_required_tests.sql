{% macro _error_required_tests() %}

{% set all_errors = ["Insufficient test coverage from the 'required_tests' config on the following models:"]
    + _format_error_tests(varargs[0]) %}
    
{{ exceptions.raise_compiler_error(all_errors | join('\n')) }}

{% endmacro %}
