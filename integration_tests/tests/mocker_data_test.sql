

select
    *
from {{ ref("model_2") }} 
where new != 'a'
