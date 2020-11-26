{% macro _fetch_configured_models(meta_config) %}

{% set meta_config_models = [] %}

{% for node in graph.nodes.values() | selectattr("resource_type", "equalto", "model") %}
    {% if meta_config in node.config.keys() %}
        {% do meta_config_models.append(node) %}
    {% endif %}
{% endfor %}

{{ return(meta_config_models) }}

{% endmacro %}
    
