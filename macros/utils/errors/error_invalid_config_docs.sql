{% macro error_invalid_config_docs() %}
	{{ return(adapter.dispatch("error_invalid_config_docs", "dbt_meta_testing")(varargs))}}
{% endmacro %}

{% macro default__error_invalid_config_docs(varargs) %}
   
    {% set error %}
    Invalid 'required_docs' configuration.  
    Expected boolean. Received: '{{ varargs[0] }}'
    on model '{{ varargs[1] }}'
    {% endset %}

    {{ return(error) }}

{% endmacro %}
