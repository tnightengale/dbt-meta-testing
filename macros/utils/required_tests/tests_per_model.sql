
{% macro tests_per_model() %}
	{{ return(adapter.dispatch("tests_per_model", "dbt_meta_testing")())}}
{% endmacro %}

{% macro default__tests_per_model() %}

    {# /*
    Construct a dict of all models and their schema tests in the current project.
    */ #}

    {% set enabled_model_names = dbt_meta_testing.fetch_configured_models("enabled", resource_type="model") | map(attribute="unique_id") | list %}
    {% set enabled_test_nodes = dbt_meta_testing.fetch_configured_models("enabled", resource_type="test") %}
    
    -- Create `result` dict with all enabled models unique_id's as keys and empty lists as values
    {% set result = {} %}
    {% for id in enabled_model_names %}{% do result.update({id: []}) %}{% endfor %}
    
    {% for test_node in enabled_test_nodes %}
        {% for dependent_node in test_node.depends_on.nodes %}
            {% if dependent_node.startswith('model.') %}
                -- Use common names for schema tests, (e.g. "unique") under the "test_metadata" key
                {% set test_identifier = test_node.get("test_metadata",{}).get("name") or test_node["name"] %}
                {% do result[dependent_node].append(test_identifier) %}
            {% endif %}
        {% endfor %}
    {% endfor %}

    {% do return(result) %}

{% endmacro %}
