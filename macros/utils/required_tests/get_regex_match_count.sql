{% macro get_regex_match_count(list_of_strings, regex_to_check) %}
	{{ return(adapter.dispatch("get_regex_match_count", "dbt_meta_testing")(list_of_strings, regex_to_check))}}
{% endmacro %}

{% macro default__get_regex_match_count(list_of_strings, regex_to_check) %}

    {# Return count of strings in list_of_strings that match regex_to_check #}
    {% set matches = [] %}
    {% for string in list_of_strings %}
        {% set match = modules.re.fullmatch(regex_to_check, string) %}
        {% if match %}{% do matches.append(match) %}{% endif %}
    {% endfor %}

    {% do return(matches | length) %}

{% endmacro %}
