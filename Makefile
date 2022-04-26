SHELL := /bin/bash

GENERATED_FILES: \
		output/violent-crime-neighborhood-ytd.xlsx \
		output/violent-crime-neighborhood-full-year.xlsx

.PHONY: all raw

# .INTERMEDIATE: \
# 	output/index-crime-latest.csv \
# 	output/violent-crime-latest.csv

all: $(GENERATED_FILES)

raw: \
	output/violent-crime-ytd.csv \
	output/violent-crime-latest.csv \
	output/index-crime-ytd.csv \
	output/index-crime-latest.csv

output/violent-crime-ytd.csv: \
		src/filter_ytd.py \
		output/violent-crime-latest.csv
	python $^ > $@

output/violent-crime-latest.csv: output/index-crime-latest.csv
	cat $< | csvgrep -c fbi_code -r "01A|02|03|04A|04B" > $@

output/index-crime-ytd.csv: \
		src/filter_ytd.py \
		output/index-crime-latest.csv
	python $^ > $@

output/index-crime-latest.csv: \
		hand/query.sql \
		src/assign_crime_categories.py \
		src/get_neighborhood_names.py \
		input/boundaries_neighborhoods.geojson
	wget --no-check-certificate --quiet \
			--method GET \
			--timeout=0 \
			--header 'Host: data.cityofchicago.org' \
			-O /dev/stdout \
			'https://data.cityofchicago.org/resource/ijzp-q8t2.csv?$$query=$(shell cat $<)' | \
		python $(word 2, $^) | \
		python $(wordlist 3, 4, $^) > $@

venv/bin/activate: requirements.txt
	if [ ! -f $@ ]; then virtualenv venv; fi
	source $@ && pip install -r $<
	touch $@

cleanup:
	rm -f output/*