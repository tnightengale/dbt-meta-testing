{% macro _format_error_tests(error_list) %}

{# /*
Formats a list of tuples into a bulleted list for error output in _error_required_tests.
*/ #}

    {% set output_list = [] %}

    {% for _obj in error_list %}

        {% if _obj is iterable %}

            {% do output_list.append("- Model: '" ~ _obj[0] ~ "' Test: '" ~ _obj[1] ~ "' Got: " ~ _obj[2] ~ " Expected: "  ~ _obj[3]) %}

        {% else %}

            {{ exceptions.raise_compiler_error("List elements must be ordered tuple of (model, test, required, provided).") }}

        {% endif %}

    {% endfor %}

    {{ return(output_list) }}

{% endmacro %}
