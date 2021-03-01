#!/bin/bash

############
## Set Up ##
############
# dbt deps

function evaluate_case() {
    # Checks the error output of the first dbt macro against the second dbt macro
    local macro1=$1
    local macro2=$2
    local case=$(cat ./cases/case_$3.yml)

    var1=$(dbt run-operation $macro1)
    var1="${var1%%>*}"
    var2=$(dbt run-operation $macro2 --args $case)
    
    if [ "$var1" = "${var2%%>*}" ]; then
        echo "SUCCESS: $var1"
    else 
        echo "FAILURE: Output of $macro1 != $macro2 with input $case."
        echo "$macro1: \n $var1"
        echo "$macro2: \n $var2"
        return 1
    fi
}

function trim_error() {
    # Removes the trailing traceback portion of a dbt macro error message
    local error=$1
    echo ${error%>*} # Removes all lines after the first line containing ">" ie. the traceback
}

################
## Run Models ##
################
# dbt run --target $TARGET

###############
##Test Cases ##
###############


# Case 1: Required docs 
CASE_1=$(cat ./cases/case_1.yml)
evaluate_case 'required_docs'
# dbt run-operation _error_required_docs --args "${CASE_1}" 2>&1
