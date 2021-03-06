#!/usr/bin/env bash

#4326-wgs84 4258-etrs89 3857-wm 3035-laea
projs=("4326" "4258" "3857" "3035")
xmin=(-25 -25 -2800000 2434560)
ymin=(32.5 32.5 3884000 1340340)
xmax=(46.5 46.5 5200000 7512390)
ymax=(73.9 73.9 11690000 5664590)

years=("2016" "2013" "2010")
filters=("'PT','ES','IE','UK','FR','IS','BE','LU','NL','CH','LI','DE','DK','IT','VA','MT','NO','SE','FI','EE','LV','LT','PL','CZ','SK','AT','SI','HU','HR','RO','BG','TR','EL','CY','MK','ME','RS','AL'" "'PT','ES','IE','UK','FR','IS','BE','LU','NL','CH','LI','DE','DK','IT','VA','MT','NO','SE','FI','EE','LV','LT','PL','CZ','SK','AT','SI','HU','HR','RO','BG','TR','EL','CY','MK','ME'" "'PT','ES','IE','UK','FR','IS','BE','LU','NL','CH','LI','DE','DK','IT','VA','MT','NO','SE','FI','EE','LV','LT','PL','CZ','SK','AT','SI','HU','HR','RO','BG','TR','EL','CY','MK','ME'")


for yi in ${!years[@]}
do

year=${years[yi]}
filter=${filters[yi]}

for scale in "10" "20" "60"
do

dir="../tmp/$year/$scale"
mkdir -p $dir

echo "1- $year $scale NUTS RG: Clip, filter, join names"
ogr2ogr -overwrite -f "ESRI Shapefile" -lco ENCODING=UTF-8 \
   $dir"/NUTS_RG.shp" \
   "../shp/"$year"/NUTS_RG_"$scale"M_"$year"_4326.shp" \
   -sql "SELECT N.NUTS_ID as id,A.NAME_LATN as na,N.LEVL_CODE as lvl FROM NUTS_RG_"$scale"M_"$year"_4326 as N left join '../shp/"$year"/NUTS_AT_"$year".csv'.NUTS_AT_"$year" as A on N.NUTS_ID = A.NUTS_ID" \
   -clipsrc -120.02 25.02 120.02 89.02

echo "1- $year $scale NUTS BN: Clip and filter"
ogr2ogr -overwrite -f "ESRI Shapefile" -lco ENCODING=UTF-8 \
   $dir"/NUTS_BN.shp" \
   "../shp/"$year"/NUTS_BN_"$scale"M_"$year"_4326.shp" \
   -sql "SELECT NUTS_BN_ID as id,LEVL_CODE as lvl,EU_FLAG as eu,EFTA_FLAG as efta,CC_FLAG as cc,OTHR_FLAG as oth,COAS_FLAG as co FROM NUTS_BN_"$scale"M_"$year"_4326" \
   -clipsrc -120.02 25.02 120.02 89.02

echo "1- $year $scale Country RG: Clip and filter"
ogr2ogr -overwrite -f "ESRI Shapefile" -lco ENCODING=UTF-8 \
   $dir"/CNTR_RG.shp" \
   "../shp/"$year"/CNTR_RG_"$scale"M_"$year"_4326.shp" \
-sql "SELECT CNTR_ID as id,NAME_ENGL as na FROM CNTR_RG_"$scale"M_"$year"_4326 WHERE CNTR_ID NOT IN ("$filter")" \
   -clipsrc -120.02 25.02 120.02 89.02

#necessary?
#echo "$year Country RG: Join attributes"
#ogr2ogr -overwrite -f "ESRI Shapefile" -lco ENCODING=UTF-8 \
#   "tmp/"$year"/CNTR_RG.shp" \
#   "tmp/"$year"/CNTR_RG_.shp" \
#   -sql "select CNTR_RG_.CNTR_ID as cid, CNTR_AT_"$year".CNTR_NAME as cna from CNTR_RG_ left join 'shp/"$year"/CNTR_AT_"$year".csv'.CNTR_AT_"$year" on CNTR_RG_.CNTR_ID = CNTR_AT_"$year".CNTR_ID" \
#   -clipsrc -179 -89 179 89

echo "1- $year $scale Country BN: Clip and filter"
ogr2ogr -overwrite -f "ESRI Shapefile" -lco ENCODING=UTF-8 \
   $dir"/CNTR_BN.shp" \
   "../shp/"$year"/CNTR_BN_"$scale"M_"$year"_4326.shp" \
   -sql "SELECT CNTR_BN_ID as id,CC_FLAG as cc,OTHR_FLAG as oth,COAS_FLAG as co FROM CNTR_BN_"$scale"M_"$year"_4326 WHERE EU_FLAG='F' AND EFTA_FLAG='F'" \
   -clipsrc -120.02 25.02 120.02 89.02


echo "1- $year $scale Graticule: Clip"
ogr2ogr -overwrite -f "ESRI Shapefile" -lco ENCODING=UTF-8 \
   $dir"/graticule_.shp" \
   "../shp/graticule.shp" \
   -clipsrc -120.02 25.02 120.02 85


  for pi in ${!projs[@]}
  do
    proj=${projs[pi]}

    dir="../tmp/$year/$scale/$proj"
    mkdir -p $dir

    echo "1- $year $scale $proj Graticule: Project"
    ogr2ogr -overwrite -f "ESRI Shapefile" -lco ENCODING=UTF-8 \
            $dir"/graticule__.shp" \
            "../tmp/$year/$scale/graticule_.shp" \
            -t_srs EPSG:$proj -s_srs EPSG:4258

    echo "1- $year $scale $proj Graticule: Clip"
    ogr2ogr -overwrite -f "ESRI Shapefile" -lco ENCODING=UTF-8 \
            $dir"/graticule.shp" \
            $dir"/graticule__.shp" \
            -clipsrc ${xmin[pi]} ${ymin[pi]} ${xmax[pi]} ${ymax[pi]}

    for type in "RG" "BN"
    do
    	dir="../tmp/$year/$scale/$proj/$type"
        mkdir -p $dir

        echo "1- $year $scale $proj $type NUTS: Project"
        ogr2ogr -overwrite -f "ESRI Shapefile" -lco ENCODING=UTF-8 \
            $dir"/NUTS_proj.shp" \
            "../tmp/"$year"/"$scale"/NUTS_"$type".shp" \
            -t_srs EPSG:$proj -s_srs EPSG:4258

        echo "1- $year $scale $proj $type NUTS: Clip"
        ogr2ogr -overwrite -f "ESRI Shapefile" -lco ENCODING=UTF-8 \
            $dir"/NUTS.shp" \
            $dir"/NUTS_proj.shp" \
            -clipsrc ${xmin[pi]} ${ymin[pi]} ${xmax[pi]} ${ymax[pi]}

        echo "1- $year $scale $proj $type Country: Project"
        ogr2ogr -overwrite -f "ESRI Shapefile" -lco ENCODING=UTF-8 \
            $dir"/CNTR_proj.shp" \
            "../tmp/"$year"/"$scale"/CNTR_"$type".shp" \
            -t_srs EPSG:$proj -s_srs EPSG:4258

        echo "1- $year $scale $proj $type Country: Clip"
        ogr2ogr -overwrite -f "ESRI Shapefile" -lco ENCODING=UTF-8 \
            $dir"/CNTR.shp" \
            $dir"/CNTR_proj.shp" \
            -clipsrc ${xmin[pi]} ${ymin[pi]} ${xmax[pi]} ${ymax[pi]}

    done
  done

done
done

