SHELL := /bin/bash

GENERATED_FILES: \
		output/violent-crime-neighborhood-ytd.xlsx \
		output/violent-crime-neighborhood-full-year.xlsx

.PHONY: all output/index-crime-latest.csv

.INTERMEDIATE: output/index-crime-latest.csv

all: $(GENERATED_FILES)

output/index-crime-latest.csv: hand/query.sql
	wget --no-check-certificate --quiet \
			--method GET \
			--timeout=0 \
			--header 'Host: data.cityofchicago.org' \
			-O /dev/stdout \
			'https://data.cityofchicago.org/resource/v6vf-nfxy.csv?$$query=$(shell cat $<)' \
		> $@

venv/bin/activate: requirements.txt
	if [ ! -f $@ ]; then virtualenv venv; fi
	source $@ && pip install -r $<
	touch $@

cleanup:
	rm -f output*