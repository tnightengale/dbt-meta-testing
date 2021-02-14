{% macro error_invalid_config_missing_test() %}
	{{ return(adapter.dispatch("error_invalid_config_missing_test", packages=dbt_meta_testing._get_meta_test_namespaces())(varargs))}}
{% endmacro %}

{% macro default__error_invalid_config_missing_test(varargs) %}

    {% set error %}
    Invalid +required_tests config. Could not find test: '{{ vararg[0] }}'
    {% endset %}

    {{ return(error) }}

{% endmacro %}
