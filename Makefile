SHELL := /bin/bash

GENERATED_FILES: \
		output/violent-crime-ytd.xlsx \
		output/violent-crime-full-year.xlsx \
		output/index-crime-ytd.xlsx \
		output/index-crime-full-year.xlsx \
		output/cta-index-crime-ytd.xlsx \
		output/cta-violent-crime-ytd.xlsx \
		output/cta-index-crime-full-year.xlsx \
		output/cta-violent-crime-full-year.xlsx \
		output/max_date.txt

.PHONY: all output/index-crime-full-year.csv

.INTERMEDIATE: \
	output/index-crime-full-year.csv \
	output/index-crime-ytd.csv \
	output/violent-crime-full-year.csv \
	output/violent-crime-ytd.csv \
	output/cta-index-crime-full-year.csv \
	output/cta-index-crime-ytd.csv \
	output/cta-violent-crime-full-year.csv \
	output/cta-violent-crime-ytd.csv \

all: $(GENERATED_FILES)

output/cta-index-crime-ytd.xlsx: \
		src/generate_excel_report.py \
		output/cta-index-crime-ytd.csv
	python $^ $@

output/cta-violent-crime-ytd.xlsx: \
		src/generate_excel_report.py \
		output/cta-violent-crime-ytd.csv
	python $^ $@

output/cta-index-crime-full-year.xlsx: \
		src/generate_excel_report.py \
		output/cta-index-crime-full-year.csv
	python $^ $@

output/cta-violent-crime-full-year.xlsx: \
		src/generate_excel_report.py \
		output/cta-violent-crime-full-year.csv
	python $^ $@

output/violent-crime-ytd.xlsx: \
		src/generate_excel_report.py \
		output/violent-crime-ytd.csv
	python $^ $@

output/violent-crime-full-year.xlsx: \
		src/generate_excel_report.py \
		output/violent-crime-full-year.csv
	python $^ $@

output/index-crime-ytd.xlsx: \
		src/generate_excel_report.py \
		output/index-crime-ytd.csv
	python $^ $@

output/index-crime-full-year.xlsx: \
		src/generate_excel_report.py \
		output/index-crime-full-year.csv
	python $^ $@

output/cta-violent-crime-ytd.csv: \
		src/filter_ytd.py \
		output/cta-violent-crime-full-year.csv
	python $^ > $@

output/cta-index-crime-ytd.csv: \
		src/filter_ytd.py \
		output/cta-index-crime-full-year.csv
	python $^ > $@

output/violent-crime-ytd.csv: \
		src/filter_ytd.py \
		output/violent-crime-full-year.csv
	python $^ > $@

output/cta-violent-crime-full-year.csv: output/violent-crime-full-year.csv
	cat $< | csvgrep -c location_description -r "CTA" > $@

output/violent-crime-full-year.csv: output/index-crime-full-year.csv
	cat $< | csvgrep -c fbi_code -r "01A|02|03|04A|04B" > $@

output/cta-index-crime-full-year.csv: output/index-crime-full-year.csv
	cat $< | csvgrep -c location_description -r "CTA" > $@

output/index-crime-ytd.csv: \
		src/filter_ytd.py \
		output/index-crime-full-year.csv
	python $^ > $@

output/index-crime-full-year.csv: \
		hand/query.sql \
		src/assign_crime_categories.py \
		src/get_unique_homicide_case_numbers.py \
		src/get_neighborhood_names.py \
		input/boundaries_neighborhoods.geojson
	wget --no-check-certificate --quiet \
			--method GET \
			--timeout=0 \
			--header 'Host: data.cityofchicago.org' \
			-O /dev/stdout \
			'https://data.cityofchicago.org/resource/ijzp-q8t2.csv?$$query=$(shell cat $<)' | \
		python $(word 2, $^) | \
		python $(word 3, $^) | \
		python $(wordlist 4, 5, $^) > $@

output/max_date.txt: output/index-crime-full-year.csv
	python -c "import pandas as pd; df = pd.read_csv('$<', parse_dates=['date']); print(df.date.max().strftime('%Y-%m-%d'))" > $@

venv/bin/activate: requirements.txt
	if [ ! -f $@ ]; then virtualenv venv; fi
	source $@ && pip install -r $<
	touch $@

cleanup:
	rm -f output/*