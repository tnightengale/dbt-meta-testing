{% macro _error_formatter(error_list) %}

{# /*
Formats a list of either strings or tuples into a bulleted list for error output.
*/ #}

    {% set output_list = [] %}

    {% for _obj in error_list %}

        {% if _obj is string %}

            {% do output_list.append(" - " ~ _obj) %}
        
        {% elif _obj is iterable %}

            {% do output_list.append(" - " ~ _obj[0] ~ "." ~ _obj[1]) %}

        {% else %}

            {{ exceptions.raise_compiler_error("List elements must be string or tuple.") }}

        {% endif %}

    {% endfor %}

    {{ return(output_list | join("\n")) }}

{% endmacro %}
