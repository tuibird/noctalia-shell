#!/bin/bash
#
# Bash script to get/set monitor brightness.
# This script acts as a smart wrapper for 'ddcutil' and the Linux sysfs backlight interface.
#
# It automatically determines whether to use ddcutil (for external monitors)
# or the /sys/class/backlight interface (for internal displays like eDP/LVDS).
#

# --- Configuration ---
readonly CACHE_PATH="/tmp/ddcutil_detect_cache.txt"
readonly CACHE_TTL=3600 # Cache duration in seconds (1 hour)

# --- Helper Functions ---

# Prints an error message to stderr and exits with code 1.
# Usage: fail "Error message"
fail() {
    echo "Error: $1" >&2
    exit 1
}

# Checks if a monitor name corresponds to an internal display.
# Usage: is_internal "monitor_name"
# Returns 0 (true) if internal, 1 (false) otherwise.
is_internal() {
    local monitor_name="$1"
    # eDP (embedded DisplayPort) and LVDS are common for laptop panels.
    if [[ "$monitor_name" == "eDP"* || "$monitor_name" == "LVDS"* ]]; then
        return 0 # Success (is internal)
    else
        return 1 # Failure (is not internal)
    fi
}

# Finds the corresponding backlight device in /sys/class/backlight for a given
# connector name (e.g., "DP-1").
# It echoes the device name (e.g., "intel_backlight") on success.
# Usage: get_sysfs_backlight_device "connector_name"
get_sysfs_backlight_device() {
    local target_connector="$1"
    
    for entry in /sys/class/backlight/*; do
        # Ensure it's a valid directory entry
        [ -d "$entry" ] || continue

        local device_name
        device_name=$(basename "$entry")

        # Prioritize nvidia devices if found
        if [[ "$device_name" == "nvidia_"* ]]; then
            echo "$device_name"
            return 0
        fi

        # Follow the symlink to find the graphics card connector
        local real_path
        if [ -L "$entry/device" ]; then
            real_path=$(readlink -f "$entry/device")
            # Extract the connector name from a path like .../card0-DP-1/...
            # This regex finds "card" + digits + "-", and captures what follows.
            if [[ "$real_path" =~ card[0-9]+-([^/]+) ]]; then
                local path_connector="${BASH_REMATCH[1]}"
                if [[ "$path_connector" == "$target_connector" ]]; then
                    echo "$device_name"
                    return 0
                fi
            fi
        fi
    done

    return 1 # Not found
}

# Retrieves the output of `ddcutil detect`, using a cache to avoid
# repeated slow calls. Echoes the command output.
# Usage: get_ddcutil_detect_output
get_ddcutil_detect_output() {
    local use_cache=true
    if [ ! -f "$CACHE_PATH" ]; then
        use_cache=false
    else
        local now
        now=$(date +%s)
        local mtime
        mtime=$(stat -c %Y "$CACHE_PATH")
        local age=$((now - mtime))
        if (( age > CACHE_TTL )); then
            use_cache=false
        fi
    fi

    if [[ "$use_cache" == true ]]; then
        cat "$CACHE_PATH"
    else
        # Run the command, tee the output to the cache file, and also return it
        ddcutil detect 2>/dev/null | tee "$CACHE_PATH"
    fi
}

# Parses the output of `ddcutil detect` to find the display index (e.g., 1)
# for a given monitor connector name (e.g., "DP-1").
# Echoes the display index on success.
# Usage: get_ddc_index_for_monitor "monitor_name"
get_ddc_index_for_monitor() {
    local target_monitor="$1"
    local detect_output
    detect_output=$(get_ddcutil_detect_output)
    
    # Check if ddcutil command failed or produced no output
    if [ -z "$detect_output" ]; then
        return 1
    fi

    local current_display=""
    # Use process substitution and a while loop to read line-by-line
    # This avoids issues with subshells and variable scope.
    while IFS= read -r line; do
        # Find lines like "Display 1" and store the number
        if [[ "$line" =~ ^Display[[:space:]]+([0-9]+) ]]; then
            current_display="${BASH_REMATCH[1]}"
            continue
        fi

        # Once we have a display number, look for its connector info
        if [ -n "$current_display" ]; then
            # Look for lines like "DRM connector: card0-DP-1"
            if [[ "$line" =~ DRM_?connector:.*card[0-9]+-(${target_monitor}) ]]; then
                echo "$current_display"
                return 0
            fi
        fi
    done <<< "$detect_output"
    
    return 1 # Not found
}

# --- Main Logic ---

main() {
    # Check for correct number of arguments
    if [[ "$#" -lt 2 ]]; then
        echo "-1"
        exit 1
    fi

    local cmd="$1"
    local mon="$2"
    local val="${3:-}" # Default to empty if not provided

    if is_internal "$mon"; then
        # --- Handle Internal Display (via /sys/class/backlight) ---
        local backlight_device
        backlight_device=$(get_sysfs_backlight_device "$mon")
        if [ -z "$backlight_device" ]; then
            echo "-1" # Error: Could not find backlight device
            exit 1
        fi

        local brightness_file="/sys/class/backlight/$backlight_device/brightness"
        local max_brightness_file="/sys/class/backlight/$backlight_device/max_brightness"

        if [ "$cmd" == "get" ]; then
            local current_b
            current_b=$(cat "$brightness_file")
            local max_b
            max_b=$(cat "$max_brightness_file")
            # Perform integer arithmetic to scale to 0-100
            echo $((current_b * 100 / max_b))

        elif [ "$cmd" == "set" ]; then
            [[ "$#" -lt 3 ]] && echo "-1" && exit 1
            local max_b
            max_b=$(cat "$max_brightness_file")
            # Scale the 0-100 value to the device's raw value
            local raw_brightness=$((val * max_b / 100))
            # NOTE: Writing here may require root privileges or specific udev rules.
            if ! echo "$raw_brightness" > "$brightness_file" 2>/dev/null; then
                echo "-1" # Error: Permission denied or other write error
                exit 1
            fi
            echo "$val" # Echo back the set value on success
        else
            echo "-1" # Invalid command
            exit 1
        fi

    else
        # --- Handle External Display (via ddcutil) ---
        local display_index
        display_index=$(get_ddc_index_for_monitor "$mon")
        if [ -z "$display_index" ]; then
            echo "-1" # Error: Could not find DDC display index
            exit 1
        fi

        if [ "$cmd" == "get" ]; then
            # Call ddcutil, parse for "current value = X,"
            local output
            output=$(ddcutil --display "$display_index" getvcp 10 2>/dev/null)
            if [[ "$output" =~ current[[:space:]]+value[[:space:]]*=[[:space:]]*([0-9]+) ]]; then
                echo "${BASH_REMATCH[1]}"
            else
                echo "-1" # Error: Could not parse brightness from ddcutil
                exit 1
            fi
        elif [ "$cmd" == "set" ]; then
            [[ "$#" -lt 3 ]] && echo "-1" && exit 1
            if ddcutil --display "$display_index" setvcp 10 "$val" >/dev/null 2>&1; then
                echo "$val" # Echo back the set value on success
            else
                echo "-1" # Error: ddcutil command failed
                exit 1
            fi
        else
            echo "-1" # Invalid command
            exit 1
        fi
    fi
}

# Run the main function with all script arguments
main "$@"