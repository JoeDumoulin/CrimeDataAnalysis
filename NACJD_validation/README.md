Does the NACJD include Spokane data?
================
Rollie Parrish <rparrish@flightweb.com>
2016-08-29

The [National Archive of Criminal Justice Data](https://www.icpsr.umich.edu/icpsrweb/NACJD/NIBRS/) (NACJD) contains incident-level data files from the National Incident Based Reporting System (NIBRS) from 2010 to 2014. However, it is unknown whether or not data from Spokane is included in those files.

Getting the data
----------------

Downloading the public data files requires a free account on the NACJD website. The 'Terms of Use' specifies that the public data files may not be redistributed except in certain circumstances.

> Redistribution of Data
>
> You agree not to redistribute data or other materials without the written agreement of ICPSR, unless:
>
> You serve as the OFFICIAL or DESIGNATED REPRESENTATIVE at an ICPSR MEMBER INSTITUTION and are assisting AUTHORIZED USERS with obtaining data, or
>
> You are collaborating with other AUTHORIZED USERS to analyze the data for research or instructional purposes.
>
> When sharing data or other materials in these approved ways, you must include all accompanying files with the data, including terms of use. More information on permission to redistribute data can be found on the ICPSR Web site.

Although the intended use with the INRUG group qualifies with the terms of use, sharing the data via a publicly accessible GitHub repository does not. Therefore, the raw data files were saved to a `/Data` subfolder. That folder was added to main repository .gitignore file. This prevents the contents of `/Data` from being included in the git repository.

### Steps to Download data

#### NIBRS Data

1.  Logon to your NACJD account
2.  Go to <http://www.icpsr.umich.edu/icpsrweb/NACJD/studies/36398>
3.  Click the 'Quick Download' button (upper left corner) and select ASCII
4.  Agree to the Terms of Use
5.  Save the ICPSR\_36398I.zip file to `/Data` folder

#### Law Enforcement Agency Identity (LEAI) crosswalk files

1.  Go to <https://www.icpsr.umich.edu/icpsrweb/NACJD/series/366/studies/35158?paging.startRow=1>
2.  Click 'Excel/TSV' in the download section
3.  Save the ICPSR\_35158.zip file to the `/Data` folder

### Load data into R

``` r
# list the files in the incident zip archive
unzip("../Data/ICPSR_36398.zip", list = TRUE)
```

    ##                                             Name    Length
    ## 1                    ICPSR_36398/TermsOfUse.html      6870
    ## 2                 ICPSR_36398/36398-manifest.txt      6651
    ## 3      ICPSR_36398/36398-descriptioncitation.pdf    204660
    ## 4  ICPSR_36398/series-128-related_literature.txt     13232
    ## 5                 ICPSR_36398/36398-Codebook.pdf   1695768
    ## 6         ICPSR_36398/DS0001/36398-0001-Data.txt   6665624
    ## 7         ICPSR_36398/DS0002/36398-0002-Data.txt 314141310
    ## 8         ICPSR_36398/DS0003/36398-0003-Data.txt 395757479
    ## 9         ICPSR_36398/DS0004/36398-0004-Data.txt 648705478
    ## 10        ICPSR_36398/DS0005/36398-0005-Data.txt 776728247
    ## 11        ICPSR_36398/DS0006/36398-0006-Data.txt 250885404
    ## 12        ICPSR_36398/DS0007/36398-0007-Data.txt 128379174
    ## 13        ICPSR_36398/DS0008/36398-0008-Data.txt  95434440
    ## 14        ICPSR_36398/DS0009/36398-0009-Data.txt    313410
    ## 15        ICPSR_36398/DS0010/36398-0010-Data.txt    138040
    ## 16        ICPSR_36398/DS0011/36398-0011-Data.txt    832140
    ##                   Date
    ## 1  2016-08-30 00:33:00
    ## 2  2016-08-29 00:40:00
    ## 3  2016-08-02 11:36:00
    ## 4  2007-12-07 17:53:00
    ## 5  2016-03-17 18:02:00
    ## 6  2016-03-17 14:11:00
    ## 7  2016-03-17 14:11:00
    ## 8  2016-03-17 14:11:00
    ## 9  2016-03-17 14:12:00
    ## 10 2016-03-17 14:12:00
    ## 11 2016-03-17 14:13:00
    ## 12 2016-03-17 14:13:00
    ## 13 2016-03-17 14:13:00
    ## 14 2016-03-17 14:13:00
    ## 15 2016-03-17 14:13:00
    ## 16 2016-03-17 14:13:00

``` r
incident_filenames <- 
        c("ICPSR_36398/36398-Codebook.pdf",
          "ICPSR_36398/DS0001/36398-0001-Data.txt", 
          "ICPSR_36398/DS0002/36398-0002-Data.txt")

# list the files in the ORI (agency) zip archive
unzip("../Data/ICPSR_35158.zip", list = TRUE)
```

    ##                                         Name   Length                Date
    ## 1                ICPSR_35158/TermsOfUse.html     6870 2016-09-05 00:55:00
    ## 2             ICPSR_35158/35158-manifest.txt     1630 2016-09-05 00:44:00
    ## 3  ICPSR_35158/35158-descriptioncitation.pdf   195318 2015-04-17 12:05:00
    ## 4 ICPSR_35158/DS0001/35158-0001-Codebook.pdf   571485 2015-04-17 11:58:00
    ## 5     ICPSR_35158/DS0001/35158-0001-Data.tsv 11577775 2015-04-17 11:50:00

``` r
agency_filenames <- c("ICPSR_35158/DS0001/35158-0001-Data.tsv")
```

According to the 36398 Codebook, the agency info is in the Batch Header Segment (36398-0001-Data.txt) and incident info is in the Administrative Segment (36398-0002-Data.txt). However, to get the actual agency names, we'll need to join this data with the LEAI crosswalk data file. This will be enough to determine which agencies in Spokane County submit NIBRS incident-level data.

``` r
# agency data
unzip("../Data/ICPSR_35158.zip", files = agency_filenames)

agencies <- 
        read_tsv("ICPSR_35158/DS0001/35158-0001-Data.tsv") %>%
        mutate_each(funs(trimws))

# incident data
unzip("../Data/ICPSR_36398.zip", files = incident_filenames)

# attempt to determine column breaks automatically - didn't work
# header_cols <- fwf_empty("ICPSR_36398/DS0001/36398-0001-Data.txt")
# header <- read_fwf("ICPSR_36398/DS0001/36398-0001-Data.txt", header_cols)

# manually
header_cols <-
        fwf_positions(
                c(3,5,34,42,72,74,97,106,115,228,230), 
                c(4,13,41,71,73,75,97,114,117,229,233),
                c("state_code", "agency_id", "date_nibrs", "city", "state", "population_group", 
                  "nibrs_flag", "population", "county", "months_submitted", "year")
        )

header <- 
        read_fwf("ICPSR_36398/DS0001/36398-0001-Data.txt", header_cols)

admin_cols <- 
        fwf_positions(
                c(5,14,26),
                c(13,25,33),
                c("agency_id", "incident_number", "incident_date" )
                )

## this is a large file (299 MB with over 4 million rows)
admin <- 
        read_fwf("ICPSR_36398/DS0002/36398-0002-Data.txt", admin_cols)
```

    ## 
    |================================================================================| 100%  299 MB

``` r
## cleanup - remove the temp files
unlink(agency_filenames)
unlink(incident_filenames)
```

``` r
spokane_agencies <- 
        agencies %>%
        filter(COUNTYNAME == "SPOKANE") %>%
        select(ORI9, NAME, ADDRESS_CITY, ADDRESS_STATE)

spokane_header <-
        header %>%
        inner_join(spokane_agencies, by = c("agency_id" = "ORI9")) %>%
        select(agency_id, NAME, city, state, nibrs_flag, date_nibrs, population ) %>%
        arrange(desc(population))
```

The Agency, Batch Header Segment and Admin Segment files were extracted from .zip archives to temporary folders. The Agency file was read using `readr::read_tsv` and the Segment files were read into R using `readr::read_fsf()`. The Agency and Batch Header data sets were merged using the Originating Agency Identifier (ORI) field.

Results
-------

The largest and smallest agencies did not submit NIBRS data in 2014.

``` r
kable(spokane_header, format = "html", 
      caption = "NIBRS flag: A = Active, NA = Not Available")
```

<table>
<caption>
NIBRS flag: A = Active, NA = Not Available
</caption>
<thead>
<tr>
<th style="text-align:left;">
agency\_id
</th>
<th style="text-align:left;">
NAME
</th>
<th style="text-align:left;">
city
</th>
<th style="text-align:left;">
state
</th>
<th style="text-align:left;">
nibrs\_flag
</th>
<th style="text-align:right;">
date\_nibrs
</th>
<th style="text-align:right;">
population
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
WA0320400
</td>
<td style="text-align:left;">
SPOKANE POLICE DEPARTMENT
</td>
<td style="text-align:left;">
SPOKANE
</td>
<td style="text-align:left;">
WA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
211025
</td>
</tr>
<tr>
<td style="text-align:left;">
WA0320000
</td>
<td style="text-align:left;">
SPOKANE COUNTY SHERIFF'S OFFICE
</td>
<td style="text-align:left;">
SPOKANE
</td>
<td style="text-align:left;">
WA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
154651
</td>
</tr>
<tr>
<td style="text-align:left;">
WA0321500
</td>
<td style="text-align:left;">
SPOKANE VALLEY POLICE DEPARTMENT
</td>
<td style="text-align:left;">
SPOKANE VALLEY
</td>
<td style="text-align:left;">
WA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
91382
</td>
</tr>
<tr>
<td style="text-align:left;">
WA0320100
</td>
<td style="text-align:left;">
CHENEY POLICE DEPARTMENT
</td>
<td style="text-align:left;">
CHENEY
</td>
<td style="text-align:left;">
WA
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
20091001
</td>
<td style="text-align:right;">
11387
</td>
</tr>
<tr>
<td style="text-align:left;">
WA0321300
</td>
<td style="text-align:left;">
LIBERTY LAKE POLICE DEPARTMENT
</td>
<td style="text-align:left;">
LIBERTY LAKE
</td>
<td style="text-align:left;">
WA
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
20100601
</td>
<td style="text-align:right;">
8436
</td>
</tr>
<tr>
<td style="text-align:left;">
WA0320600
</td>
<td style="text-align:left;">
AIRWAY HEIGHTS POLICE DEPARTMENT
</td>
<td style="text-align:left;">
AIRWAY HEIGHTS
</td>
<td style="text-align:left;">
WA
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
20090601
</td>
<td style="text-align:right;">
6502
</td>
</tr>
<tr>
<td style="text-align:left;">
WA0320300
</td>
<td style="text-align:left;">
MEDICAL LAKE POLICE DEPARTMENT
</td>
<td style="text-align:left;">
MEDICAL LAKE
</td>
<td style="text-align:left;">
WA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
4886
</td>
</tr>
<tr>
<td style="text-align:left;">
WA0320200
</td>
<td style="text-align:left;">
DEER PARK PD
</td>
<td style="text-align:left;">
DEER PARK
</td>
<td style="text-align:left;">
WA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
3806
</td>
</tr>
<tr>
<td style="text-align:left;">
WA0320900
</td>
<td style="text-align:left;">
EASTERN WASHINGTON UNIVERSITY POLICE DEPARTMENT
</td>
<td style="text-align:left;">
EASTERN WASHINGTON UNIV
</td>
<td style="text-align:left;">
WA
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
20100401
</td>
<td style="text-align:right;">
0
</td>
</tr>
</tbody>
</table>
