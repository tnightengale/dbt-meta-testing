############
## Set Up ##
############
dbt deps

################
## Run Models ##
################
dbt run --target $TARGET

###############
##Test Cases ##
###############


# Case 1: Required docs 
if not dbt run-operation required_docs; then
    echo 
dbt run-operation required_tests
