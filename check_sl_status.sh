#!/bin/bash

function check_sl {
    TRAFFICTYPES=$(curl -s "http://api.sl.se/api2/trafficsituation.json?key=" |  jq '.ResponseData?' | jq '.TrafficTypes?')
    # TRAFFICTYPES="[
    #                 {
    #                     \"Name\":\"Pendeltåg\", 
    #                     \"StatusIcon\":\"EventGood\"
    #                 }, 
    #                 {   
    #                     \"Name\":\"Tunnelbana\", 
    #                     \"StatusIcon\":\"EventMinor\"
    #                 }, 
    #                 {
    #                     \"Name\":\"Pendelbåt\", 
    #                     \"StatusIcon\":\"EventGood\"
    #                 },
    #                 {
    #                     \"Name\":\"Buss\", 
    #                     \"StatusIcon\":\"EventGood\"
    #                 }
    #               ]"
    LENGTH=$(jq length <<< "$TRAFFICTYPES")

    for (( i=0; i<$LENGTH; i++ ))
    do
        NAME=$(jq .["$i"] <<< $TRAFFICTYPES | jq '.Name?')
        STATUS=$(jq .["$i"] <<< $TRAFFICTYPES | jq '.StatusIcon?')
        if ([ "$NAME" = "\"Buss\"" ] || [ "$NAME" = "\"Tunnelbana\"" ] || [ "$NAME" = "\"Pendeltåg\"" ]) && [ "$STATUS" != "\"EventGood\"" ]
        then
            echo "{\"today\":1, \"total\":"$1", \"day\":"$2"}" > status.json
            break
        fi
    done    
}

TODAY=$(jq '.today?' "status.json")
TOTAL=$(jq '.total?' "status.json")
DAY=$(jq '.day?' "status.json")
DOW=$(date +%u)

if [ "$DAY" != "$DOW" ] 
then
    echo "{\"today\":0, \"total\":"$(($TODAY + $TOTAL))", \"day\":"$DOW"}" > status.json
    check_sl $(($TODAY + $TOTAL)) $DOW
elif [ "$TODAY" = 0 ] 
then
    check_sl $TOTAL $DOW
fi
