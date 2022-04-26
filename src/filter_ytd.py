"""filter the data year-to-date through the latest date in the file"""

import sys
import pandas as pd


def filter_ytd(dataframe):
    """filters a dataframe year-to-date to the latest date in the data

    Args:
        df (pandas.DataFrame): original dataframe

    Returns:
        pandas.DataFrame: filtered dataframe
    """
    max_date = dataframe.date.max()
    dataframe = dataframe[
        (dataframe.date.dt.year == max_date)
        | (
            (dataframe.date.dt.month.isin(range(1, max_date.month)))
            | (
                (dataframe.date.dt.month == max_date.month)
                & (dataframe.date.dt.day <= max_date.day)
            )
        )
    ]
    return dataframe


if __name__ == "__main__":
    df = pd.read_csv(sys.argv[1], parse_dates=["date"], low_memory=False)
    df = filter_ytd(df)
    print(df.to_csv(index=False, line_terminator="\n"))
