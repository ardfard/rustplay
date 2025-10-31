#!/bin/bash

# Simple curl examples for testing the file upload API
# Make sure the server is running: cargo run --bin web

SERVER="http://localhost:3000"
AUTH_TOKEN="fake-jwt-token-12345"

echo "=== File Upload API Examples ==="
echo "Server: $SERVER"
echo

# Example 1: Create a small test file
echo "Creating test file..."
echo "This is a test file for upload testing." > /tmp/test.txt
FILE_SIZE=$(stat -c%s /tmp/test.txt)
echo "Test file size: $FILE_SIZE bytes"
echo

# Example 2: Initiate upload session
echo "=== Step 1: Initiate Upload Session ==="
INITIATE_RESPONSE=$(curl -s -X POST "$SERVER/upload/initiate" \
  -H "X-Filename: test.txt" \
  -H "X-File-Size: $FILE_SIZE" \
  -H "X-Chunk-Size: 1024" \
  -H "Authorization: Bearer $AUTH_TOKEN")

echo "Initiate response:"
echo "$INITIATE_RESPONSE" | jq '.'
echo

SESSION_ID=$(echo "$INITIATE_RESPONSE" | jq -r '.session_id')
echo "Session ID: $SESSION_ID"
echo

# Example 3: Upload file as single chunk (since it's small)
echo "=== Step 2: Upload File ==="
CHUNK_RESPONSE=$(curl -s -X POST "$SERVER/upload/chunk" \
  -H "X-Session-ID: $SESSION_ID" \
  -H "X-Chunk-Number: 1" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  --data-binary @/tmp/test.txt)

echo "Chunk upload response:"
echo "$CHUNK_RESPONSE" | jq '.'
echo

# Example 4: Check progress
echo "=== Step 3: Check Progress ==="
PROGRESS_RESPONSE=$(curl -s -X GET "$SERVER/upload/progress?session_id=$SESSION_ID" \
  -H "Authorization: Bearer $AUTH_TOKEN")

echo "Progress response:"
echo "$PROGRESS_RESPONSE" | jq '.'
echo

# Example 5: Verify file was created
echo "=== Step 4: Verify Upload ==="
if [ -f "uploads/test.txt" ]; then
    echo "✓ File uploaded successfully!"
    echo "File contents:"
    cat uploads/test.txt
else
    echo "❌ File not found in uploads directory"
fi
echo

# Cleanup
echo "=== Cleanup ==="
rm -f /tmp/test.txt
echo "✓ Test file cleaned up"
echo

echo "=== Manual Testing Commands ==="
echo "You can also test manually with these commands:"
echo
echo "# 1. Initiate upload:"
echo "curl -X POST $SERVER/upload/initiate \\"
echo "  -H 'X-Filename: myfile.txt' \\"
echo "  -H 'X-File-Size: 1024' \\"
echo "  -H 'X-Chunk-Size: 512' \\"
echo "  -H 'Authorization: Bearer $AUTH_TOKEN'"
echo
echo "# 2. Upload chunk:"
echo "curl -X POST $SERVER/upload/chunk \\"
echo "  -H 'X-Session-ID: YOUR_SESSION_ID' \\"
echo "  -H 'X-Chunk-Number: 1' \\"
echo "  -H 'Authorization: Bearer $AUTH_TOKEN' \\"
echo "  --data-binary @your_file.txt"
echo
echo "# 3. Check progress:"
echo "curl -X GET '$SERVER/upload/progress?session_id=YOUR_SESSION_ID' \\"
echo "  -H 'Authorization: Bearer $AUTH_TOKEN'"
echo
echo "# 4. Cancel upload:"
echo "curl -X DELETE '$SERVER/upload/cancel?session_id=YOUR_SESSION_ID' \\"
echo "  -H 'Authorization: Bearer $AUTH_TOKEN'"
echo
echo "=== Large File Upload Example ==="
echo "For large files, you would:"
echo "1. Create upload session with total file size"
echo "2. Split file into chunks (e.g., 1MB each)"
echo "3. Upload each chunk sequentially"
echo "4. Check progress between chunks"
echo "5. Resume from last successful chunk if interrupted"
echo
echo "Example chunk upload loop:"
echo "for i in {1..10}; do"
echo "  dd if=largefile.bin bs=1M skip=\$((i-1)) count=1 | \\"
echo "  curl -X POST $SERVER/upload/chunk \\"
echo "    -H 'X-Session-ID: YOUR_SESSION_ID' \\"
echo "    -H 'X-Chunk-Number: \$i' \\"
echo "    -H 'Authorization: Bearer $AUTH_TOKEN' \\"
echo "    --data-binary @-"
echo "done"

