# manage cx commands
function cx__search() {
    local keyword="$1"

    # Validate the keyword
    validate_keyword "$keyword"
    local validation_result=$?

    # If validation fails, return without searching
    if [[ $validation_result -ne 0 ]]; then
        return 1
    fi

    # Call the search function with the validated keyword
    search_by_alias "$keyword"
}

# Function to search for aliases based on a keyword
function search_by_keyword() {
    local keyword="$1"
    
    if [[ -z "$keyword" ]]; then
        echo "Please provide a keyword to search for aliases."
        return 1
    fi

    # Search in the CSV file for aliases matching the keyword
    local results
    results=$(grep -i "${keyword}" "$csv_file_path" | awk -F "," '{print "Alias: " $2 ", Path: " $3}')

    if [[ -z "$results" ]]; then
        echo "No aliases found matching the keyword: '$keyword'."
    else
        echo -e "$results"
    fi
}

# Function to validate the keyword
function validate_keyword() {
    local keyword="$1"

    # Check if the keyword is empty
    if [[ -z "$keyword" ]]; then
        echo "Error: The keyword cannot be empty."
        return 1
    fi

    # Check if the keyword is alphanumeric
    if ! [[ "$keyword" =~ ^[a-zA-Z0-9]+$ ]]; then
        echo "Error: The keyword must be alphanumeric."
        return 1
    fi

    # Check if the keyword starts with a digit
    if [[ "$keyword" =~ ^[0-9] ]]; then
        echo "Error: The keyword must not start with a digit."
        return 1
    fi

    # Check if the keyword contains a comma
    if [[ "$keyword" == *,* ]]; then
        echo "Error: The keyword must not contain a comma."
        return 1
    fi

    # If all checks pass, return 0
    return 0
}