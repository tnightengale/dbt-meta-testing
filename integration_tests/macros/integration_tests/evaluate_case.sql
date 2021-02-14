{% macro evaluate_case() %}

    {{ log("Actual Output: " ~ varargs[0], info=true) }}

    {{ log("Expected Output: " ~ varargs[1], info=true) }}

    {% set output_equals_expected = varargs[0] == varargs[1] %}

    select 'integration_test_failed' as errors
    {# /* Filter to 0 records if test passes. */ #}
    {% if output_equals_expected %} limit 0 {% endif %}


{% endmacro %}
