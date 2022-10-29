#!/bin/sh

# awk 'NF' skips the empty lines
# let allows to calculate

echo "Code counting script - (c) 2022 - Alain Bertrand"

if [ "$#" -ne 1 ]; then
    echo "$0 <path_to_check>"
    exit 1
fi

# Navigate to the selected directory
cd $1

totlines=0
totdays=0
totfiles=0

# Place here the kind of file types you want to parse
filetypes=("*.cs" "*.cshtml" "*.js" "*.less")
# Place here their logical name
filenames=("C#" "CSHTML" "JavaScript" "LESS")
# Place here the average number of lines you produce per day with this kind of file
devspeed=(300 600 300 600)

# Iterates all the file types
for i in ${!filetypes[@]}; do
        fext=${filetypes[$i]}
        fname=${filenames[$i]}
        fspeed=${devspeed[$i]}

        echo "$fname Files lines: (@ $fspeed lines a day)"
        f=`find . -type f -name $fext -not -path "*/Migrations/*" -not -path "*/lib/*"`
        files=`echo $f | wc -w | tail -1 | tr -dc '0-9'`
        line=`echo $f | xargs awk 'NF' | wc -l | tail -1 | tr -dc '0-9'`
        let pages=$line/65
        let days=$line/$fspeed
        let totdays+=days
        let totlines+=$line
        let totfiles+=$files
        echo "$files file(s) / $line line(s)"
        echo ""
done

# Prints out the final stats
echo "Project total:"
echo "Lines:          $totlines"
echo "Files:          $totfiles"
let pages=$totlines/65
echo "Book pages:     $pages"
echo "Usual day(s):   $totdays"
let weeks=totdays/5
echo "Usual weeks(s): $weeks"
echo ""
echo "Usual days of work are calculated as an average number of lines of code produced per an 8h day of work. Complex tasks may produce lot less code per day while easy task may produce more."
