{% macro error_invalid_config_missing_test() %}
	{{ return(adapter.dispatch("error_invalid_config_missing_test", packages=dbt_meta_testing._get_meta_test_namespaces())())}}
{% endmacro %}

{% macro default__error_invalid_config_missing_test() %}

{{ dbt_meta_testing.format_raise_error(
    "Invalid +required_tests config. Could not find test: '" ~ vararg[0] ~ "'") }}

{% endmacro %}
