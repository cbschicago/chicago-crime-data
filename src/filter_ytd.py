"""filter the data year-to-date through the latest date in the file"""

import sys
import pandas as pd


def filter_ytd(df):
    max_date = df.date.max()
    df = df[
        (df.date.dt.year == max_date)
        | (
            (df.date.dt.month.isin(range(1, max_date.month)))
            | ((df.date.dt.month == max_date.month) & (df.date.dt.day <= max_date.day))
        )
    ]
    return df


if __name__ == "__main__":
    df = pd.read_csv(sys.argv[1], parse_dates=["date"], low_memory=False)
    df = filter_ytd(df)
    print(df.to_csv(index=False, line_terminator="\n"))