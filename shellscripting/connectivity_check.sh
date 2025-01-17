#! bin/bash


read  -p  "Which Website you WantTO Check? "  site

ping -c  1 $site

if [[ $? -eq 0  ]]
then
         echo "Succesfully Connected to $site"
else
         echo "Unable to Connected $site"
fi
