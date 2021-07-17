{% macro validate_required_docs(models_to_validate) %}
	{{ return(adapter.dispatch("validate_required_docs", "dbt_meta_testing")(models_to_validate))}}
{% endmacro %}

{% macro default__validate_required_docs(models_to_validate) %}

    {# /*
    Validate that all +required_docs configs are bool.
    */ #}

    {{ dbt_meta_testing.logger('models to validate are ' ~ models_to_validate) }}

    {% for model in models_to_validate %}

        {% if not model.config.required_docs is boolean %}

            {{ return(dbt_meta_testing.error_invalid_config_docs(config, model.name)) }}

        {% endif %}

    {% endfor %}

    {{ return(none) }}

{% endmacro %}
