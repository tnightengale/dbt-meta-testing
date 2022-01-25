![buildstatus](https://github.com/tnightengale/dbt-meta-testing/workflows/Integration%20Tests/badge.svg)

# dbt Meta Testing
This [dbt](https://docs.getdbt.com/docs/introduction) package contains macros to assert test and documentation coverage from
`dbt_project.yml` configuration settings.

## Table of Contents
  - [Install](#install)
  - [Configurations](#configurations)
    - [Required Tests](#required-tests)
    - [Required Docs](#required-docs)
  - [Usage](#usage)
    - [required_tests (source)](#required_tests-source)
    - [required_docs (source)](#required_docs-source)
  - [Contributions](#contributions)
  - [Testing](#testing)
    - [Verified Data Warehouses](#verified-data-warehouses)

## Install
Include in `packages.yml`:

```yaml
packages:
  - package: tnightengale/dbt_meta_testing
    version: 0.3.5
```
For latest release, see
https://github.com/tnightengale/dbt-meta-testing/releases.

## Configurations
This package features two meta configs that can be applied to a dbt project:

1. `+required_tests`
2. `+required_docs`

Read the dbt documentation
[here](https://docs.getdbt.com/reference/model-configs) to learn more about
model configurations in dbt.

### Required Tests
To require test coverage, define the `+required_tests` configuration on a model
path in `dbt_project.yml`:
```yaml
# dbt_project.yml
...
models:
  project:
    +required_docs: true
    marts:
      +required_tests: {"unique.*|not_null": 1}
      model_2:
        +required_tests:
          "mocker.*|unique": 1
          "mock_schema_test": 1
          ".*data_test": 1
```

The `+required_tests` config must be `None` or a `dict` with `str` keys and `int`
values. YAML dictionaries are accepted.

All the regular
dbt configuration hierarchy rules apply. For example, individual model configs
will override configs from the `dbt_project.yml`:
```sql
# /models/marts/core/your_model.sql

-- This overrides the config in dbt_project.yml, and this model will not require tests
{{ config(required_tests=None) }}

SELECT
...
```
> **_New in Version 0.3.3_**

The keys of the config are evaluated against both data and schema tests
(including any custom tests) using the
[re.fullmatch](https://docs.python.org/3/library/re.html#re.fullmatch) function.

Therefore, any test restriction which can be expressed in regex can  be
evaluated.

For example:
```yaml
# dbt_project.yml
...
models:
  project:
    +required_docs: true
    # The following configuration on the `marts` model path requires
    # each model in that path to have at least one test that either:
    #
    #    1. starts with "unique" (note the ".*" regex suffix) OR (note the "|" regex)
    #    2. is an exact match for the "not_null" test.

    marts:
      +required_tests: {"unique.*|not_null": 1}
```

Schema tests are matched against their common names, (eg. `not_null`,
`accepted_values`).

Data tests are matched against their macro name.

Custom schema tests are matched against their name, eg. `mock_schema_test`:

```yaml
# models/schema.yml
...
    - name: model_2
      description: ""
      tests:
        - equal_rowcount:
            compare_model: ref('model_1')
      columns:
          - name: id
            description: "The primary key for this table"
            tests:
                - unique
                - not_null
                - mock_schema_test
```

Models that do not meet their configured test minimums, because they either lack
the tests or are not documented, will be listed in the
error when validated via a `run-operation`:
```
usr@home dbt-meta-testing $ dbt run-operation required_tests
Running with dbt=0.20.0
Encountered an error while running operation: Compilation Error in macro required_tests (macros/required_tests.sql)
  Insufficient test coverage from the 'required_tests' config on the following models:
  Model: 'model_1' Test: 'not_null' Got: 1 Expected: 2
  Model: 'model_1' Test: 'mock_schema_test' Got: 0 Expected: 1

  > in macro _evaluate_required_tests (macros/utils/required_tests/evaluate_required_tests.sql)
  > called by macro required_tests (macros/required_tests.sql)
  > called by macro required_tests (macros/required_tests.sql)
usr@home dbt-meta-testing $
```

### Required Docs
To require documentation coverage, define the `+required_docs` configuration on
a model path in `dbt_project.yml`:
```yaml
# dbt_project.yml
...
models:
    project:
        +required_docs: true
```
The `+required_docs` config must be a `bool`.

It also **does not check ephemeral
models**. This is because it cannot leverage `adapter.get_columns_in_relation()`
macro on ephemeral models, which it uses to fetch columns from the data
warehouse and detect columns without documentation.

When applied to a non-ephemeral model, this config will ensure 3 things:
1. The _model_ has a non-empty description
2. The _columns_ in the model are specified in the model `.yml`
3. The _columns_ specified in the model `.yml` have non-empty descriptions

For example, the following configurations:
```yaml
# models/schema.yml
version: 2

models:
    - name: model_1
      description: "A starter dbt model"
      columns:
          - name: id
            description: ""
            tests:
                - unique
                - not_null

    - name: model_2
      description: ""
      tests:
        - equal_rowcount:
            compare_model: ref('model_1')
      columns:
          - name: id
            description: "The primary key for this table"
            tests:
                - unique
                - not_null

```

Where `model_2` has a column `new` which is not defined in the `.yml` above:
```sql
-- models/example/model_2.sql
select
    *,
    'new' as new
from {{ ref('model_1') }}
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
Running with dbt=0.20.0
Encountered an error while running operation: Compilation Error in macro required_docs (macros/required_docs.sql)
  The following models are missing descriptions:
   - model_2
  The following columns are missing from the model yml:
   - model_2.new
  The following columns are present in the model yml, but have blank descriptions:
   - model_1.id

  > in macro _evaluate_required_docs (macros/utils/required_docs/evaluate_required_docs.sql)
  > called by macro required_docs (macros/required_docs.sql)
  > called by macro required_docs (macros/required_docs.sql)
usr@home dbt-meta-testing $
```

## Usage
To assert either the `+required_tests` or `+required_docs` configuration, run
the correpsonding macro as a `run-operation` within the dbt CLI.

By default the macro will check all models with the corresponding configuration.
If any model does not meet the configuration, the `run-operation` will fail
(non-zero) and display an appropriate error message.

To assert the configuration for only a subset of the configured models (eg. new
models only in a CI) pass an argument, `models`, to the macro as a space
delimited string of model names to use.

It's also possible to pass in the result of a `dbt ls -m <selection_syntax>`
command, in order to make use of [dbt node selection
syntax](https://docs.getdbt.com/reference/node-selection/syntax). Use shell
subsitution in a dictionary representation.

For example, to run only changed models using dbt's Slim CI feature:
```bash
dbt run-operation required_tests --args "{'models':'$(dbt list -m state:modified --state <filepath>)'}"
```

Alternatively, a space
delimited string of model names will work as well:
```bash
dbt run-operation required_tests --args "{'models':'model1 model2 model3'}"
```

### required_tests ([source](macros/required_tests.sql))
Validates that models meet the `+required_tests` configurations applied in
`dbt_project.yml`. Typically used only as a `run-operation` in a CI pipeline.

Usage:
```
dbt run-operation required_tests [--args "{'models': '<space_delimited_models>'}"]
```

### required_docs ([source](macros/required_tests.sql))
Validates that models meet the `+required_docs` configurations applied in
`dbt_project.yml`. Typically used only as a `run-operation` in a CI pipeline.


Usage:
```
dbt run-operation required_docs [--args "{'models': '<space_delimited_models>'}"]
```
**Note:** Run this command _after_ `dbt run`: only models that already exist in
the warehouse can be validated for columns that are missing from the model `.yml`.
By default, column names are assumed to be lower case in the DBT documentation,
if this is not the case in your project, setting the variable
`convert_column_names_to_lower_case` to `false` in `dbt_project.yml` will
compare the column names in the case they appear.

## Contributions
Feedback on this project is welcomed and encouraged. Please open an issue or
start a discussion if you would like to request a feature change or contribute
to this project.

## Testing
The integration tests for this package are located at
[./integration_tests/tests/](integration_tests/tests/).

To run the tests locally, ensure you have the correct environment variables set
according to the targets in
[./integration_tests/profiles.yml](integration_tests/profiles.yml) and use:
```bash
cd integration_tests
dbt test --data
```

### Verified Data Warehouses
This package has been tested for the following data warehouses:
- Snowflake
