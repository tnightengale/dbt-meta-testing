{% macro _validate_required_tests(models_to_validate) %}

{{ log('models to validate are ' ~ models_to_validate, info=_debug()) }}


-- fetch unique tests from +required_tests config
{% set all_required_tests = [] %}

{% for _config in models_to_validate | map(attribute='config') | map(attribute='required_tests') %}

    {% for _k in _config.keys() %} 

        {% do all_required_tests.append(_k) %}

    {% endfor %}

{% endfor %}


{% set unique_required_tests = all_required_tests | unique | list %}

{{ log('unique_required_tests: ' ~ unique_required_tests, info=_debug()) }}


-- fetch unique defined tests from graph
{% set unique_defined_tests = [] %}

{% for test_name in graph.nodes.values() 
    | selectattr("resource_type", "equalto", "test")
    | map(attribute="test_metadata")
    | map(attribute="name") 
    | unique %}

    {{ log('test name ' ~ loop.index ~ ' ' ~ test_name, info=_debug()) }}

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