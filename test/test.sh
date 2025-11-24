#!/bin/bash
set -e

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# helper: POST JSON and return "HTTP_CODE\nBODY..."
do_request() {
  local url="$1"
  local data="$2"
  local raw
  raw=$(curl -s -H "Content-Type: application/json" -X POST "$url" -d "$data" -w $'\n%{http_code}')
  local http_code body
  http_code="$(printf '%s' "$raw" | tail -n1)"
  body="$(printf '%s' "$raw" | sed '$d')"
  # print code on first line, then body (body can be multi-line)
  printf '%s\n%s' "$http_code" "$body"
}

URL="http://localhost:8080/scitokens-server/oidc-cm"

# Test 1: Valid redirect_uris
echo "Test 1: Valid redirect_uris"
data='{"redirect_uris":["https://client.example.com/callback"]}'
response="$(do_request "$URL" "$data")"
http_code="$(printf '%s\n' "$response" | head -n1)"
body="$(printf '%s\n' "$response" | tail -n +2)"
if [ "$http_code" -eq 200 ]; then
  echo -e "${GREEN}PASS: Valid redirect_uris accepted (HTTP $http_code)${NC}"
  echo "Response body:"
  echo "$body"
else
  echo -e "${RED}FAIL: Valid redirect_uris rejected (HTTP $http_code)${NC}"
  echo "Response body:"
  echo "$body"
  exit 1
fi

# Test 2: Invalid redirect_uris
echo "Test 2: Invalid redirect_uris"
data='{"redirect_uris":["https://evil.com/callback"]}'
response="$(do_request "$URL" "$data")"
http_code="$(printf '%s\n' "$response" | head -n1)"
body="$(printf '%s' "$response" | tail -n +2)"
if [ "$http_code" -eq 400 ]; then
  echo -e "${GREEN}PASS: Invalid redirect_uris rejected (HTTP $http_code)${NC}"
  echo "Response body:"
  echo "$body"
else
  echo -e "${RED}FAIL: Invalid redirect_uris accepted (HTTP $http_code)${NC}"
  echo "Response body:"
  echo "$body"
  exit 1
fi

# Test 3: Missing redirect_uris
echo "Test 3: Missing redirect_uris"
data='{}'
response="$(do_request "$URL" "$data")"
http_code="$(printf '%s\n' "$response" | head -n1)"
body="$(printf '%s' "$response" | tail -n +2)"
if [ "$http_code" -eq 400 ]; then
  echo -e "${GREEN}PASS: Missing redirect_uris rejected (HTTP $http_code)${NC}"
  echo "Response body:"
  echo "$body"
else
  echo -e "${RED}FAIL: Missing redirect_uris accepted (HTTP $http_code)${NC}"
  echo "Response body:"
  echo "$body"
  exit 1
fi

echo -e "${GREEN}All tests passed.${NC}"
