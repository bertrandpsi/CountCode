#!/bin/sh

# awk 'NF' skips the empty lines
# let allows to calculate

outmode="txt"

echo "Code counting script - (c) 2022 - Alain Bertrand"

if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]; then
    echo "$0 <path_to_check>"
    exit 1
fi

if [ "$#" -eq 2 ]; then
    outmode=$2
    echo "Outmode $outmode"
fi

# Navigate to the selected directory
cd $1

totlines=0
totdays=0
totfiles=0

# Place here the kind of file types you want to parse
filetypes=("*.cs" "*.cshtml" "*.js" "*.less" "*.md" "*.sh")
# Place here their logical name
filenames=("C#" "CSHTML" "JavaScript" "LESS" "Markdown" "Shell")
# Place here the average number of lines you produce per day with this kind of file
devspeed=(300 600 300 600 300 100)

if [ $outmode = "md" ]; then
        echo "## Code base"
        echo "| Type | Files | Lines |"
        echo "|:--|--:|--:|"
fi

# Iterates all the file types
for i in ${!filetypes[@]}; do
        fext=${filetypes[$i]}
        fname=${filenames[$i]}
        fspeed=${devspeed[$i]}

        f=`find . -type f -name "$fext" -not -path "*/Migrations/*" -not -path "*/lib/*" -not -path "*/Release/*" -not -path "*/bin/*"`
        files=`echo $f | wc -w | tail -1 | tr -dc '0-9'`
        line=`echo $f | xargs awk 'NF' | wc -l | tail -1 | tr -dc '0-9'`
        let pages=$line/65
        let days=$line/$fspeed
        let totdays+=days
        let totlines+=$line
        let totfiles+=$files
        if [ $outmode = "md" ]; then
                printf "| %s | %'.0f | %'.0f |\n" $fname $files $line
        else
                echo "$fname Files lines: (@ $fspeed lines a day)"
                printf "%'.0f file(s) / %'.0f line(s)\n" $files $line
                echo ""
        fi
done

# Prints out the final stats
if [ $outmode = "md" ]; then
        echo "### Project total"
        echo "| Stats | Nb |"
        echo "|:--|--:|"
        printf "| Lines | %'.0f |\n" $totlines
        printf "| Files | %'.0f |\n" $totfiles
        let pages=$totlines/65
        printf "| Book pages | %'.0f |\n" $pages
        printf "| Usual day(s) | %'.0f |\n" $totdays
        let weeks=totdays/5
        printf "| Usual weeks(s) | %'.0f |\n" $weeks
else
        echo "Project total:"
        printf "Lines:          %'.0f\n" $totlines
        printf "Files:          %'.0f\n" $totfiles
        let pages=$totlines/65
        printf "Book pages:     %'.0f\n" $pages
        printf "Usual day(s):   %'.0f\n" $totdays
        let weeks=totdays/5
        printf "Usual weeks(s): %'.0f\n" $weeks
fi
echo ""
echo "Usual days of work are calculated as an average number of lines of code produced per an 8h day of work. Complex tasks may produce lot less code per day while easy task may produce more."
