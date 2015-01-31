#Charter School Competition Study
##Data Sources and Documentation

**Last Modified**: January 28, 2015

*Abstract*: Over the past twenty years, charter schools have become an increasingly popular alternative to failing neighborhood schools.  Though they are publicly funded, charter schools are exempt from many of the state- and district-level policies governing structure, curriculum, personnel, and other aspects of learning.  Since the first charter school opened in 1992, over 4,000 charter schools have opened in forty states and the District of Columbia. Charter schools face a tall order: in exchange for public funding and increased autonomy, they are expected to improve achievement and create competition for neighborhood schools, the administrations of which must adapt or face sanctions.  This analysis explores the extent to which traditional public schools (TPSs) respond to competition from charter schools.  Using data from Illinois public schools, I test whether proximity to a charter school is associated with an increase in aggregate achievement at the school level.

##IL Schools Report Card Data
[All Report Card Data](http://www.isbe.net/assessment/report_card.htm) 
* [2009 Report Card Data](http://www.isbe.net/research/zip/2009_rc_separated.zip)
* [2011 Report Card Data](http://www.isbe.net/assessment/zip/2012_rc_separated.zip) 
* Filenames from segmented files: rc09p1.txt, rc09p10.txt, pc09p25.txt, rc11p1.txt, rc11p11.txt, rc11p26.txt

##IL Schools Location Data
*Data: http://nces.ed.gov/ccd/elsi/tableGenerator.aspx (Table #11220)
Fields: School Name, State Name [Public School] Latest available year, Charter School [Public School] 2011-12, Magnet School [Public School] 2011-12, Latitude [Public School] 2011-12, Longitude [Public School] 2011-12, State School ID [Public School] 2011-12, State Agency ID [Public School] 2011-12, Congressional Code [Public School] 2011-12, Grade 4 offered [Public School] 2011-12, County Name [Public School] 2011-12
Filenames: common2.zip, common2.csv, common2.xlsx

##Charter School Data
Documentation: http://www.isbe.net/charter/?col5=open#CollapsiblePanel5
Info: https://www.incschools.org/member-schools/find-a-charter-school/
Data entered manually into filenames: charterkeys.xlsx, charterinfo.csv
GPS Data: http://www.gpsvisualizer.com/geocoder/
Bing Maps API Key: https://www.bingmapsportal.com
Data pasted manually into filename: chartergps.csv

##Analysis
R Script: 1_S626_Final_Import.R creates data.dat and charter.dat; 2_S626_Final_Data.R creates compete.dat; 3_S626_Final_Analysis performs analysis on compete2.dat; 3_S626_Final_Map.R creates a map of schools in Illinois; 4_S626_Final_Hierarchical.R performs analysis on compete3.dat;
Priors: IL score distribution on NAEP retrieved from http://nces.ed.gov/nationsreportcard/states/
Files downloaded: NAEP Snapshot IL Math.pdf http://nces.ed.gov/nationsreportcard/subject/publications/stt2013/pdf/2014465IL4.pdf and NAEP Snapshot IL Reading.pdf http://nces.ed.gov/nationsreportcard/subject/publications/stt2013/pdf/2014464IL4.pdf

##Definitions
Basic, Proficient, and Advanced Math: http://nces.ed.gov/nationsreportcard/mathematics/achieveall.asp
Basic, Proficient, and Advanced Reading: http://nces.ed.gov/nationsreportcard/reading/achieveall.asp#2009_grade4


