
{% macro tests_per_model() %}
	{{ return(adapter.dispatch("tests_per_model", packages=dbt_meta_testing._get_meta_test_namespaces())())}}
{% endmacro %}

{% macro default__tests_per_model() %}

    {# /*
    Construct a dict of all models and their tests in the current project.
    */ #}

    {% set tests_per_model = {} %}

    {% set all_tests = fetch_configured_models("enabled", "test") %}

    {% for test_node in all_tests %}

        {{ dbt_meta_testing.logger('loop ' ~ loop.index ~ ' test_node ' ~ test_node.test_metadata.name) }}

        {% for dependent_model in test_node.depends_on.nodes %}
            {% if dependent_model.startswith('model.') %}

                -- If the model has been encountered before
                {% if dependent_model in tests_per_model.keys() %}

                    -- If the test on this model has been encountered before
                    {% if test_node.test_metadata.name in tests_per_model[dependent_model].keys() %}
                        {% do tests_per_model[dependent_model][test_node.test_metadata.name].append(test_node.unique_id) %}
                    {% else %} -- Add this test to the list of encountered tests
                        {% do tests_per_model[dependent_model].setdefault(test_node.test_metadata.name, [test_node.unique_id]) %}
                    {% endif %}

                {% else %}

                    {% do tests_per_model.setdefault(dependent_model, {test_node.test_metadata.name: [test_node.unique_id]}) %}

                {% endif %}

            {% endif %}

        {% endfor %}

    {% endfor %}
                
    {{ dbt_meta_testing.logger('tests_per_model is ' ~ tests_per_model) }}
    {{ return(tests_per_model) }}

{% endmacro %}
