SHELL := /bin/bash

GENERATED_FILES: \
		output/violent-crime-neighborhood-ytd.xlsx \
		output/violent-crime-neighborhood-full-year.xlsx

.PHONY: all output/index-crime-latest.csv

.INTERMEDIATE: output/index-crime-latest.csv

all: $(GENERATED_FILES)

output/violent-crime-latest.csv: output/index-crime-latest.csv
	cat $< | csvgrep -c fbi_code -r "01A|02|03|04A|04B" > $@

output/index-crime-latest.csv: hand/query.sql
	wget --no-check-certificate --quiet \
		--method GET \
		--timeout=0 \
		--header 'Host: data.cityofchicago.org' \
		-O $@ \
		'https://data.cityofchicago.org/resource/ijzp-q8t2.csv?$$query=$(shell cat $<)'

venv/bin/activate: requirements.txt
	if [ ! -f $@ ]; then virtualenv venv; fi
	source $@ && pip install -r $<
	touch $@

cleanup:
	rm -f output/*