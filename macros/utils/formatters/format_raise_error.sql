{% macro _format_raise_error(error_to_raise) %}

    {% if var("running_intergration_tests", false) %}

        {{ log(error_to_raise, info=true) }}
    
    {% else %}

        {{ exceptions.raise_compiler_error(error_to_raise) }}

    {% endif %}

{% endmacro %}
