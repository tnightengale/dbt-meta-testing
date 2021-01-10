{% macro _error_handler(error) %}

{# /*
Handles a set of predetermined errors to return the appropriate error.
*/ #}

{% set accepted_errors = {
    "ERROR REQUIRED DOCS": _error_required_docs(kwargs)
    } %}

{{ return(accepted_errors[error]) }}

{% endmacro %}

