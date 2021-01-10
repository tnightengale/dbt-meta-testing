{% macro _evaluate_required_docs(models_to_evaluate) %}

    {# /*
    Evaluate if each model meets +required_docs config.
    */ #}

    {% set missing_model_errors = [] %}
    {% set missing_columns_errors = [] %}
    {% set missing_description_errors = [] %}

    {% for model in models_to_evaluate %}

        {% set model_columns = adapter.get_columns_in_relation(ref(model.package_name, model.name)) 
            | map(attribute="column") | list %}
        {{ logger(model_columns | map(attribute="column") | list) }}

        {% if model.description == "" %}

            {% do missing_model_errors.append(model.name) %}

        {% endif %}

        {% for column in model_columns %}

            {% set column = column | lower %}

            {% if column in model.columns.keys() %}

                {{ logger(column ~ " is in " ~ model.columns.keys()) }}
                {% if model.columns[column].description == "" %}

                    {% do missing_description_errors.append((model.name, column)) %}

                {% endif %}
            
            {% else %}

                {% do missing_columns_errors.append((model.name, column)) %}

            {% endif %}

        {% endfor %}

    {% endfor %}

    {% set errors = missing_model_errors + missing_columns_errors + missing_description_errors %}
    {% if errors | length > 0 %}

        {{ logger(missing_model_errors) }}
        {{ logger(missing_columns_errors) }}
        {{ logger(missing_description_errors) }}

        {{ _error_handler(
            "ERROR REQUIRED DOCS", 
            models_missing_descriptions=missing_model_errors, 
            models_missing_columns=missing_columns_errors,
            columns_missing_descriptions=missing_description_errors)
        }}

    {% endif %}

{% endmacro %}
