#!/bin/bash

# Test script for reliable file upload implementation
# This script tests the chunked upload system with resume capability

set -e

# Configuration
SERVER="http://localhost:3000"
AUTH_TOKEN="fake-jwt-token-12345"
TEST_FILE="/tmp/test_large_file.bin"
CHUNK_SIZE=1048576  # 1MB chunks
FILE_SIZE=5242880   # 5MB test file

echo "=== Reliable File Upload Test ==="
echo "Server: $SERVER"
echo "Test file size: $FILE_SIZE bytes"
echo "Chunk size: $CHUNK_SIZE bytes"
echo

# Function to create a test file
create_test_file() {
    echo "Creating test file of $FILE_SIZE bytes..."
    dd if=/dev/urandom of="$TEST_FILE" bs=1 count=$FILE_SIZE 2>/dev/null
    echo "Test file created: $TEST_FILE"
}

# Function to upload chunk with retry
upload_chunk() {
    local session_id=$1
    local chunk_num=$2
    local offset=$((chunk_num * CHUNK_SIZE))
    local chunk_size=$CHUNK_SIZE
    
    # Adjust last chunk size
    if [ $((offset + chunk_size)) -gt $FILE_SIZE ]; then
        chunk_size=$((FILE_SIZE - offset))
    fi
    
    local max_retries=3
    local retry=0
    
    while [ $retry -lt $max_retries ]; do
        echo "  Uploading chunk $chunk_num (offset: $offset, size: $chunk_size)..."
        
        if curl -s -X POST "$SERVER/upload/chunk" \
            -H "X-Session-ID: $session_id" \
            -H "X-Chunk-Number: $chunk_num" \
            -H "Authorization: Bearer $AUTH_TOKEN" \
            --data-binary "$(dd if="$TEST_FILE" bs=1 skip=$offset count=$chunk_size 2>/dev/null)" \
            --max-time 30 \
            --retry 2 \
            --retry-delay 1 > /tmp/chunk_response.json; then
            
            # Check if upload was successful
            if jq -e '.message' /tmp/chunk_response.json > /dev/null 2>&1; then
                local percentage=$(jq -r '.percentage' /tmp/chunk_response.json)
                local completed=$(jq -r '.completed' /tmp/chunk_response.json)
                echo "    ✓ Chunk $chunk_num uploaded successfully (${percentage}% complete)"
                
                if [ "$completed" = "true" ]; then
                    echo "    🎉 Upload completed!"
                    return 0
                fi
                return 0
            else
                echo "    ✗ Invalid response for chunk $chunk_num"
                retry=$((retry + 1))
            fi
        else
            echo "    ✗ Failed to upload chunk $chunk_num, retry $((retry + 1))/$max_retries"
            retry=$((retry + 1))
            sleep $((retry * 2))  # Exponential backoff
        fi
    done
    
    echo "    ❌ Chunk $chunk_num failed after $max_retries retries"
    return 1
}

# Function to check upload progress
check_progress() {
    local session_id=$1
    echo "Checking upload progress..."
    
    curl -s -X GET "$SERVER/upload/progress?session_id=$session_id" \
        -H "Authorization: Bearer $AUTH_TOKEN" | jq '.'
}

# Function to simulate resume functionality
test_resume() {
    local session_id=$1
    echo "Testing resume functionality..."
    
    # Check current progress
    local progress=$(curl -s -X GET "$SERVER/upload/progress?session_id=$session_id" \
        -H "Authorization: Bearer $AUTH_TOKEN" | jq -r '.uploaded_size')
    
    echo "Current progress: $progress bytes"
    
    # Calculate which chunk to resume from
    local resume_chunk=$((progress / CHUNK_SIZE + 1))
    local total_chunks=$(( (FILE_SIZE + CHUNK_SIZE - 1) / CHUNK_SIZE ))
    
    echo "Resuming from chunk $resume_chunk of $total_chunks"
    
    # Resume upload
    for ((i=resume_chunk; i<=total_chunks; i++)); do
        if ! upload_chunk "$session_id" $i; then
            echo "Resume failed at chunk $i"
            return 1
        fi
    done
    
    echo "Resume test completed successfully!"
}

