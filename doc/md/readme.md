# Building Documentation for multiple outputs

Markdown was chosen as the intermediate format from the original HTML due to it's easy to write format and interoperability with other formats.

GNU Project documentation should be in the texinfo format.

## Conversion to texinfo

Download the pandoc application package from the Linux distribution of you choice and then convert the markdown file to texinfo.

### Example:
```
$ pandoc -f markdown -t texinfo installation.md -o installation.texinfo
```

## Conversion to other formats

Pandoc can also convert markdown into other formats such as html, PDF, and many more. There is also converters for texinfo such as `texi2dvi`, `texi2html`, and `texi2pdf`. However it is probably best to do as few conversions a possible as each conversion utility is imperfect and may leave unwanted formatting issues with each conversion. See you Linux distribution's package manager for information on how to install these utilities.
