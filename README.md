DATA ANALYSIS PROJECT USING HADOOP/HIVE

INTERNAL TABLE : 

In your terminal, follow this commands
- hive
- create database deathAnalysis
- use deathAnalysis
- create table death_stats(name string,death_number int,country string,country_code string,year int) row format delimited fields terminated by ';' stored as textfile location '/user/cloudera/HiveDATA/' 
- create table country_continent(country string,code string,code2 string,iso string,continent string,continetnt_det string,region string,lat string,lon string,n string) row format delimited fields terminated by ',' stored as textfile location '/user/cloudera/countryDATA' 

2 CSV FILE : one is about the country and continents and an another is our main data of death by country

1 SQL FILE which contains all queries for the analysis.

1 PDF FILE which contains some screenshoots of graphics and queries in HIVE.


