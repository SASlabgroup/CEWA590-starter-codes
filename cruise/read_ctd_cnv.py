# Read R/V Carson CTD data from a .cnv file and plot it.
# %%
import re

import matplotlib.pyplot as plt
import pandas as pd

# %%
CTD_CNV_FILE_PATH = './data/20240430_CTD01_sta01.cnv'

ctd_metadata = {
    0: "Depth [salt water, m]",
    1: "Temperature [ITS-90, deg C]",
    2: "Salinity, Practical [PSU]",
    3: "Altimeter [m]",
    4: "Beam Attenuation, WET Labs C-Star [1/m]",
    5: "Conductivity [S/m]",
    6: "Density [density, kg/m^3]",
    7: "Fluorescence, WET Labs ECO-AFL/FL [mg/m^3]",
    8: "Oxygen, SBE 43 [mg/l]",
    9: "PAR/Irradiance, Biospherical/Licor",
    10: "pH",
    11: "Flag",
}

# %%
start_time_regex_pattern = r'([A-Z][a-z]{2}\s\d{2}\s\d{4}\s\d{2}:\d{2}:\d{2})'

# Loop through lines until the end of the header is reached. The count
# at this point (plus 1) should be the start of the data.
with open(CTD_CNV_FILE_PATH, 'r') as f:
    for count, line in enumerate(f):
        if 'interval' in line:
            dt_str = line.split(':')[-1].strip()
            dt = float(dt_str)
        if 'start_time' in line:
            print(line)
            is_match = re.search(start_time_regex_pattern, line)
            if is_match:
                start_time = pd.to_datetime(is_match.group())
        if '*END*' in line:
            break

data_start = count + 1
# %%
ctd_data = pd.read_csv(CTD_CNV_FILE_PATH,
                       sep=r'\s+',
                       skiprows=data_start,
                       names=ctd_metadata.values())

ctd_data = ctd_data.set_index(start_time + pd.to_timedelta(ctd_data.index * dt, unit='s'))

# %%
start_time = pd.Timestamp('2024-04-30 16:45')
end_time = pd.Timestamp('2024-04-30 16:57')
ctd_data_subset = ctd_data[start_time:end_time]

fig, ax = plt.subplots(figsize=(4, 6))
sc = ax.scatter(
    x=ctd_data_subset["Salinity, Practical [PSU]"],
    y=-ctd_data_subset["Depth [salt water, m]"],
    c=pd.to_numeric(ctd_data_subset.index),
)
cbar = fig.colorbar(sc, ax=ax)
cbar_ticks = pd.date_range(start_time, end_time, freq='2min')
cbar.set_ticks(
    ticks=pd.to_numeric(cbar_ticks),
    labels=pd.to_datetime(cbar_ticks)
)
ax.set_ylabel("Depth [salt water, m]")
ax.set_xlabel("Salinity, Practical [PSU]")

# %%
fig, ax = plt.subplots(figsize=(4, 6))
sc = ax.scatter(
    x=ctd_data_subset["Oxygen, SBE 43 [mg/l]"],
    y=-ctd_data_subset["Depth [salt water, m]"],
    c=pd.to_numeric(ctd_data_subset.index),
)
cbar = fig.colorbar(sc, ax=ax)
cbar_ticks = pd.date_range(start_time, end_time, freq='2min')
cbar.set_ticks(
    ticks=pd.to_numeric(cbar_ticks),
    labels=pd.to_datetime(cbar_ticks)
)
ax.set_ylabel("Depth [salt water, m]")
ax.set_xlabel("Oxygen, SBE 43 [mg/l]")

# %%