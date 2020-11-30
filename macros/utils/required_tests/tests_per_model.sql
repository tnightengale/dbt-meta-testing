
{% macro _tests_per_model() %}

{# /*
Construct a dict of all models and their tests in the current project.
*/ #}

{% set tests_per_model = {} %}

{% set all_tests = _fetch_configured_models("enabled", "test") %}

{% for test_node in all_tests %}

    {{ logger('loop ' ~ loop.index ~ ' test_node ' ~ test_node.test_metadata.name) }}

    {% for dependent_model in test_node.depends_on.nodes %}
        {% if dependent_model.startswith('model.') %}

            -- if the model has been encountered before
            {% if dependent_model in tests_per_model.keys() %}

                -- if the test on this model has been encountered before
                {% if test_node.test_metadata.name in tests_per_model[dependent_model].keys() %}
                    {% do tests_per_model[dependent_model][test_node.test_metadata.name].append(test_node.unique_id) %}
                {% else %} -- add this test to the list of encountered tests
                    {% do tests_per_model[dependent_model].setdefault(test_node.test_metadata.name, [test_node.unique_id]) %}
                {% endif %}

            {% else %}

                {% do tests_per_model.setdefault(dependent_model, {test_node.test_metadata.name: [test_node.unique_id]}) %}

            {% endif %}

        {% endif %}

    {% endfor %}

{% endfor %}
            
{{ logger('tests_per_model is ' ~ tests_per_model) }}
{{ return(tests_per_model) }}

{% endmacro %}