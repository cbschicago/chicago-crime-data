# Chicago Crime Data

[![update-data](https://github.com/cbschicago/chicago-crime-data/actions/workflows/update-data.yaml/badge.svg)](https://github.com/cbschicago/chicago-crime-data/actions/workflows/update-data.yaml)

This repository fetches the latest data from the [Chicago Data Portal](https://data.cityofchicago.org/) on crimes in the city. It automatically queries and cleans the data, and generates Excel workbooks containing citywide totals and totals for each neighborhood.

**[Click here to get the latest data](https://github.com/cbschicago/chicago-crime-data/releases/tag/latest)**

## Which file should I use?

There are two crime categories in this data: violent crime and "index crime." For stories about robberies, homicides, etc., use violent crime. For stories about crime more generally, including things like thefts and burglaries, use index crime.

You should generally use the year-to-date files (those ending in "-ytd.xlsx"), for most stories. This allows you to compare totals for the current year to the same time period in previous years.

There are certain cases where you might want to use the full year files. For example, If you've just started a new year and there are only a few days of data for the new year.

## Definitions

| Term               | Definition                                                                                                             |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------- |
| Violent Crime      | Includes the following crime categories: Homicide, Sexual Assault, Aggravated Assault, Aggravated Battery, and Robbery |
| Index Crime        | Includes all 5 violent categories, plus the following: Theft, Burglary, Motor Vehicle Theft, and Arson                 |
| year-to-date (ytd) | Includes all incidents that occurred from the beginning of each calendar year through the latest date in the data.     |

## Disclaimers

The data on the data portal is always missing the last 7-8 days. That means if you're looking for data on April 26, you'll only be able to get data through April 18.

The incident totals reflect the number of unique incidents that occurred in the given time period, not the number of victims, EXCEPT for homicides. For homicides the totals reflect the number of homicide victims, even if multiple people were killed in the same incident.

## Generated Data Files

Excel reports are written to [output/](output/), and automatically published in a [release](https://github.com/cbschicago/chicago-crime-data/releases/tag/latest) whenever they're updated.

Below is a breakdown of each file created.

### Index Crime

#### [index-crime-ytd.xlsx](output/index-crime-ytd.xlsx)

This file contains breakdowns of index crime categories year-to-date through the latest date in the data.

#### [index-crime-full-year.xlsx](output/index-crime-full-year.xlsx)

This file contains the same data as [index-crime-ytd.xlsx](#index-crime-ytd.xlsx), but with data through the end of each year available.

### Violent Crime

#### [violent-crime-ytd.xlsx](output/violent-crime-ytd.xlsx)

This file contains breakdowns of violent crime categories year-to-date through the latest date in the data.

#### [violent-crime-full-year.xlsx](output/violent-crime-full-year.xlsx)

This file contains the same data as [violent-crime-ytd.xlsx](#violent-crime-ytd.xlsx), but with data through the end of each year available.

### CTA Crime

CTA Crime datasets contain the same information as the citywide ones, but contain only incidents that occurred on CTA trains, buses, train stations, bus stops and other cta property.

#### [cta-index-crime-ytd.xlsx](output/cta-index-crime-ytd.xlsx)

This file contains breakdowns of index crime categories year-to-date through the latest date in the data.

#### [cta-index-crime-full-year.xlsx](output/cta-index-crime-full-year.xlsx)

This file contains the same data as [cta-index-crime-ytd.xlsx](#cta-index-crime-ytd.xlsx), but with data through the end of each year available.

#### [cta-violent-crime-ytd.xlsx](output/cta-violent-crime-ytd.xlsx)

This file contains breakdowns of violent crime categories year-to-date through the latest date in the data.

#### [cta-violent-crime-full-year.xlsx](output/cta-violent-crime-full-year.xlsx)

This file contains the same data as [cta-violent-crime-ytd.xlsx](#cta-violent-crime-ytd.xlsx), but with data through the end of each year available.
