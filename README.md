# Nuts2json

[Nuts2json](https://github.com/eurostat/Nuts2json) provides various reusable versions of [Eurostat NUTS dataset](http://ec.europa.eu/eurostat/web/nuts/overview) as web formats such as [TopoJSON](https://github.com/mbostock/topojson/wiki) and [GeoJSON](http://geojson.org/). It is provided to support the development of statistical web maps of [Eurostat data](http://ec.europa.eu/eurostat/) based on NUTS regions. In a way, it provides a blank map of geometries ready for use with your own data and colors.

NB: For a faster creation of maps based on Nuts2json, check out [eurostat-map.js](https://github.com/eurostat/eurostat.js/blob/master/doc/README-map.md) !

See [some examples below](https://github.com/eurostat/Nuts2json#usage-examples).

[![Example](img/ex_population.png)](https://bl.ocks.org/jgaffuri/raw/0d6e1b1c6f9e1297829f38b9c37737fe?proj=3035&lvl=3&w=1000&s=20M&time=2016)

## API

The files can be retrieved on-the-fly from the base URL `https://raw.githubusercontent.com/eurostat/Nuts2json/gh-pages/` according to one of these file patterns:

- For TopoJSON format: `/<YEAR>/<PROJECTION>/<SCALE>/<NUTS_LEVEL>.json`
- For GeoJSON format: `/<YEAR>/<PROJECTION>/<SCALE>/<TYPE>[_<NUTS_LEVEL>].json`

For example, [`https://raw.githubusercontent.com/eurostat/Nuts2json/gh-pages/2016/3035/20M/2.json`](https://raw.githubusercontent.com/eurostat/Nuts2json/gh-pages/2016/3035/20M/2.json)</a> returns a TopoJSON file of 2016 NUTS regions level 2 in European LAEA projection ([EPSG 3035](http://spatialreference.org/ref/epsg/etrs89-etrs-laea/)) at 1:20M scale.

The parameters are:

| Parameter | Supported values | Description |
| ------------- | ------------- |-------------|
| `YEAR` | `2016` `2013` `2010` | The NUTS version. |
| `PROJECTION` | `3035` `3857` `4258` | The coordinate reference system EPSG code. Two projections are provided: European LAEA projection ([EPSG 3035](http://spatialreference.org/ref/epsg/etrs89-etrs-laea/)) and web mercator ([EPSG 3857](http://spatialreference.org/ref/sr-org/7483/)). For statistical maps, it is strongly adviced to use an equal-area projection such as `3035`. Geographic coordinates ETRS89 ([EPSG 4258](http://spatialreference.org/ref/epsg/4258/)) are provided. |
| `SCALE` | `60M` `20M` `10M` | The intended map scale factor. The larger the value, the stronger the simplification. For example, for a map width of 1000 pixels the scale 1:20M is the most suitable. |
| `NUTS_LEVEL` | `0` `1` `2` `3` | The NUTS level to be displayed on the map, from national (NUTS_LEVEL=`0`) to local level (NUTS_LEVEL=`3`). |
| `TYPE` | `nutsrg` `nutsbn` `cntrg` `cntbn` `gra` | For GeoJSON format, the feature type has to be specified. The available feature types are described below. For NUTS feature types (`nutsrg` and `nutsbn`), the `NUTS_LEVEL` to be displayed on the map has to be specified.  |

For additional projections, formats, scales, etc., feel free to [ask](https://github.com/eurostat/Nuts2json/issues/new) !

### Feature types

Five feature types are provided:

- NUTS regions (feature type `nutsrg`) with the following properties:
  - `id`: The NUTS identifier to be used to join Eurostat statistical figures and then assign colors to the regions.
  - `na`: The geographical name of the region.

- NUTS boundaries (feature type `nutsbn`) with the following properties:
  - `lvl`: The NUTS level of the boundary, from 0 (national level) to 3 (provincial level).
  - `eu`: T if the boundary separate two EU member states, F otherwise.
  - `efta`: T if the boundary touches at least one EFTA country, F otherwise.
  - `cc`: T if the boundary touches at least one Candidate Country, F otherwise.
  - `oth`: T if the boundary touches a country wich is not EU, EFTA,CC. F otherwise.
  - `co`: T if the boundary is coastal. F otherwise.

- Non-european countries (feature type `cntrg`) with the following properties:
  - `id`: The country identifier (2 letters code).
  - `na`: The country name.

- Non-european boundaries (feature type `cntbn`) with a single property:
  - `co`: T if the boundary is coastal. F otherwise.

- The map graticule (meridian and parrallel lines) is provided as feature type `gra` with a single `id` property:

## Usage examples

- [Basic example](https://bl.ocks.org/jgaffuri/raw/e7e0a76a6e0f851b253d3b1c8fb17ffb/) (see the [code](https://bl.ocks.org/jgaffuri/e7e0a76a6e0f851b253d3b1c8fb17ffb)).
- [Overview example](https://bl.ocks.org/jgaffuri/raw/71d130bf5963c5ffe0a436399f401af3/) (see the [code](https://bl.ocks.org/jgaffuri/71d130bf5963c5ffe0a436399f401af3)).
- [Population map](https://bl.ocks.org/jgaffuri/raw/0d6e1b1c6f9e1297829f38b9c37737fe?proj=3035&lvl=3&w=1000&s=20M&time=2016) (see the [code](https://bl.ocks.org/jgaffuri/0d6e1b1c6f9e1297829f38b9c37737fe)) based on [eurostat-map.js](https://github.com/eurostat/eurostat.js/blob/master/doc/README-map.md).

These examples are based on [d3js](https://d3js.org/) and [Eurostat statistical data API](http://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/rest-request).

## Technical details

These files are produced from the NUTS SHP files provided on [Eurostat-GISCO website](http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts). The input SHP files are in the [shp folder](/shp). These input files are transformed using [GDAL](http://www.gdal.org/) and [TopoJSON](https://github.com/mbostock/topojson/wiki). The processes are automated in bash files, which are also shared in this repository.

## Support and contribution

Feel free to [ask support](https://github.com/eurostat/Nuts2json/issues/new), fork the project or simply star it (it's always a pleasure).

## Copyright

The [Eurostat NUTS dataset](http://ec.europa.eu/eurostat/web/nuts/overview) is copyrighted. See the [Eurostat-GISCO website](http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts) for more information.
