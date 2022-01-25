{% macro evaluate_required_docs(models_to_evaluate) %}
	{{ return(adapter.dispatch("evaluate_required_docs", "dbt_meta_testing")(models_to_evaluate))}}
{% endmacro %}

{% macro default__evaluate_required_docs(models_to_evaluate) %}

    {# /*
    Evaluate if each model meets +required_docs config.
    */ #}

    {% set missing_model_errors = [] %}
    {% set missing_columns_errors = [] %}
    {% set missing_description_errors = [] %}

    {% for model in models_to_evaluate %}

        {% if model.config.required_docs==True and model.config.get("materialized", "") not in ("", "ephemeral")%}
            
            {% set model_columns = adapter.get_columns_in_relation(ref(model.package_name, model.name)) 
                | map(attribute="column") | list %}
            {{ dbt_meta_testing.logger(model_columns | map(attribute="column") | list) }}

            {% if model.description == "" %}

                {% do missing_model_errors.append(model.name) %}

            {% endif %}

            {% for column in model_columns %}

                {% if var("convert_column_names_to_lower_case", true) %}
                    {% set column = column | lower %}
                {% endif %}

                {% if column in model.columns.keys() %}

                    {{ dbt_meta_testing.logger(column ~ " is in " ~ model.columns.keys()) }}
                    {% if model.columns[column].description == "" %}

                        {% do missing_description_errors.append((model.name, column)) %}

                    {% endif %}
                
                {% else %}

                    {% do missing_columns_errors.append((model.name, column)) %}

                {% endif %}

            {% endfor %}
        
        {% endif %}

    {% endfor %}

    {% set errors = missing_model_errors + missing_columns_errors + missing_description_errors %}
    {% if errors | length > 0 %}

        {{ dbt_meta_testing.logger(missing_model_errors) }}
        {{ dbt_meta_testing.logger(missing_columns_errors) }}
        {{ dbt_meta_testing.logger(missing_description_errors) }}

        {% set result = dbt_meta_testing.error_required_docs(
            missing_model_errors, 
            missing_columns_errors, 
            missing_description_errors
            )
        %}

    {% else %}

        {% set result = none %}

    {% endif %}

    {{ return(result) }}

{% endmacro %}
