"""
Assigns a more consistent crime category to the FBI codes

See README.md for information on the source of these categories.
"""

import sys
import pandas as pd

df = pd.read_csv(sys.stdin, low_memory=False)

FBI_CODES = {
    "01A": "Homicide",
    "02": "Criminal Sexual Assault",
    "03": "Robbery",
    "04A": "Aggravated Assault",
    "04B": "Aggravated Battery",
    "05": "Burglary",
    "06": "Theft",
    "07": "Motor Vehicle Theft",
    "09": "Arson",
}

df["crime_category"] = df.fbi_code.apply(lambda code: FBI_CODES[code])

print(df.to_csv(index=False, line_terminator="\n"))
