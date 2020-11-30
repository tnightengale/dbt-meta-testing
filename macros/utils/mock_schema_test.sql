{% macro test_mock_schema_test(model, column_name) %}

SELECT
    1 AS p
WHERE p <> 1

{% endmacro %}