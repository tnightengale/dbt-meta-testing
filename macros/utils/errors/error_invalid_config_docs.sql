{% macro error_invalid_config_docs() %}
	{{ return(adapter.dispatch("error_invalid_config_docs", packages=dbt_meta_testing._get_meta_test_namespaces())())}}
{% endmacro %}

{% macro default__error_invalid_config_docs() %}
   
    {% set error %}
    Invalid 'required_docs' configuration.  
    Expected boolean. Received: '{{ varargs[0] }}'
    on model '{{ varargs[1] }}'
    {% endset %}
    
    {{ return(error) }}

{% endmacro %}
