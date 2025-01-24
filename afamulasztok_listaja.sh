#!/bin/bash

# Set the pdfbox.fontcache property to a writable directory
export JAVA_OPTS="-Dpdfbox.fontcache=/home/test/pdfbox_cache"

# Create the font cache directory if it doesn't exist
mkdir -p /home/test/pdfbox_cache

# Extract data from PDF using Tabula
tabula --outfile Afamulasztok_listaja.csv --lattice --pages Afamulasztok_listaja.pdf

# Remove the first two lines and lines containing specific headers
awk 'NR > 2 && $0 !~ /Adószám Adózó neve \(elnevezése\) Lakcím Székhely Telephely Illetékesség kódja/' Afamulasztok_listaja.csv > temp.csv
awk 'NR > 2 && $0 !~ /Adószám,Adózó neve \(elnevezése\),Lakcím,Székhely,Telephely,Illetékesség kódja/' temp.csv > Afamulasztok_listaja.csv

# Remove the temporary file
rm temp.csv
