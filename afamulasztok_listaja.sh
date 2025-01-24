#!/bin/bash

# Extract data from PDF using Tabula
tabula --outfile tmp1.csv --lattice --pages 1-10 Afamulasztok_listaja.pdf

# Fix the line breaks
tr -d '\r' < tmp1.csv > tmp2.csv

# Remove the first two lines and lines containing specific headers
awk 'NR > 2 && $0 !~ /Adószám Adózó neve \(elnevezése\) Lakcím Székhely Telephely Illetékesség kódja/' tmp2.csv > tmp3.csv
awk 'NR > 2 && $0 !~ /Adószám,Adózó neve \(elnevezése\),Lakcím,Székhely,Telephely,Illetékesség kódja/' tmp3.csv > tmp4.csv

# Remove tmp files
mv tmp4.csv afamulasztok_listaja.csv
rm tmp3.csv
rm tmp2.csv
rm tmp1.csv
