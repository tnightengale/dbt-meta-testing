{% macro format_raise_error(error_to_raise) %}
	{{ return(adapter.dispatch("format_raise_error", packages=dbt_meta_testing._get_meta_test_namespaces())(error_to_raise))}}
{% endmacro %}

{% macro default__format_raise_error(error_to_raise) %}

    {% if var("running_intergration_tests", false) is true %}

        {{ log(error_to_raise, info=true) }}
    
    {% else %}

        {{ exceptions.raise_compiler_error(error_to_raise) }}

    {% endif %}

{% endmacro %}
