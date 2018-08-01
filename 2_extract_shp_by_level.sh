#!/usr/bin/env bash

for year in "2013" "2016"
do

for proj in "etrs89" "laea" "wm"
do

    #make folders
    dirRG="tmp/"$year"/"$proj"/RGbylevel"
    dirBN="tmp/"$year"/"$proj"/BNbylevel"
    mkdir -p $dirRG
    mkdir -p $dirBN

    for level in 0 1 2 3
    do
        echo "$year $proj $level NUTS RG: extract by level "
        ogr2ogr -overwrite -lco ENCODING=UTF-8 \
            -sql "SELECT * FROM NUTS_RG WHERE LEVL_CODE="$level \
            $dirRG"/RG_lvl"$level".shp" \
            "tmp/"$year"/"$proj"/NUTS_RG.shp"
            #" AND NUTS_ID NOT IN ('FRA','FRA1','FRA2','FRA3','FRA4','FRA5','FRA10','FRA20','FRA30','FRA40','FRA50','PT2','PT20','PT200','PT3','PT30','PT300','ES7','ES70','ES701','ES702','ES703','ES704','ES705','ES706','ES707','ES708','ES709')"

        echo "$year $proj $level NUTS BN: extract by level "
        ogr2ogr -overwrite -lco ENCODING=UTF-8 \
            -sql "SELECT * FROM NUTS_BN WHERE LEVL_CODE<="$level" AND COAS_FLAG <> 'T'" \
            $dirBN"/BN_lvl"$level".shp" \
            "tmp/"$year"/"$proj"/NUTS_BN.shp"
    done
done

done
