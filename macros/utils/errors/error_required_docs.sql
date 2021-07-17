{% macro error_required_docs(missing_model_errors, missing_columns_errors, missing_description_errors) %}
	{{ return(
        adapter.dispatch("error_required_docs", 
        "dbt_meta_testing")(
            missing_model_errors, 
            missing_columns_errors, 
            missing_description_errors
            )
        ) }}
{% endmacro %}

{% macro default__error_required_docs(
            missing_model_errors, 
            missing_columns_errors, 
            missing_description_errors
            ) %}

    {% set all_errors = [] %}
    {% if missing_model_errors | length > 0 %}

        {% do all_errors.append("The following models are missing descriptions:") %}
        {% do all_errors.append(dbt_meta_testing.format_error_docs(missing_model_errors)) %}{% endif %}

    {% if missing_columns_errors | length > 0 %}

        {% do all_errors.append("The following columns are missing from the model yml:") %}
        {% do all_errors.append(dbt_meta_testing.format_error_docs(missing_columns_errors)) %}{% endif %}

    {% if missing_description_errors | length > 0 %}

        {% do all_errors.append("The following columns are missing descriptions:") %}
        {% do all_errors.append(dbt_meta_testing.format_error_docs(missing_description_errors)) %}{% endif %}

    {{ return(all_errors | join("\n")) }}

{% endmacro %}
