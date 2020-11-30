# Quality dbt!
** NOTE: This package is in its alpha release.** 

This dbt package contains macros to assert test and documentation coverage from `dbt_project.yml` configuration settings.

## Install
Include in `packages.yml`:

```yaml
packages:
  - git: "https://github.com/tnightengale/quality-assurance-dbt"
    revision: <for latest release, see https://github.com/tnightengale/quality-assurance-dbt/releases>
```
For latest release, see https://github.com/tnightengale/quality-assurance-dbt/releases.

## Configurations
This package features two meta configs that can be applied to a dbt project: `+required_tests` and `+required_docs`. Read the dbt documentation [here](https://docs.getdbt.com/reference/model-configs) to learn more about model configurations in dbt.

### **Require Tests**
To require test coverage, define the `+required_tests` configuration on a model path in `dbt_project.yml`:
```yaml
# dbt_project.yml
...
models:
    project:
        staging:
            +required_tests: {"unique": 1, "not_null": 1}
        marts:
            +required_tests: {"unique": 1}
```

The `+required_tests` config must be either a `dict` or `None`. All the regular configuration override rules are the same. For example, individual model configs will override configs from the `dbt_project.yml`:
```sql
-- /models/marts/core/your_model.sql
{{
    config(required_tests=None)
}}

SELECT
...
```

### **Require Docs**
To require documentation coverage, define the `+required_docs` configuration on a model path in `dbt_project.yml`:
```yaml
# dbt_project.yml
...
models:
    project:
        +required_docs: true
```
The `+required_docs` config must be a `bool`.

When applied to a model, this config will ensure 3 things:
1. The _model_ has a non-empty descriptions:
2. The _columns_ in the model are specified in the model `.yml`
3. The _columns_ specified in the model `.yml` have non-empty descriptions

For example, the following configurations:
```yaml
# models/schema.yml
version: 2

models:
    - name: my_first_dbt_model
      description: "A starter dbt model"
      columns:
          - name: id
            description: ""
            tests:
                - unique
                - not_null

    - name: my_second_dbt_model
      description: ""
      tests:
        - dbt_utils.equal_rowcount:
            compare_model: ref('my_first_dbt_model')
      columns:
          - name: id
            description: "The primary key for this table"
            tests:
                - unique
                - not_null

```

Where `my_second_dbt_model` has a column `new` which is not defined in the `.yml` above:
```sql
-- models/example/my_second_dbt_model.sql
select 
    *,
    'new' as new
from {{ ref('my_first_dbt_model') }}
where id = 1
```

And all models in the example path require docs:
```yaml
# dbt_project.yml
...
models:
    project:
        example:
            +required_docs: true
```

Would result in the following error when validated via a `run-operation`:
```
usr@home dbt-meta-testing $ dbt run-operation required_docs
Running with dbt=0.18.1
Encountered an error while running operation: Compilation Error in macro required_docs (macros/required_docs.sql)
  The following models are missing descriptions:
   - my_second_dbt_model
  The following columns are missing from the model yml:
   - my_second_dbt_model.new
  The following columns are present in the model yml, but have blank descriptions:
   - my_first_dbt_model.id
  
  > in macro _evaluate_required_docs (macros/utils/required_docs/evaluate_required_docs.sql)
  > called by macro required_docs (macros/required_docs.sql)
  > called by macro required_docs (macros/required_docs.sql)
usr@home dbt-meta-testing $
```

## Usage
To assert either the `+required_tests` or `+required_docs` configuration, run the correpsonding macro as a `run-operation` within the dbt CLI.

By default the macro will check all models with the corresponding configuration. If any model does not meet the configuration, the `run-operation` will fail (non-zero) and display an appropriate error message.

To assert the configuration for only a subset of the configured models (eg. new models only in a CI) define the dbt var `models` as a space delimited string of model names to use. 

It's also possible to pass in the result of a `dbt ls -m <selection_syntax>` command, in order to make use of [dbt node selection syntax](https://docs.getdbt.com/reference/node-selection/syntax). Use shell subsitution in a dictionary representation.

For example, to run only changed models using dbt's Slim CI feature:
```bash
$ dbt run-operation required_tests --vars "{'models':'$(dbt list -m state:modified --state <filepath>)'}"
```

Alternatively, if you use git-diff to find changed models, a space delimited string of model names will work as well:
```bash
$ dbt run-operation required_tests --vars "{'models':'model1 model2 model3'}"
```

### required_tests ([source](macros/required_tests.sql))
Validates that models meet the `+required_tests` configurations applied in `dbt_project.yml`. 

Can be used as a `run-operation` early in the CI/CD pipeline.

Usage:
```
$ dbt run-operation required_tests [--vars "{'models': '<space_delimited_models>'}"]
```

### required_docs ([source](macros/required_tests.sql))
Validates that models meet the `+required_docs` configurations applied in `dbt_project.yml`. 

Can be used as a `run-operation` early in the CI/CD pipeline.

Usage:
```
$ dbt run-operation required_docs [--vars "{'models': '<space_delimited_models>'}"]
```

### logger ([source](macros/logger.sql))
An ammenity macro that mimics pythons logging module. The level is passed via the `log_level` kwarg. The default "method" (ie. `log_level`) is `DEBUG`, similar to calling `logging.debug('some buggy thing')` in python.


Set a level with a project var, similar to `logging.basicConfig(level=logging.INFO)` in python:
```yaml
# dbt_project.yml
...
vars:
    logging_level: WARNING
```
The default `logging_level` is `INFO`.

Usage:
```sql
-- macros/some_macro.sql

...

{% if my_object is mapping %}

     -- This will be a DEBUG call by default, it won't show up if logging_level="INFO" or higher
    {{ logger("my_object is mapping: " ~ my_object is mapping) }}

    ...

{% endif %}

-- This will be an INFO call, it will show up if logging_level="INFO" or lower
{{ logger("The following keys were found: " ~ my_complex_object.keys(), log_level="INFO") }}

{{ return(my_complex_object) }}
```

## Contributions
Contributions and feedback on this project are welcomed and encouraged. Please open an issue or start a discussion if you will to contribute. 