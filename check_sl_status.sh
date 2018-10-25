#!/bin/bash

function check_sl {
    # TRAFFICTYPES=$(curl -s "http://api.sl.se/api2/trafficsituation.json?key=APIKEY" |  jq '.ResponseData?' | jq '.TrafficTypes?')
    TRAFFICTYPES="[
                    {
                        \"Name\":\"Pendeltåg\", 
                        \"StatusIcon\":\"EventGood\"
                    }, 
                    {   
                        \"Name\":\"Tunnelbana\", 
                        \"StatusIcon\":\"EventMinor\"
                    }, 
                    {
                        \"Name\":\"Pendelbåt\", 
                        \"StatusIcon\":\"EventGood\"
                    },
                    {
                        \"Name\":\"Buss\", 
                        \"StatusIcon\":\"EventGood\"
                    }
                  ]"
    LENGTH=$(jq length <<< "$TRAFFICTYPES")

    for (( i=0; i<$LENGTH; i++ ))
    do
        NAME=$(jq .["$i"] <<< $TRAFFICTYPES | jq '.Name?')
        STATUS=$(jq .["$i"] <<< $TRAFFICTYPES | jq '.StatusIcon?')
        if ([ "$NAME" = "\"Buss\"" ] || [ "$NAME" = "\"Tunnelbana\"" ] || [ "$NAME" = "\"Pendeltåg\"" ]) && [ "$STATUS" != "\"EventGood\"" ]
        then
            echo "{\"today\":1, \"total\":"$1", \"day\":"$2"}" > status.txt
            break
        fi
    done    
}

TODAY=$(jq '.today?' "status.txt")
TOTAL=$(jq '.total?' "status.txt")
DAY=$(jq '.day?' "status.txt")
DOW=$(date +%u)

if [ "$DAY" != "$DOW" ] 
then
    echo "{\"today\":0, \"total\":"$(($TODAY + $TOTAL))", \"day\":"$DOW"}" > status.txt
    check_sl $(($TODAY + $TOTAL)) $DOW
elif [ "$TODAY" = 0 ] 
then
    check_sl $TOTAL $DOW
fi
