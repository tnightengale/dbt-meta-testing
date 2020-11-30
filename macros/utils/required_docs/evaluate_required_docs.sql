{% macro _evaluate_required_docs(models_to_evaluate) %}

    {# /*
    Evaluate if each model meets +required_docs config.
    */ #}

    {% set missing_model_errors = ["The following models are missing descriptions:"] %}
    {% set missing_columns_errors = ["The following columns are missing from the model yml:"] %}
    {% set missing_description_errors = ["The following columns are present in the model yml, but have blank descriptions:"] %}

    {% for model in models_to_evaluate %}

        {% set model_columns = adapter.get_columns_in_relation(ref(model.package_name, model.name)) 
            | map(attribute="column") | list %}
        {{ logger(model_columns | map(attribute="column") | list) }}

        {% if model.description == "" %}

            {% do missing_model_errors.append(" - " ~ model.name) %}

        {% endif %}

        {% for column in model_columns %}

            {% set column = column | lower %}

            {% if column in model.columns.keys() %}

                {{ logger(column ~ " is in " ~ model.columns.keys()) }}
                {% if model.columns[column].description == "" %}

                    {% do missing_description_errors.append(" - " ~ model.name ~ "." ~ column) %}

                {% endif %}
            
            {% else %}

                {% do missing_columns_errors.append(" - " ~ model.name ~ "." ~ column) %}

            {% endif %}

        {% endfor %}

    {% endfor %}

    {% set no_errors = [] %}

        {{ logger(missing_model_errors) }}
        {{ logger(missing_columns_errors) }}
        {{ logger(missing_description_errors) }}

    {% if missing_model_errors | length == 1 %}

        {% do no_errors.append(missing_model_errors.pop()) %}{% endif %}

    {% if missing_columns_errors | length == 1 %}

        {% do no_errors.append(missing_columns_errors.pop()) %}{% endif %}

    {% if missing_description_errors | length == 1 %}

        {% do no_errors.append(missing_description_errors.pop()) %}{% endif %}

    {% if no_errors | length < 3 %}

        {{ logger("no_errors < 3 == True") }}
        {{ logger(missing_model_errors) }}
        {{ logger(missing_columns_errors) }}
        {{ logger(missing_description_errors) }}

        {% set all_errors = missing_model_errors + missing_columns_errors + missing_description_errors %}
        {{ logger(all_errors) }}

        {{ exceptions.raise_compiler_error( all_errors| join("\n")) }}

    {% endif %}

{% endmacro %}