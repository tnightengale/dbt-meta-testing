{% macro validate_required_tests(models_to_validate) %}
	{{ return(adapter.dispatch("validate_required_tests", "dbt_meta_testing")(models_to_validate))}}
{% endmacro %}

{% macro default__validate_required_tests(models_to_validate) %}

    {# /*
    Validate that all +required_tests configs are either dict or None 
    and that all keys in a dict are defined tests.
    */ #}

    {{ dbt_meta_testing.logger('models to validate are ' ~ models_to_validate) }}

    -- # TO DO: break out into function that asserts against a contract
    -- Fetch unique tests from +required_tests config
    {% set all_required_tests = [] %}

    {% for model in models_to_validate %}

        {% set config = model.config.required_tests %}

        {{ dbt_meta_testing.logger('config is: ' ~ config) }}

        -- Validate that config is dict or none
        {% if config is mapping %}

            {% for k in config.keys() %} 

                {% do all_required_tests.append(k) %}

            {% endfor %}
        
        {% elif config is none %}
            
            -- Pass
            {{ dbt_meta_testing.logger("model '" ~ model.name ~ "' has required_tests=null") }}
        
        {% else %}

            {{ return(dbt_meta_testing.errors_invalid_config_tests(config, model.name)) }}
        
        {% endif %}

    {% endfor %}


    {% set unique_required_tests = all_required_tests | unique | list %}

    {{ dbt_meta_testing.logger('unique_required_tests: ' ~ unique_required_tests) }}


    -- Fetch unique defined tests from graph
    {% set unique_defined_tests = [] %}

    {% for test_name in graph.nodes.values() 
        | selectattr("resource_type", "equalto", "test")
        | selectattr("test_metadata", "defined")
        | map(attribute="test_metadata")
        | map(attribute="name") 
        | unique %}

        {{ dbt_meta_testing.logger('test name ' ~ loop.index ~ ' ' ~ test_name) }}

        {% do unique_defined_tests.append(test_name) %}

    {% endfor %}

    {{ return(none) }}

{% endmacro %}
