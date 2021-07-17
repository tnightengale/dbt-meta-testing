{% macro error_required_tests() %}
	{{ return(adapter.dispatch("error_required_tests", "dbt_meta_testing")(varargs))}}
{% endmacro %}

{% macro default__error_required_tests(varargs) %}

    {% set all_errors = ["Insufficient test coverage from the 'required_tests' config on the following models:"]
        + dbt_meta_testing.format_error_tests(varargs[0]) %}
        
    {{ return(all_errors | join('\n')) }}

{% endmacro %}
