{% macro _debug() %}

{{ return(env_var("QUALITY_ASSURANCE_DBT_LOGGING", false)) }}

{% endmacro %}