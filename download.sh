#!/usr/bin/env bash
set -Eeuo pipefail

DESTINATION_FOLDER="./data"
mkdir -p "$DESTINATION_FOLDER"

# 1) Get the SPARQL for the "latest-core" collection
QUERY=$(curl -fsSL -H "Accept:text/sparql" https://databus.dbpedia.org/dbpedia/collections/latest-core)

# 2) Execute the query and extract the file URLs (CSV without header/quotes)
FILES=$(
  curl -fsS -X POST -H "Accept: text/csv" \
    --data-urlencode "query=${QUERY}" \
    https://databus.dbpedia.org/sparql \
  | tail -n +2 | sed 's/\r$//' | sed 's/"//g'
)

# 3) Download, then decompress .bz2 into DESTINATION_FOLDER, deleting the archive
while IFS= read -r url; do
  [[ -z "$url" ]] && continue

  fname=$(basename "$url")
  outpath="${DESTINATION_FOLDER}/${fname}"

  echo "Downloading: $url"
  wget -q --show-progress -c -O "$outpath" "$url"

  if [[ "$fname" == *.bz2 ]]; then
    echo "Decompressing: $outpath"
    # bunzip2 removes the .bz2 file by default; -f overwrites if needed
    bunzip2 -f "$outpath"
    echo "→ Extracted to: ${DESTINATION_FOLDER}/${fname%.bz2}"
  fi
done <<< "$FILES"

echo "All done. Files are in: $DESTINATION_FOLDER"
