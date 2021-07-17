{% macro format_raise_error(error_to_raise) %}
	{{ return(adapter.dispatch("format_raise_error", "dbt_meta_testing")(error_to_raise))}}
{% endmacro %}

{% macro default__format_raise_error(error_to_raise) %}

    {% if var("running_intergration_tests", false) is true %}

        {{ return(error_to_raise) }}

    {% else %}

        {{ exceptions.raise_compiler_error(error_to_raise) }}
    
    {% endif %}

{% endmacro %}