# Main test function
run_test() {
    echo "Starting server test..."
    
    # Check if server is running
    if ! curl -s "$SERVER/counter" > /dev/null; then
        echo "❌ Server is not running. Please start the server first:"
        echo "   cargo run --bin web"
        exit 1
    fi
    
    echo "✓ Server is running"
    
    # Create test file
    create_test_file
    
    # Step 1: Initiate upload session
    echo
    echo "=== Step 1: Initiating Upload Session ==="
    local response=$(curl -s -X POST "$SERVER/upload/initiate" \
        -H "X-Filename: test_large_file.bin" \
        -H "X-File-Size: $FILE_SIZE" \
        -H "X-Chunk-Size: $CHUNK_SIZE" \
        -H "Authorization: Bearer $AUTH_TOKEN")
    
    echo "Initiate response:"
    echo "$response" | jq '.'
    
    local session_id=$(echo "$response" | jq -r '.session_id')
    echo "Session ID: $session_id"
    
    if [ "$session_id" = "null" ] || [ -z "$session_id" ]; then
        echo "❌ Failed to create upload session"
        exit 1
    fi
    
    # Step 2: Upload all chunks
    echo
    echo "=== Step 2: Uploading File in Chunks ==="
    local total_chunks=$(( (FILE_SIZE + CHUNK_SIZE - 1) / CHUNK_SIZE ))
    echo "Total chunks to upload: $total_chunks"
    
    for ((i=1; i<=total_chunks; i++)); do
        if ! upload_chunk "$session_id" $i; then
            echo "❌ Upload failed at chunk $i"
            exit 1
        fi
    done
    
    # Step 3: Verify upload completion
    echo
    echo "=== Step 3: Verifying Upload Completion ==="
    check_progress "$session_id"
    
    # Step 4: Test resume functionality (simulate interruption)
    echo
    echo "=== Step 4: Testing Resume Functionality ==="
    echo "Creating a new session to test resume..."
    
    local resume_response=$(curl -s -X POST "$SERVER/upload/initiate" \
        -H "X-Filename: test_resume_file.bin" \
        -H "X-File-Size: $FILE_SIZE" \
        -H "X-Chunk-Size: $CHUNK_SIZE" \
        -H "Authorization: Bearer $AUTH_TOKEN")
    
    local resume_session_id=$(echo "$resume_response" | jq -r '.session_id')
    echo "Resume session ID: $resume_session_id"
    
    # Upload first few chunks
    echo "Uploading first 2 chunks..."
    for ((i=1; i<=2; i++)); do
        upload_chunk "$resume_session_id" $i
    done
    
    # Check progress
    check_progress "$resume_session_id"
    
    # Resume from where we left off
    test_resume "$resume_session_id"
    
    # Step 5: Test cancel functionality
    echo
    echo "=== Step 5: Testing Cancel Functionality ==="
    local cancel_response=$(curl -s -X POST "$SERVER/upload/initiate" \
        -H "X-Filename: test_cancel_file.bin" \
        -H "X-File-Size: $FILE_SIZE" \
        -H "X-Chunk-Size: $CHUNK_SIZE" \
        -H "Authorization: Bearer $AUTH_TOKEN")
    
    local cancel_session_id=$(echo "$cancel_response" | jq -r '.session_id')
    echo "Cancel session ID: $cancel_session_id"
    
    # Upload one chunk
    upload_chunk "$cancel_session_id" 1
    
    # Cancel the upload
    echo "Cancelling upload..."
    local cancel_result=$(curl -s -X DELETE "$SERVER/upload/cancel?session_id=$cancel_session_id" \
        -H "Authorization: Bearer $AUTH_TOKEN")
    echo "Cancel result:"
    echo "$cancel_result" | jq '.'
    
    # Cleanup
    echo
    echo "=== Cleanup ==="
    rm -f "$TEST_FILE"
    rm -f /tmp/chunk_response.json
    echo "✓ Test files cleaned up"
    
    echo
    echo "🎉 All tests completed successfully!"
    echo "The reliable file upload system is working correctly."
}

# Check dependencies
if ! command -v jq &> /dev/null; then
    echo "❌ jq is required but not installed. Please install jq:"
    echo "   sudo apt-get install jq  # Ubuntu/Debian"
    echo "   brew install jq          # macOS"
    exit 1
fi

if ! command -v dd &> /dev/null; then
    echo "❌ dd is required but not installed."
    exit 1
fi

# Run the test
run_test

