# Data for a register of charities

Data for a [register](registers.cloudapps.digital/registers) of charities.

The Charities Commission provides monthly [zipped data
dumps](http://data.charitycommission.gov.uk/default.aspx), which must be
converted from the MS SQL Server bcp format into CSV, using
[scripts](https://github.com/ncvo/charity-commission-extract) by the National
Council of Voluntary Organisations (NVCO).

1. Clone the NCVO
   [repo]([scripts](https://github.com/ncvo/charity-commission-extract).
1. Clone this repo.
1. Download the latest [zipped data
   dump](http://data.charitycommission.gov.uk/default.aspx) in to `/lists/zip`
   in this repo
1. Run the script

```sh
cd ./lists
python ../../charity-commission-extract/import.py ./zip/RegPlusExtract_October_2017.zip
```

[Field definitions](http://data.charitycommission.gov.uk/data-definition.aspx).
