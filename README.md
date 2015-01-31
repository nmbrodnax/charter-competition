#Charter School Competition Study
##Data and Documentation

**NOTE:** This analysis and working paper are based on a replication of my original study using Bayesian techniques for use in a class project.  The models specified are not intended to estimate causal effects--they are demonstrations of the Bayesian techniques that I learned in the class, along with an outline for improvements.  The original analysis and paper, for which I used a fixed effects model, are not available in this repository.

**Abstract**: Over the past twenty years, charter schools have become an increasingly popular alternative to failing neighborhood schools.  Though they are publicly funded, charter schools are exempt from many of the state- and district-level policies governing structure, curriculum, personnel, and other aspects of learning.  Since the first charter school opened in 1992, over 4,000 charter schools have opened in forty states and the District of Columbia. Charter schools face a tall order: in exchange for public funding and increased autonomy, they are expected to improve achievement and create competition for neighborhood schools, the administrations of which must adapt or face sanctions.  This analysis explores the extent to which traditional public schools (TPSs) respond to competition from charter schools.  Using data from Illinois public schools, I test whether proximity to a charter school is associated with an increase in aggregate achievement at the school level.

##IL Schools Report Card Data
[All Report Card Data](http://www.isbe.net/assessment/report_card.htm) 
* [2009 Report Card Data](http://www.isbe.net/research/zip/2009_rc_separated.zip)
* [2011 Report Card Data](http://www.isbe.net/assessment/zip/2012_rc_separated.zip) 
* **Filenames**: rc09p1.txt, rc09p10.txt, pc09p25.txt, rc11p1.txt, rc11p11.txt, rc11p26.txt

##IL Schools Location Data
[NCES Data](http://nces.ed.gov/ccd/elsi/tableGenerator.aspx) (Table #11220)
* **Fields**: School Name, State Name [Public School] Latest available year, Charter School [Public School] 2011-12, Magnet School [Public School] 2011-12, Latitude [Public School] 2011-12, Longitude [Public School] 2011-12, State School ID [Public School] 2011-12, State Agency ID [Public School] 2011-12, Congressional Code [Public School] 2011-12, Grade 4 offered [Public School] 2011-12, County Name [Public School] 2011-12
* **Filenames**: common2.csv

##Charter School Data
[Illinois Charter School Documentation](http://www.isbe.net/charter/?col5=open#CollapsiblePanel5)
* [Charter School Location Info](https://www.incschools.org/member-schools/find-a-charter-school/)
  * [GPS Data](http://www.gpsvisualizer.com/geocoder/)
  * [Bing Maps API](https://www.bingmapsportal.com)
* **Filename**: charter.dat

##Analysis
* **R Scripts**: 1a_clean data_2009.R creates prior.da;, 1a_clean_data_2011 creates data.dat and charter.dat; 2_merge_data.R creates compete.dat; 3_bayesian_regression.R performs analysis on compete.dat; 4_bayesian_hierarchical.R performs analysis on compete.dat; and 5_map_ilschools.R creates a map of schools in Illinois.
* **Priors**: IL score distribution on NAEP retrieved from http://nces.ed.gov/nationsreportcard/states/
  * Files downloaded: [NAEP Snapshot Illinois Math](http://nces.ed.gov/nationsreportcard/subject/publications/stt2013/pdf/2014465IL4.pdf) and [NAEP Snapshot Illinois Reading](http://nces.ed.gov/nationsreportcard/subject/publications/stt2013/pdf/2014464IL4.pdf)

##Definitions
* Math Achievement: [Basic, Proficient, and Advanced Math](http://nces.ed.gov/nationsreportcard/mathematics/achieveall.asp)
* Reading Achievement: [Basic, Proficient, and Advanced Reading](http://nces.ed.gov/nationsreportcard/reading/achieveall.asp#2009_grade4)


