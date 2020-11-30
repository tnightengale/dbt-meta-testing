{% macro _validate_required_docs(models_to_validate) %}

{# /*
Validate that all required_docs configs are bool.
*/ #}

    {{ logger('models to validate are ' ~ models_to_validate) }}

    {% for model in models_to_validate %}

        {% if not model.config.required_docs is boolean %}

            {{ exceptions.raise_compiler_error(
                "Invalid 'required_docs' configuration. " ~
                "Expected boolean. Received: '" ~ _config ~ "' " ~
                "on model '" ~ _model ~ "'") }}

        {% endif %}

    {% endfor %}

{% endmacro %}