# Set Up
dbt deps

# Snowflake
dbt run --target snowflake

# Test
if not dbt run-operation required_docs; then
    echo 
dbt run-operation required_tests
