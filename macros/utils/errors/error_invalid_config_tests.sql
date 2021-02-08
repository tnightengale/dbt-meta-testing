{% macro errors_invalid_config_tests() %}
	{{ return(adapter.dispatch("errors_invalid_config_tests", packages=dbt_meta_testing._get_meta_test_namespaces())())}}
{% endmacro %}

{% macro default__errors_invalid_config_tests() %}

{{ dbt_meta_testing.format_raise_error(
    "Invalid 'required_tests' configuration. " ~
    "Expected dict or None. Received: '" ~ varargs[0] ~ "' " ~
    "on model '" ~ varargs[1] ~ "'") }}

{% endmacro %}
