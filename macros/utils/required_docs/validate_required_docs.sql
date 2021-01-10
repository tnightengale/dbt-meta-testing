{% macro _validate_required_docs(models_to_validate) %}

    {# /*
    Validate that all +required_docs configs are bool.
    */ #}

    {{ logger('models to validate are ' ~ models_to_validate) }}

    {% for model in models_to_validate %}

        {% if not model.config.required_docs is boolean %}

            {{ _error_invalid_config_docs(_config, _model.name) }}

        {% endif %}

    {% endfor %}

{% endmacro %}
