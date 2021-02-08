{% macro error_required_tests() %}
	{{ return(adapter.dispatch("error_required_tests", packages=dbt_meta_testing._get_meta_test_namespaces())())}}
{% endmacro %}

{% macro default__error_required_tests() %}

{% set all_errors = ["Insufficient test coverage from the 'required_tests' config on the following models:"]
    + format_error_tests(varargs[0]) %}
    
{{ dbt_meta_testing.format_raise_error(all_errors | join('\n')) }}

{% endmacro %}
