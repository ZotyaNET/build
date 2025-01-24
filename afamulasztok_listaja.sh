#!/bin/bash

tabula --outfile Afamulasztok_listaja.csv --lattice --use-line-returns --pages 1-10 Afamulasztok_listaja.pdf
awk 'NR > 2 && $0 !~ /Adószám Adózó neve \(elnevezése\) Lakcím Székhely Telephely Illetékesség kódja/' Afamulasztok_listaja.csv > Afamulasztok_listaja_clean.csv
awk 'NR > 2 && $0 !~ /Adószám,Adózó neve \(elnevezése\),Lakcím,Székhely,Telephely,Illetékesség kódja/' Afamulasztok_listaja.csv > Afamulasztok_listaja_clean.csv
