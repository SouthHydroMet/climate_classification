# climate_classification

Climate classification of continental Chile on a 0.05° grid. Each grid cell
is assigned to one of 10 climate groups (`group`), obtained with
**AutoClass-C** (Bayesian unsupervised classification) followed by a
posterior analysis of the resulting classes.

This classification was used in:

> Vásquez, N. A., Mendoza, P. A., Knoben, W. J. M., Arnal, L., Lagos-Zúñiga, M.,
> Clark, M. P., & Vargas, X. (2024). The key role of temporal stratification for
> GCM bias correction in climate impact assessments. *Earth's Future*, 12(8),
> e2023EF004242. https://doi.org/10.1029/2023EF004242

Please cite this publication if you use the data.

---

## Repository layout

| Path | Contents |
|---|---|
| `data/climateGroups.txt` | Climate attributes and climate group for each grid cell (38,469 cells) |
| `figures/fig_01.pdf` | Spatial distribution of the climate attributes: elevation, precipitation, temperature, snowfall fraction, aridity index and precipitation seasonality |
| `figures/fig_03.pdf` | Map of the 10 climate groups and distribution of each attribute by group |

## Data format

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
atts <- read.table("data/climateGroups.txt", sep = "|", header = TRUE)
```

Reading it in Python:

```python
import pandas as pd
atts = pd.read_csv("data/climateGroups.txt", sep="|")
```

## License

The data and figures are released under the
[Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)
license. You may use, share and adapt them for any purpose, provided you cite
the publication above. See [`LICENSE`](LICENSE).

## Contact

Nicolás Vásquez — nicolas.vasquez@ucalgary.ca
Pablo Mendoza — pamendoz@uchile.cl
