
-- Use the `ref` function to select from other models

select 
    *,
    'a' as new
from {{ ref('model_1') }}
where id = 1
