# CountCode

A simple bash script allowing to count the code of a given source directory.

I use it to get some stats of my .NET development reason of which the paths specific to .NET are filtered

## Usage
```./code_count.sh <your_project_path>```

or if you want Markdown results:

```./code_count.sh <your_project_path> md```

## Markdown example output
### Code base
| Type | Files | Lines |
|:--|--:|--:|
| C# | 382 | 28’158 |
| CSHTML | 73 | 6’003 |
| JavaScript | 22 | 3’893 |
| LESS | 21 | 3’461 |
| Markdown | 32 | 491 |
| Shell | 3 | 21 |
### Project total
| Stats | Nb |
|:--|--:|
| Lines | 42’027 |
| Files | 533 |
| Book pages | 646 |
| Usual day(s) | 121 |
| Usual weeks(s) | 24 |

Usual days of work are calculated as an average number of lines of code produced per an 8h day of work. Complex tasks may produce lot less code per day while easy task may produce more.

