"List of Tables

Table 1. Marijuana Use in the Past Year, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 2. Marijuana Use in the Past Month, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 3. First Use of Marijuana, by Age Group and State: Average Annual Numbers of Marijuana Initiates (Expressed as Numbers in Thousands of the At-Risk Population), Based on 2014 and 2015 NSDUHs

Table 4. Cocaine Use in the Past Year, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 5. Heroin Use in the Past Year, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 6. Alcohol Use in the Past Month, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 7. Alcohol Use in the Past Month among Individuals Aged 12 to 20, by State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 8. Tobacco Product Use in the Past Month, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 9. Cigarette Use in the Past Month, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 10. Alcohol Use Disorder in the Past Year, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 11. Alcohol Dependence in the Past Year, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 12. Serious Mental Illness in the Past Year, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 13. Any Mental Illness in the Past Year, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 14. Had Serious Thoughts of Suicide in the Past Year, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs

Table 15. Major Depressive Episode in the Past Year, by Age Group and State: Estimated Numbers (in Thousands), Annual Averages Based on 2014 and 2015 NSDUHs
"
load<-function(){
NSDUH.t1 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab01-2015.csv",skip = 5)
NSDUH.t2 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab02-2015.csv",skip = 5)
NSDUH.t3 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab03-2015.csv",skip = 6)
NSDUH.t4 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab04-2015.csv",skip = 5)
NSDUH.t5 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab05-2015.csv",skip = 5)
NSDUH.t6 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab06-2015.csv",skip = 5)
NSDUH.t7 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab07-2015.csv",skip = 5)
NSDUH.t8 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab08-2015.csv",skip = 6)
NSDUH.t9 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab09-2015.csv",skip = 5)
NSDUH.t10 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab10-2015.csv",skip = 6)
NSDUH.t11 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab11-2015.csv",skip = 6)
NSDUH.t12 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab12-2015.csv",skip = 6)
NSDUH.t13 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab13-2015.csv",skip = 6)
NSDUH.t14 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab14-2015.csv",skip = 6)
NSDUH.t15 <<- read_csv("data/health_behavior/SAMHSA/NSDUHsaeTotalsCSVs-2015/NSDUHsaeTotals-Tab15-2015.csv",skip = 7)
}
load()
