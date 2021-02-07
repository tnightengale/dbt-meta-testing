{% macro evaluate_case() %}

    {{ log("Output: " ~ varargs[0], info=true) }}

    {{ log("Expected Output: " ~ varargs[0], info=true) }}

    {{ return(varargs[0] == varargs[1]) }}

{% endmacro %}
