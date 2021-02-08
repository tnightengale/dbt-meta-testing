{% macro _get_meta_test_namespaces() %}
  {% set override_namespaces = var('dbt_meta_test_dispatch_list', []) %}
  {% do return(override_namespaces + ['dbt_meta_testing']) %}
{% endmacro %}
