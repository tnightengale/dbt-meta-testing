{% macro errors_invalid_config_tests() %}
	{{ return(adapter.dispatch("errors_invalid_config_tests", "dbt_meta_testing")(varargs))}}
{% endmacro %}

{% macro default__errors_invalid_config_tests(varargs) %}

    {% set error %}
    Invalid 'required_tests' configuration.
    Expected dict or None. Received: '{{ varargs[0] }}'
    on model '{{ varargs[1] }}'
    {% endset %}

    {{ return(error) }}

{% endmacro %}
