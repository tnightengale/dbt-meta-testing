{% macro config_meta_get(model_config, key) %}
    {%- if model_config.get(key) != none -%}
        {{ return(model_config.get(key)) }}
    {%- elif model_config.get("meta") != none and (key in model_config.get("meta", {}).keys()) -%}
        {{ return(model_config.get("meta").get(key)) }}
    {%- else -%}
        {{ return(none) }}
    {%- endif -%}
{% endmacro %}
