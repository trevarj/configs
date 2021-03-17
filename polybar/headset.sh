#!/bin/bash

if bat=$(arctis -b);
then
        bat=$(echo "$bat" | awk '{print $3}' | tr -d %)
        if [ $bat -eq 0 ]; then
                echo ""
        elif [ $bat -le 10 ]; then
                echo ""
        elif [ $bat -le 30 ]; then
                echo ""
        elif [ $bat -le 50 ]; then
                echo ""
        elif [ $bat -le 90 ]; then
                echo ""
        else
                echo ""
        fi
fi
