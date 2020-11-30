
-- Use the `ref` function to select from other models

{{
    config(
        required_tests=None
    )
}}
select 
    *,
    'a' as new
from {{ ref('my_first_dbt_model') }}
where id = 1
