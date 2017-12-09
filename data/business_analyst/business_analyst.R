require(rgdal)
ba_naics_pull_2016_shp <- readOGR(dsn = "business_analyst/BA_2016_DK/", layer = "BA_2016_DK")

"Health Care and Social Assistance
#https://www.naics.com/six-digit-naics/?code=62
**
624190 Other Individual and Family Services
621330 Offices of Mental Health Practitioners (except Physicians)
624230 Emergency and Other Relief Services
623220 Residential Mental Health and Substance Abuse Facilities
621498 All Other Outpatient Care Centers
621910 Ambulance Services
**
62 	Health Care and Social Assistance 	1,341,131
621111	Offices of Physicians (except Mental Health Specialists) 	363,320
621112	Offices of Physicians, Mental Health Specialists 	17,877
621210	Offices of Dentists 	171,246
621310	Offices of Chiropractors 	55,693
621320	Offices of Optometrists	25,141
621330	Offices of Mental Health Practitioners (except Physicians) 	28,630
621340	Offices of Physical, Occupational and Speech Therapists, and Audiologists 	30,555
621391	Offices of Podiatrists 	11,145
621399	Offices of All Other Miscellaneous Health Practitioners 	36,662
621410	Family Planning Centers 	4,403
621420	Outpatient Mental Health and Substance Abuse Centers 	8,583
621491	HMO Medical Centers 	1,158
621492	Kidney Dialysis Centers 	7,688
621493	Freestanding Ambulatory Surgical and Emergency Centers 	2,074
621498	All Other Outpatient Care Centers 	29,789
621511	Medical Laboratories 	12,733
621512	Diagnostic Imaging Centers 	1,531
621610	Home Health Care Services	38,266
621910	Ambulance Services 	5,934
621991	Blood and Organ Banks 	5,854
621999	All Other Miscellaneous Ambulatory Health Care Services 	112,514
622110	General Medical and Surgical Hospitals 	18,618
622210	Psychiatric and Substance Abuse Hospitals 	3,980
622310	Specialty (except Psychiatric and Substance Abuse) Hospitals 	3,145
623110	Nursing Care Facilities (Skilled Nursing Facilities) 	33,812
623210	Residential Intellectual and Developmental Disability Facilities 	2,064
623220	Residential Mental Health and Substance Abuse Facilities 	5,389
623311	Continuing Care Retirement Communities 	7,131
623312	Assisted Living Facilities for the Elderly 	5,585
623990	Other Residential Care Facilities 	16,661
624110	Child and Youth Services 	9,263
624120	Services for the Elderly and Persons with Disabilities 	17,376
624190	Other Individual and Family Services 	117,177
624210	Community Food Services 	1,017
624221	Temporary Shelters 	1,411
624229	Other Community Housing Services 	202
624230	Emergency and Other Relief Services 	3,056
624310	Vocational Rehabilitation Services 	12,396
624410	Child Day Care Services 	112,052"


#https://gis.stackexchange.com/questions/137621/join-spatial-point-data-to-polygons-in-r