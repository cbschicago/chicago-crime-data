"""performs a geopandas spatial join to add the names of neighborhoods to the data"""

import sys
import geopandas as gpd
import pandas as pd

CRS = "EPSG:4326"

df = pd.read_csv(
    sys.stdin,
    low_memory=False,
    dtype={"latitude": float, "longitude": float},
)
df = gpd.GeoDataFrame(df, geometry=gpd.points_from_xy(df.longitude, df.latitude))
df.crs = CRS

geo = gpd.read_file(sys.argv[1])
assert geo.crs == CRS

df = gpd.sjoin(df, geo, how="left", predicate="within")
df["pri_neigh"] = df.pri_neigh.fillna("NO NEIGHBORHOOD DATA")

print(df.to_csv(index=False, line_terminator="\n"))
