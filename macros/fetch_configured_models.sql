{% macro fetch_configured_models(meta_config, models=none, resource_type="model") %}
	{{ return(adapter.dispatch("fetch_configured_models", "dbt_meta_testing")(meta_config, models, resource_type)) }}
{% endmacro %}

{% macro default__fetch_configured_models(meta_config, models, resource_type) %}

    {% set configured_models = [] %}

    {{ dbt_meta_testing.logger("var `models` is: " ~ models) }}

    {% for node in graph.nodes.values() | selectattr("resource_type", "equalto", resource_type) %}

        {% if meta_config in node.config.keys() %}

            {% do configured_models.append(node) %}

        {% endif %}

    {% endfor %}

    /* 
    If arg `models` is provided, filter fetched models to only those
    provided, either in space delimited string or via `dbt list -m <selection_syntax>`.

    See documentation here for more details: https://github.com/tnightengale/quality-assurance-dbt.
    */
    {% if models is not none and resource_type == "model" %}

        {% set filtered_models_list = [] %}
        {% set final_models_list = [] %}
        {% set models_list = models.split(" ") %}

        {{ dbt_meta_testing.logger("Building `filtered_models_list`:") }}
        {% for m in models_list %}

            /* 
            Assumes "." delimited string is output from `dbt list` and the last
            delimitee is the model name, eg. dbt_meta_testing.example.model_1
            */
            {% if "." in m %} {% set m = m.split(".")[-1] %} {% endif %}

            {% do filtered_models_list.append(m) %}
            {{ dbt_meta_testing.logger("Appended to `filtered_models_list`: " ~ m) }}

        {% endfor %}

        {{ dbt_meta_testing.logger("`filtered_models_list` is: " ~ filtered_models_list) }}
        {% for m in configured_models %}


            {{ dbt_meta_testing.logger("`filtered_models_loop: " ~ loop.index ~ " " ~ m.name in filtered_models_list)}}
            {% if m.name in filtered_models_list %}

                {% do final_models_list.append(m) %}
                {{ dbt_meta_testing.logger("m is: " ~ m) }}
            
            {% endif %}

        {% endfor %}
    
    {% else %}

        {{ dbt_meta_testing.logger("else in fetch models triggered, configured is: " ~ configured_models) }}
        {% set final_models_list = configured_models %}

    {% endif %}

    {{ dbt_meta_testing.logger("`final_models_list` is: " ~ final_models_list) }}
    {{ return(final_models_list) }}

{% endmacro %}
