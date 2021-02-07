{% macro _error_required_docs() %}

{% set all_errors = [] %}
{% if kwargs.models_missing_descriptions | length > 0 %}

    {% do all_errors.append("The following models are missing descriptions:") %}
    {% do all_errors.append(_format_error_docs(kwargs.models_missing_descriptions)) %}{% endif %}

{% if kwargs.models_missing_columns | length > 0 %}

    {% do all_errors.append("The following columns are missing from the model yml:") %}
    {% do all_errors.append(_format_error_docs(kwargs.models_missing_columns)) %}{% endif %}

{% if kwargs.columns_missing_descriptions | length > 0 %}

    {% do all_errors.append("The following columns are missing from the model yml:") %}
    {% do all_errors.append(_format_error_docs(kwargs.columns_missing_descriptions)) %}{% endif %}

{{ _format_raise_error(all_errors | join("\n")) }}

{% endmacro %}


