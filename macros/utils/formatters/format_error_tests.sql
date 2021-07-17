{% macro format_error_tests(error_list) %}
	{{ return(adapter.dispatch("format_error_tests", "dbt_meta_testing")(error_list))}}
{% endmacro %}

{% macro default__format_error_tests(error_list) %}

{# /*
Formats a list of tuples into a bulleted list for error output in error_required_tests.
*/ #}

    {% set output_list = [] %}

    {% for obj in error_list %}

        {% if obj is iterable %}

            {% do output_list.append("- Model: '" ~ obj[0] ~ "' Test: '" ~ obj[1] ~ "' Got: " ~ obj[2] ~ " Expected: "  ~ obj[3]) %}

        {% else %}

            {{ exceptions.raise_compiler_error("List elements must be ordered tuple of (model, test, required, provided).") }}

        {% endif %}

    {% endfor %}

    {{ return(output_list) }}

{% endmacro %}
