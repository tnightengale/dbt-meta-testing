
{% macro tests_per_model() %}
	{{ return(adapter.dispatch("tests_per_model", packages=dbt_meta_testing._get_meta_test_namespaces())())}}
{% endmacro %}

{% macro default__tests_per_model() %}

    {# /*
    Construct a dict of all models and their schema tests in the current project.
    */ #}

    {% set tests_per_model = {} %}
    {% set all_tests = dbt_meta_testing.fetch_configured_models("enabled", resource_type="test") %}

    -- currently only parsing schema tests
    {% set schema_tests = all_tests | selectattr("test_metadata", "defined") | list %}

    {% for test_node in schema_tests %}

        {{ dbt_meta_testing.logger('loop ' ~ loop.index ~ ' test_node ' ~ test_node["test_metadata"]["name"]) }}

        {% for dependent_model in test_node.depends_on.nodes %}
            {% if dependent_model.startswith('model.') %}

                -- if the model has been encountered before
                {% if dependent_model in tests_per_model.keys() %}

                    -- If the test on this model has been encountered before
                    {% if test_node["test_metadata"]["name"] in tests_per_model[dependent_model].keys() %}
                        {% do tests_per_model[dependent_model][test_node["test_metadata"]["name"]].append(test_node.unique_id) %}
                    {% else %} -- Add this test to the list of encountered tests
                        {% do tests_per_model[dependent_model].setdefault(test_node["test_metadata"]["name"], [test_node.unique_id]) %}
                    {% endif %}

                {% else %}

                    {% do tests_per_model.setdefault(dependent_model, {test_node["test_metadata"]["name"]: [test_node.unique_id]}) %}

                {% endif %}

            {% endif %}

        {% endfor %}

    {% endfor %}

     -- Create dict of empty dict with model unique_id as key to ensure all models are included
    {% set model_unique_ids = dbt_meta_testing.fetch_configured_models("enabled", resource_type="model") | 
            map(attribute="unique_id") | list %}
    {% set result = {} %}
    {% for id in model_unique_ids %}
        {% do result.update({id: {}}) %}
    {% endfor %}

    -- overwrite empty dicts if they have tests
    {% do result.update(tests_per_model) %}

    {% do return(result) %}

{% endmacro %}
