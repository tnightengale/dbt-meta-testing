{% macro _validate_required_tests(models_to_validate) %}

{# /*
Validate that all required_tests configs are either dict or None.

Validate that all keys in a dict are defined tests.
*/ #}

{{ logger('models to validate are ' ~ models_to_validate) }}


-- fetch unique tests from +required_tests config
{% set all_required_tests = [] %}

{% for _model in models_to_validate %}

    {% set _config = _model.config.required_tests %}

    {{ logger('_config is: ' ~ _config) }}

    -- validate that _config is dict or none
    {% if _config is mapping %}

        {% for _k in _config.keys() %} 

            {% do all_required_tests.append(_k) %}

        {% endfor %}
    
    {% elif _config is none %}
        
        -- pass
        {{ log("_model '" ~ _model.name ~ "' has required_tests=null") }}
    ß
    {% else %}

        {{ exceptions.raise_compiler_error(
            "Invalid 'required_tests' configuration. " ~
            "Expected dict or None. Received: '" ~ _config ~ "' " ~
            "on model '" ~ _model ~ "'") }}
    
    {% endif %}

{% endfor %}


{% set unique_required_tests = all_required_tests | unique | list %}

{{ logger('unique_required_tests: ' ~ unique_required_tests) }}


-- fetch unique defined tests from graph
{% set unique_defined_tests = [] %}

{% for test_name in graph.nodes.values() 
    | selectattr("resource_type", "equalto", "test")
    | map(attribute="test_metadata")
    | map(attribute="name") 
    | unique %}

    {{ logger('test name ' ~ loop.index ~ ' ' ~ test_name) }}

    {% do unique_defined_tests.append(test_name) %}

{% endfor %}


-- validate all configured tests are defined 
{% for required_test in unique_required_tests %}

    {% if required_test not in unique_defined_tests %}

        {{ exceptions.raise_compiler_error(
            "Invalid +required_tests config. Could not find test: '" ~ required_test ~ "'") }}

    {% endif %}

{% endfor %}


{% endmacro %}