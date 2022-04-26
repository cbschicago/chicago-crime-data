"""generates an excel workbook with crosstabs based on input data"""

import sys
import pandas as pd

# pylint:disable=abstract-class-instantiated


def get_col_widths(dataframe):
    """
    gets an integer representing the width of the column in characters

    Args:
        dataframe (pandas.DataFrame): dataframe to auto-fit to

    Returns:
        list: list of column widths
    """
    idx_max = [
        max(
            [len(str(s)) for s in dataframe.index.get_level_values(idx)]
            + [len(str(idx))]
        )
        for idx in dataframe.index.names
    ]
    return idx_max + [
        max(
            [len(str(s)) for s in dataframe[col].values] + [len(str(x)) for x in col]
            if dataframe.columns.nlevels > 1
            else [len(str(col))]
        )
        for col in dataframe.columns
    ]


def crosstab(dataframe, index_col):
    """
    runs pandas.crosstab with a given dataframe and index column
    and ensures consistent data selection

    Args:
        dataframe (pandas.DataFrame): dataframe to base crosstab on
        index_col (str): name of index column

    Returns:
        pandas.DataFrame: pd.crosstab output
    """
    crosstab_args = lambda df: {
        "columns": df.year,
        "values": df.case_number,
        "aggfunc": "nunique",
        "margins": True,
        "margins_name": "Total",
    }
    return pd.crosstab(index=dataframe[index_col], **crosstab_args(dataframe)).iloc[
        :, :-1  # drop the total column, I only want total row
    ]


if __name__ == "__main__":
    df = pd.read_csv(
        sys.argv[1],
        dtype={"year": int},
        low_memory=False,
    )

    NBD_SHEET = "By Neighborhood"

    # get citywide crosstabs
    dfs = {
        "Citywide Totals": crosstab(df, "crime_category"),
        NBD_SHEET: crosstab(df, "pri_neigh"),
    }

    # get a crosstab by type for each neighborhood
    for neighborhood_name in df.pri_neigh.unique():
        if neighborhood_name != "NO NEIGHBORHOOD DATA":
            nbd_df = df[df.pri_neigh == neighborhood_name]
            dfs[neighborhood_name] = crosstab(nbd_df, "crime_category")

    # write to Excel
    with pd.ExcelWriter(sys.argv[2], engine="xlsxwriter") as writer:
        for sheet_name, sheet_df in dfs.items():
            sheet_df.to_excel(writer, sheet_name=sheet_name)
            worksheet = writer.book.get_worksheet_by_name(sheet_name)

            # update the "by neighborhood" sheet with hyperlinks to other excel sheets
            if sheet_name == NBD_SHEET:
                for row_index, ref_sheet_name in enumerate(sheet_df.index):
                    worksheet.write_url(
                        row=row_index + 1,  # +1 because there's a header row
                        col=0,
                        url=f"internal:'{ref_sheet_name}'!A1",
                        string=ref_sheet_name,
                        tip="Jump to sheet",
                    )

            # do auto-fit
            for i, width in enumerate(get_col_widths(sheet_df)):
                worksheet.set_column(
                    first_col=i,
                    last_col=i,
                    width=width,
                )
