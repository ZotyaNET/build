#!/bin/bash

# Extract data from PDF using Tabula
tabula --outfile Afamulasztok_listaja.csv --lattice --pages 1-10 Afamulasztok_listaja.pdf

# Fix the line breaks
tr -d '\r' < Afamulasztok_listaja.csv > Afamulasztok_listaja.csv

# Remove the first two lines and lines containing specific headers
awk 'NR > 2 && $0 !~ /Adószám Adózó neve \(elnevezése\) Lakcím Székhely Telephely Illetékesség kódja/' Afamulasztok_listaja.csv > Afamulasztok_listaja.csv
awk 'NR > 2 && $0 !~ /Adószám,Adózó neve \(elnevezése\),Lakcím,Székhely,Telephely,Illetékesség kódja/' Afamulasztok_listaja.csv > Afamulasztok_listaja.csv
