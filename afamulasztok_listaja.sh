#!/bin/bash

# Extract data from PDF using Tabula
tabula --outfile Afamulasztok_listaja.csv --lattice --pages all Afamulasztok_listaja.pdf

# Remove the first two lines and lines containing specific headers
awk 'NR > 2 && $0 !~ /Adószám Adózó neve \(elnevezése\) Lakcím Székhely Telephely Illetékesség kódja/' Afamulasztok_listaja.csv > temp.csv
awk 'NR > 2 && $0 !~ /Adószám,Adózó neve \(elnevezése\),Lakcím,Székhely,Telephely,Illetékesség kódja/' temp.csv > Afamulasztok_listaja.csv

zip files Afamulasztok_listaja.csv

# Remove the temporary file
rm temp.csv
rm Afamulasztok_listaja.csv
