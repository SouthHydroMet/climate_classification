# climate_classification

Climate classifications of continental Chile on a 0.05° grid:

1. **`climate_classification/`** — 10 climate groups obtained with
   **AutoClass-C** (Bayesian unsupervised classification) followed by a
   posterior analysis of the resulting classes.
2. **`KG_classification/`** — **Köppen-Geiger** classification for CR2MET
   (1980–2014) and for 33 bias-corrected climate models over historical and
   future periods.

## References

Please cite the corresponding publication if you use these data:

- **Climate groups (AutoClass-C):**

  > Vásquez, N. A., Mendoza, P. A., Knoben, W. J. M., Arnal, L., Lagos-Zúñiga, M.,
  > Clark, M. P., & Vargas, X. (2024). The key role of temporal stratification for
  > GCM bias correction in climate impact assessments. *Earth's Future*, 12(8),
  > e2023EF004242. https://doi.org/10.1029/2023EF004242

- **Köppen-Geiger classification:**

  > Vásquez, N. A., Mendoza, P. A., Lagos-Zúñiga, M., Scaff, L., Muñoz-Castro, E.,
  > & Vargas, X. (2025). Robust spatial changes in climate classes: insights from
  > bias-corrected CMIP6 models across Chile. *Environmental Research Letters*,
  > 20(1). https://doi.org/10.1088/1748-9326/ad9d5b

---

## Repository layout

| Path | Contents |
|---|---|
| `climate_classification/data/climateGroups.txt` | Climate attributes and climate group for each grid cell (38,469 cells) |
| `climate_classification/figures/fig_01.pdf` | Spatial distribution of the climate attributes: elevation, precipitation, temperature, snowfall fraction, aridity index and precipitation seasonality |
| `climate_classification/figures/fig_03.pdf` | Map of the 10 climate groups and distribution of each attribute by group |
| `climate_classification/figures/groups_separated.pdf` | Map of each climate group shown separately (groups 1–10) |
| `KG_classification/01_CR2MET/` | Köppen-Geiger classification from CR2MET, 1980–2014 (`KG_classif_CR2MET_1980-2014.RData`) and the R scripts that produce it |
| `KG_classification/02_GCM/` | Köppen-Geiger classification for each climate model (`KG_classif_<model>.RData`) and the R scripts that produce it |
| `KG_classification/KG_plot_labels.xlsx` | Köppen-Geiger class labels, long names and RGB colours (following Peel et al., 2007 and Beck et al., 2018) |

## Climate groups (`climate_classification/`)

`data/climateGroups.txt` is a pipe-delimited (`|`) text file with a header row,
sorted by `ID`.

| Column | Description | Units |
|---|---|---|
| `ID` | Grid cell ID | – |
| `Lat` | Latitude of the cell centroid | ° |
| `Lon` | Longitude of the cell centroid | ° |
| `P` | Annual mean precipitation | mm/yr |
| `Tas` | Annual mean air temperature | °C |
| `snow_frac` | Annual mean snowfall fraction | – |
| `p_seasonality` | Precipitation seasonality | – |
| `AI` | Aridity index (PET / P) | – |
| `group` | Climate group (1–10) | – |
| `elev_mean` | Mean elevation of the grid cell | m a.s.l. |

Reading it in R:

```r
atts <- read.table("climate_classification/data/climateGroups.txt", sep = "|", header = TRUE)
```

Reading it in Python:

```python
import pandas as pd
atts = pd.read_csv("climate_classification/data/climateGroups.txt", sep="|")
```

## Köppen-Geiger classification (`KG_classification/`)

Each `.RData` file contains a data frame called `KG_classif`, with one row per
grid cell (CR2MET) or per grid cell and period (climate models).

| Column | Description |
|---|---|
| `ID` | Grid cell ID |
| `lat`, `lon` | Coordinates of the cell centroid (°) |
| `periodo` | Period (climate models only): `1980-2014`, `2015-2049`, `2041-2075`, `2065-2100` |
| `fst_class` | First letter of the Köppen-Geiger class (e.g. `B`, `C`, `D`, `E`) |
| `snd_class` | Second letter (e.g. `W`, `S`, `s`, `f`, `T`, `F`) |
| `third_class` | Third letter (e.g. `a`, `b`, `c`, `h`, `k`) |
| `KG_class` | Full class name and code, e.g. `Temperate - No dry season - Cold summer (Cfc)` (CR2MET only) |
| `gcm` | Climate model name (climate models only) |

The classification for the climate models uses monthly climatologies bias
corrected with MBCn. The class codes and colours are listed in
`KG_plot_labels.xlsx`.

Reading it in R:

```r
load("KG_classification/01_CR2MET/KG_classif_CR2MET_1980-2014.RData")
head(KG_classif)
```

The scripts (`01_CR2MET.R`, `01_KG_GCM.R`, `fn_KoppenGeiger.R`) use absolute
paths to the original input data, which are not included in this repository;
set the directories at the top of each script before running them.

## License

The data and figures are released under the
[Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)
license. You may use, share and adapt them for any purpose, provided you cite
the corresponding publication above. See [`LICENSE`](LICENSE).

## Contact

Nicolás Vásquez — nicolas.vasquez@ucalgary.ca  
Pablo Mendoza — pamendoz@uchile.cl
