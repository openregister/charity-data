# Data for a register of charities

Data for [registers](registers.cloudapps.digital/registers) of charities in the
UK.

#### Charity-eng and charity-wls

The Charities Commission provides monthly [zipped data
dumps](http://data.charitycommission.gov.uk/default.aspx) for England and Wales,
It can be converted from the MS SQL Server bcp format into TSV with the
following steps.

1. Download the latest [zipped data
   dump](http://data.charitycommission.gov.uk/default.aspx) in to `/lists/zip`
   in this repo
2. Run the following commands from the root of this repo.

```sh
unzip -o lists/zip/RegPlusExtract_March_2018.zip -d lists
perl -0777 -i.bak -pe 's/\r\n/\\n/gs' lists/*.bcp
perl -0777 -i.bak -pe 's/\n/\\n/gs' lists/*.bcp
perl -0777 -i.bak -pe 's/\r/\\n/gs' lists/*.bcp
sed -i.bak 's/\t/\\t/g' lists/*.bcp
sed -i.bak 's/&#x0D;//g' lists/*.bcp
sed -i.bak 's/@\*\*@/\t/g' lists/*.bcp
sed -i.bak 's/\*@@\*/\n/g' lists/*.bcp
sed -i.bak 's/\x0//g' lists/*.bcp
rm lists/*.bak
```

[Field definitions](http://data.charitycommission.gov.uk/data-definition.aspx).

#### Charity-sct

[charity-sct](https://www.oscr.org.uk/charities/search-scottish-charity-register/charity-register-download)

#### Charity-nir

[charity-nir](http://www.charitycommissionni.org.uk/charity-search/))
