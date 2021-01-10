{% macro _error_required_docs(args) %}

{% set all_errors = [] %}
{% if args.models_missing_descriptions | length > 0 %}

    {% do all_errors.append("The following models are missing descriptions:") %}
    {% do all_errors.append(_error_formatter(args.models_missing_descriptions)) %}{% endif %}

{% if args.models_missing_columns | length > 0 %}

    {% do all_errors.append("The following columns are missing from the model yml:") %}
    {% do all_errors.append(_error_formatter(args.models_missing_columns)) %}{% endif %}

{% if args.columns_missing_descriptions | length > 0 %}

    {% do all_errors.append("The following columns are missing from the model yml:") %}
    {% do all_errors.append(_error_formatter(args.columns_missing_descriptions)) %}{% endif %}

{{ exceptions.raise_compiler_error(all_errors | join("\n")) }}

{% endmacro %}


