"""
Assigns a unique ID to each homicide case number.

Case numbers for homicides are duplicated, one row per victim.
This is the only crime category like this, per the documentation for the dataset.
"""

import sys
import numpy as np
import pandas as pd

df = pd.read_csv(sys.stdin, low_memory=False)

# split homicides out
hom = df[df.crime_category == "Homicide"].copy()
df = df[df.crime_category != "Homicide"]

# add a digit to duplicated homicide case numbers
# https://stackoverflow.com/questions/54105419/add-numbers-with-duplicate-values-for-columns-in-pandas
hom["case_number"] = np.where(
    hom["case_number"].duplicated(keep=False),
    hom["case_number"] + hom.groupby("case_number").cumcount().add(1).astype(str),
    hom["case_number"],
)

# re-merge homicides
df = pd.concat([df, hom])

print(df.to_csv(index=False, line_terminator="\n"))
