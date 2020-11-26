# Quality dbt!
** NOTE: This package is in pre-release.** 

This dbt package contains macros to assert test and documentation coverage from `dbt_project.yml` configuration settings.

## Install
Include in packages.yml

```yaml
packages:
  - git: "https://github.com/tnightengale/quality-assurance-dbt"
    revision: <for latest release, see https://github.com/tnightengale/quality-assurance-dbt/releases>
```
For latest release, see https://github.com/tnightengale/quality-assurance-dbt.

## Usage
To assert test coverage, define the `+required_tests` configuration on a model path in `dbt_project.yml`:
```yaml
models:
    project:
        staging:
            +required_tests: {'unique': 1, 'not_null': 1}
        marts:
            +required_tests: {'unique': 1}
```

Individual model configs will override configs from the `dbt_project.yml`:
```sql
-- /models/marts/core/your_model.sql
{{
    config(required_tests={'unique': 1})
}}

SELECT
...
```

## Integration Tests

Coming soon.

## Macros

** NOTE: This package is in pre-release. The following macros are WIP.** 

#### required_tests ([source](macros/required_tests.sql))
Validates that models meet the `+required_tests` configurations applied in `dbt_project.yml`. 

Can be used as a `run-operation` early in the CI/CD pipeline.

Usage:
```bash
$ dbt run-operation required_tests
```

#### required_docs ([source](macros/required_tests.sql))

Validates that models meet the `+required_docs` configurations applied in `dbt_project.yml`. 

Can be used as a `run-operation` early in the CI/CD pipeline.

Usage:
```bash
$ dbt run-operation required_docs
```