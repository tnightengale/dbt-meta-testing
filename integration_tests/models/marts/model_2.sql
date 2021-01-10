
-- Use the `ref` function to select from other models

{{
    config(
        required_tests=None
    )
}}
select 
    *,
    'a' as new
from {{ ref('model_1') }}
where id = 1
