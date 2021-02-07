{% macro _error_required_tests() %}

{% set all_errors = ["Insufficient test coverage from the 'required_tests' config on the following models:"]
    + _format_error_tests(varargs[0]) %}
    
{{ _format_raise_error(all_errors | join('\n')) }}

{% endmacro %}
