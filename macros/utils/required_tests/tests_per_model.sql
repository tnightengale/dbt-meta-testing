
{% macro tests_per_model(models_to_evaluate) %}
	{{ return(adapter.dispatch("tests_per_model", packages=dbt_meta_testing._get_meta_test_namespaces())(models_to_evaluate))}}
{% endmacro %}

{% macro default__tests_per_model(models_to_evaluate) %}

    {# /*
    Construct a dict of all models and their schema tests in the current project.
    */ #}

    -- Create dict of dict with model unique_id as key
    {% set tests_per_model = {} %}
        {% for model in models_to_evaluate %}
            {% do tests_per_model.setdefault(model.unique_id, {}) %}
        {% endfor %}

    {% set all_tests = dbt_meta_testing.fetch_configured_models("enabled", models=models_to_evaluate, resource_type="test") %}

    -- ignore integration tests
    {% set schema_tests = [] %}
        {% for test in all_tests %}
            {% if test["name"].startswith("case_") %}
                {% do schema_tests.append(test) %}
            {% endif %}
        {% endfor %}

    {% for test_node in schema_tests %}

        {{ dbt_meta_testing.logger('loop ' ~ loop.index ~ ' test_node ' ~ test_node.get("test_metadata")["name"]) }}

        {% for dependent_model in test_node.depends_on.nodes %}
            {% if dependent_model.startswith('model.') %}

                -- if the model has been encountered before
                {% if dependent_model in tests_per_model.keys() %}

                    -- If the test on this model has been encountered before
                    {% if test_node.get("test_metadata")["name"] in tests_per_model[dependent_model].keys() %}
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
                
    {{ dbt_meta_testing.logger('tests_per_model is ' ~ tests_per_model) }}
    {{ return(tests_per_model) }}

{% endmacro %}
