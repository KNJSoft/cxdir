# manage cx commands
function cx__search() {

    if [[ -n $alias ]]; then 
        case $alias in
            # user want help about the `cx update` command 
                "--help") show_help_search
                exit 0;;  
        esac
    fi
    # echo "No1: $command, No2: $alias, No3: $option "

    # Validate the keyword
    validate_keyword $alias
    validation_result=$?

    # If validation fails, return without searching
    if [[ $validation_result -ne 0 ]]; then
        return 1
    fi

    # Call the search function with the validated keyword
    search_by_keyword "$alias"
}

# Function to search for aliases based on a keyword
function search_by_keyword() {
    
    
    if [[ -z "$alias" ]]; then
        echo "Please provide a keyword to search for aliases."
        return 1
    fi

    # Search in the CSV file for aliases matching the keyword
    local results
    
    results=$(grep -i "${alias}" | awk -F "," '{print "Alias: " $2 ", Path: " $3}')

    if [[ -z "$results" ]]; then
        echo "No aliases found matching the keyword: '$alias'."
    else
        echo -e "$results"
    fi
}

# Function to validate the keyword
function validate_keyword() {
    

    # Check if the keyword is empty
    if [[ -z "$alias" ]]; then
        echo "Error: The keyword cannot be empty."
        return 1
    fi

    # Check if the keyword is alphanumeric
    if ! [[ "$alias" =~ ^[a-zA-Z0-9]+$ ]]; then
        echo "Error: The keyword must be alphanumeric."
        return 1
    fi

    # Check if the keyword starts with a digit
    if [[ "$alias" =~ ^[0-9] ]]; then
        echo "Error: The keyword must not start with a digit."
        return 1
    fi

    # Check if the keyword contains a comma
    if [[ "$alias" == *,* ]]; then
        echo "Error: The keyword must not contain a comma."
        return 1
    fi

    # If all checks pass, return 0
    return 0
}

function show_help_search () {
    echo ""
    echo $cyan"NAME:"$defaultColor
    echo -e "\t cx search - search for a shortcut by keyword"
    echo ""
    echo $cyan"DESCRIPTION:"$defaultColor
    echo -e "\t Use this command to find a shortcut based on the provided keyword."
    echo ""
    echo $cyan"USAGE:"$defaultColor
    echo -e "\t cx search [keyword]"
    echo ""
    echo $cyan"EXAMPLES:"$defaultColor
    echo -e "\t cx search doc     # Searches for shortcuts containing 'doc'"
    echo -e "\t cx search project # Searches for shortcuts related to 'project'"
    echo ""
}