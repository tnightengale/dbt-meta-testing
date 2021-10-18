{% macro format_error_docs(error_list) %}
	{{ return(adapter.dispatch("format_error_docs", "dbt_meta_testing")(error_list))}}
{% endmacro %}

{% macro default__format_error_docs(error_list) %}

{# /*
Formats a list of either strings or tuples into a bulleted list for error output in error_required_docs.
*/ #}

    {% set output_list = [] %}

    {% for obj in error_list %}

        {% if obj is string %}

            {% do output_list.append(" - " ~ obj) %}

        {% elif obj is iterable %}

            {% do output_list.append(" - " ~ obj[0] ~ "." ~ obj[1]) %}

        {% else %}

            {{ exceptions.raise_compiler_error("List elements must be string or tuple.") }}

        {% endif %}

    {% endfor %}

    {{ return(output_list | sort | join("\n")) }}

{% endmacro %}
