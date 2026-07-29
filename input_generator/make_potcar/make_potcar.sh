#!/usr/bin/env bash

set -euo pipefail

potcar_dir="$HOME/POTCAR/potpaw_PBE"
output="POTCAR.tmp"
note_file=".potcar_options.tmp"

# Check POTCAR directory
if [[ ! -d "$potcar_dir" ]]; then
    echo "Error: POTCAR directory '$potcar_dir' does not exist." >&2
    exit 1
fi

# Check input arguments
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 Element1 Element2 ..."
    echo "Example: $0 Mg O"
    exit 1
fi

rm -f "$output" "$note_file"

count=1

for element in "$@"; do

    potcar="$potcar_dir/$element/POTCAR"

    # Remove VASP suffix (_pv, _sv, _h, ...)
    base_element="${element%%_*}"

    echo "----------------------------------------"
    printf "[%d] Element %d: %s\n" "$count" "$count" "$element"

    # Check selected POTCAR
    if [[ ! -f "$potcar" ]]; then
        echo "Error: POTCAR for '$element' does not exist."
        echo

        echo "Available options for $base_element:"

        found=0
        for dir in "$potcar_dir/$base_element" "$potcar_dir/${base_element}"_*; do
            [[ -d "$dir" ]] || continue

            alt=$(basename "$dir")

            if [[ -f "$dir/POTCAR" ]]; then
                printf "  %-12s " "$alt"
                grep "TITEL" "$dir/POTCAR"
                found=1
            fi
        done

        if [[ $found -eq 0 ]]; then
            echo "  No alternatives found."
        fi

        exit 1
    fi

    # Show selected POTCAR
    grep "TITEL" "$potcar"

    # Append POTCAR
    cat "$potcar" >> "$output"

    # Save alternative information for later display
    {
        echo "Element: $element"

        found=0
        for dir in "$potcar_dir/$base_element" "$potcar_dir/${base_element}"_*; do
            [[ -d "$dir" ]] || continue

            alt=$(basename "$dir")

            # Skip selected potential
            [[ "$alt" == "$element" ]] && continue

            if [[ -f "$dir/POTCAR" ]]; then
                printf "  %-12s " "$alt"
                grep "TITEL" "$dir/POTCAR"
                found=1
            fi
        done

        if [[ $found -eq 0 ]]; then
            echo "  None"
        fi

        echo

    } >> "$note_file"

    ((count++))

done

echo "----------------------------------------"
echo "Created $output"

# Show notes after creation
if [[ -s "$note_file" ]]; then
    echo
    echo "Note: Other available POTCAR options:"
    echo "----------------------------------------"
    cat "$note_file"
fi

rm -f "$note_file"

