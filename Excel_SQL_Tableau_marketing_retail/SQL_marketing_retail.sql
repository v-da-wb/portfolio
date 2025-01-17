/* Course 1 - Module 4 - Assignment Activity 4 */

-- Create marketing_data table
-- ----------------------------------------------

CREATE TABLE public.marketing_data(
	id 				BIGINT PRIMARY KEY,
	year_birth 		INT,
	age 			INT,
	country			CHAR(3),
	education 		VARCHAR(12),
	marital_s_new 	VARCHAR(10),
	income_new		NUMERIC(5,0),
	kidhome			NUMERIC(1),
	teenhome		NUMERIC(1),
	children		NUMERIC(1),
	date_cust_new	DATE, 
	recency			NUMERIC(2),
	sales			NUMERIC(6),
	amtliq			NUMERIC(6),
	amtvege			NUMERIC(6),
	amtnonveg		NUMERIC(6),
	amtpes			NUMERIC(6),
	amtchocolates	NUMERIC(6),
	amtcomm			NUMERIC(6),
	numdeals		INT, 
	numwebbuy		INT,
	numwalkinpur	INT, 
	numvisits		INT, 
	response		BOOLEAN, 
	complain		BOOLEAN, 
	count_success	INT
);

-- ALTER TABLE marketing_data 	ALTER COLUMN year_birth 	TYPE INT,
-- 							ALTER COLUMN age 			TYPE INT,
-- 							ALTER COLUMN date_cust_new 	TYPE DATE USING date_cust_new::CHAR(10)::DATE,
-- 							ALTER COLUMN response 		TYPE INT USING response::NUMERIC(1)::INT,
-- 							ALTER COLUMN complain 		TYPE INT USING complain::NUMERIC(1)::INT;

-- ALTER TABLE marketing_data 	ALTER COLUMN numdeals 		TYPE INT,
-- 							ALTER COLUMN numwebbuy 		TYPE INT,
-- 							ALTER COLUMN numwalkinpur 	TYPE INT,
-- 							ALTER COLUMN numvisits 		TYPE INT,
-- 							ALTER COLUMN count_success 	TYPE INT;

-- ALTER TABLE marketing_data 	ALTER COLUMN response 		TYPE BOOLEAN USING response::INT::BOOLEAN,
-- 							ALTER COLUMN complain 		TYPE BOOLEAN USING complain::INT::BOOLEAN;

SELECT * FROM public.marketing_data LIMIT 1;

-- ----------------------------------------------
-- import cleaned marketing_data_M4.csv with data

SELECT * FROM public.marketing_data;

-- ----------------------------------------------
-- check for critical omitted values:
select id, year_birth, age, country, income_new, sales
from public.marketing_data
	where 	id is null or
			year_birth is null or 
			age is null or
			country is null or
			income_new is null or
			sales is null
;

-- ----------------------------------------------
-- create ad_data table

CREATE TABLE public.ad_data(
	"ID" 				BIGINT PRIMARY KEY,
	"Bulkmail_ad" 		BOOLEAN,
	"Twitter_ad" 		BOOLEAN,
	"Instagram_ad"		BOOLEAN,
	"Facebook_ad" 		BOOLEAN,
	"Brochure_ad"		BOOLEAN
);

SELECT * FROM public.ad_data LIMIT 1;

ALTER TABLE ad_data 	RENAME COLUMN "ID" TO id;
ALTER TABLE ad_data 	RENAME COLUMN "Bulkmail_ad" TO bulkmail_ad;
ALTER TABLE ad_data 	RENAME COLUMN "Twitter_ad" TO twitter_ad;
ALTER TABLE ad_data 	RENAME COLUMN "Instagram_ad" TO instagram_ad;
ALTER TABLE ad_data 	RENAME COLUMN "Facebook_ad" TO facebook_ad;
ALTER TABLE ad_data 	RENAME COLUMN "Brochure_ad" TO brochure_ad;

-- ALTER TABLE ad_data 	ALTER COLUMN bulkmail_ad TYPE INT USING bulkmail_ad::NUMERIC(1)::INT,
-- 						ALTER COLUMN twitter_ad TYPE INT USING twitter_ad::NUMERIC(1)::INT,
-- 						ALTER COLUMN instagram_ad TYPE INT USING instagram_ad::NUMERIC(1)::INT,
-- 						ALTER COLUMN facebook_ad TYPE INT USING facebook_ad::NUMERIC(1)::INT,
-- 						ALTER COLUMN brochure_ad TYPE INT USING brochure_ad::NUMERIC(1)::INT;

-- ALTER TABLE ad_data 	ALTER COLUMN bulkmail_ad TYPE BOOLEAN USING bulkmail_ad::INT::BOOLEAN,
-- 						ALTER COLUMN twitter_ad TYPE BOOLEAN USING twitter_ad::INT::BOOLEAN,
-- 						ALTER COLUMN instagram_ad TYPE BOOLEAN USING instagram_ad::INT::BOOLEAN,
-- 						ALTER COLUMN facebook_ad TYPE BOOLEAN USING facebook_ad::INT::BOOLEAN,
-- 						ALTER COLUMN brochure_ad TYPE BOOLEAN USING brochure_ad::INT::BOOLEAN;


-- ----------------------------------------------
-- import ad_data.csv with data

SELECT * FROM public.ad_data;

-- ----------------------------------------------
-- Q1. the total spend per country (marketing_data)

SELECT country, SUM(sales) as total_sales
FROM public.marketing_data
GROUP BY country
ORDER BY total_sales DESC;

-- ----------------------------------------------
-- Q2. the total spend per product per country

SELECT country, 
	SUM(amtliq) as total_liq,
	SUM(amtnonveg) as total_meat,
	SUM(amtcomm) as total_comm,
	SUM(amtchocolates) as total_choco,
	SUM(amtvege) as total_veget,
	SUM(amtpes) as total_fish
FROM public.marketing_data
GROUP BY country
ORDER BY total_liq DESC;

-- ----------------------------------------------
-- Q3. which products are the most popular in each country

-- Answer. If there was a per unit prices of products by customer it would
-- be possible to assess which products are the most popular in each country.
-- Instead the data shows the most spent on products in each country - see
-- the output of the table for the previous question.

-- ----------------------------------------------
-- Q4. which products are the most popular based on marital status

SELECT marital_s_new, 
	SUM(amtliq) as total_liq,
	SUM(amtnonveg) as total_meat,
	SUM(amtcomm) as total_comm,
	SUM(amtchocolates) as total_choco,
	SUM(amtvege) as total_veget,
	SUM(amtpes) as total_fish
FROM public.marketing_data
GROUP BY marital_s_new
ORDER BY total_amtliq DESC;

-- ----------------------------------------------
-- Q5. which products are the most popular based on 
-- whether or not there are children or teens in the home.

SELECT children, 
	SUM(amtliq) as total_liq,
	SUM(amtnonveg) as total_meat,
	SUM(amtcomm) as total_comm,
	SUM(amtchocolates) as total_choco,
	SUM(amtvege) as total_veget,
	SUM(amtpes) as total_fish
FROM public.marketing_data
GROUP BY children
ORDER BY children ASC;

SELECT teenhome, 
	SUM(amtliq) as total_liq,
	SUM(amtnonveg) as total_meat,
	SUM(amtcomm) as total_comm,
	SUM(amtchocolates) as total_choco,
	SUM(amtvege) as total_veget,
	SUM(amtpes) as total_fish
FROM public.marketing_data
GROUP BY teenhome
ORDER BY teenhome DESC;


/***********************************************************************/
/* Course 1 - Module 5 - Assignment Activity 5 */

-- ----------------------------------------------
-- JOIN the two data sets:

SELECT COUNT(*) FROM public.marketing_data;
SELECT COUNT(*) FROM public.ad_data;

CREATE TABLE market_all AS
	SELECT *      
	FROM public.marketing_data
		LEFT JOIN public.ad_data
		USING (id);

SELECT CASE
	WHEN id 			IS NULL then 'NA' 
	WHEN year_birth 	IS NULL then 'NA' 
	WHEN age			IS NULL then 'NA' 
	WHEN country		IS NULL then 'NA'  
	WHEN income_new		IS NULL then 'NA' 
	WHEN sales			IS NULL then 'NA'
	ELSE 'no NULLs'
	END AS omitted_values_check
FROM public.market_all
GROUP BY omitted_values_check;

SELECT 	COUNT(id) 						as customers_count,
		AVG(age)::numeric(4,0) 			as avg_age,
		AVG(income_new)::numeric(4,0) 	as avg_income,
		AVG(children)::numeric(4,0) 	as avg_kids,
		AVG(sales)::numeric(4,0) 		as avg_spend,
		AVG(numwebbuy)::numeric(4,0) 	as avg_online_purchases,
		AVG(numwalkinpur)::numeric(4,0) as avg_walk_ins
FROM public.market_all
;

SELECT * FROM public.market_all;

-- ----------------------------------------------
-- Which social media platform (Twitter, 
-- Instagram, or Facebook) is the most effective 
-- method of advertising in each country?


SELECT 
	round((sum(count_success)/count(count_success)::decimal)*100,1) as prcnt_ads_success,
	
	(count(bulkmail_ad) filter (where bulkmail_ad = true)::decimal 
	/ count(count_success)*100)::numeric(3,1) as prcnt_bulk_sccss,
	
	(count(twitter_ad) filter (where twitter_ad = true)::decimal 
	/ count(count_success)*100)::numeric(3,1) as prcnt_twit_sccss,
	
	(count(instagram_ad) filter (where instagram_ad = true)::decimal 
	/ count(count_success)*100)::numeric(3,1) as prcnt_inst_sccss,
	
	(count(facebook_ad) filter (where facebook_ad = true)::decimal 
	/ count(count_success)*100)::numeric(3,1) as prcnt_face_sccss,
	
	(count(brochure_ad) filter (where brochure_ad = true)::decimal 
	/ count(count_success)*100)::numeric(3,1) as prcnt_bulk_sccss
	
FROM public.market_all
;

/* source: https://stackoverflow.com/a/79118919/21407272 */


-- select bulkmail_ad,
-- 	case	when bulkmail_ad = true then round((count(bulkmail_ad)/2216::decimal)*100,0)
-- 			when bulkmail_ad = false then round((count(bulkmail_ad)/2216::decimal)*100,0)
-- 	end
-- FROM public.market_all
-- GROUP BY bulkmail_ad
-- ;


-- Which social media platform is the most effective 
-- method of advertising based on marital status?

select distinct count(id)
from public.market_all
;

select  
	marital_s_new,
	
	(count(bulkmail_ad) filter (where bulkmail_ad = true)::decimal 
	/ 2216*100)::numeric(3,0) as prcnt_bulk_sccss,
	
	(count(twitter_ad) filter (where twitter_ad = true)::decimal 
	/ 2216*100)::numeric(3,0) as prcnt_twit_sccss,
	
	(count(instagram_ad) filter (where instagram_ad = true)::decimal 
	/ 2216*100)::numeric(3,0) as prcnt_inst_sccss,
	
	(count(facebook_ad) filter (where facebook_ad = true)::decimal 
	/2216*100)::numeric(3,0) as prcnt_face_sccss,
	
	(count(brochure_ad) filter (where brochure_ad = true)::decimal 
	/ 2216*100)::numeric(3,0) as prcnt_bulk_sccss
	
from public.market_all
group by marital_s_new
;

-- Which social media platform(s) seem(s) to be 
-- the most effective per country? 


-- low %rate of ads success suggests unequal access across customers,
-- thus analyse statistics among leads only
SELECT  
	-- country,
	-- marital_s_new,
	
	((SUM(sales) filter (where count_success > 0))::decimal
	/ SUM(sales)*100)::numeric(3,0) as t_pct_sales,
	-- COUNT(count_success) as total_ads,
	-- SUM(count_success) as sccss_ads,
	(SUM(count_success) filter (where count_success>0)::decimal
	/ count(count_success)*100)::numeric(3,1) as t_pct_ads,
	
	(count(bulkmail_ad) filter (where bulkmail_ad = true)::decimal 
	/ count(count_success)*100)::numeric(3,1) as pct_bulk,
	
	(count(twitter_ad) filter (where twitter_ad = true)::decimal 
	/ count(count_success)*100)::numeric(3,1) as pct_twit,
	
	(count(instagram_ad) filter (where instagram_ad = true)::decimal 
	/ count(count_success)*100)::numeric(3,1) as pct_inst,
	
	(count(facebook_ad) filter (where facebook_ad = true)::decimal 
	/ count(count_success)*100)::numeric(3,1) as pct_face,
	
	(count(brochure_ad) filter (where brochure_ad = true)::decimal 
	/ count(count_success)*100)::numeric(3,1) as pct_broch
	
FROM public.market_all
-- GROUP by country
-- GROUP by marital_s_new
-- ORDER by t_pct_sales DESC, t_pct_ads DESC
;

-- WRONG: duplicate sales get assigned to country/customer in case of 
-- purchases through multiple advertising channels:

SELECT

	((SUM(sales) filter (where count_success > 0))::decimal
	/ SUM(sales)*100)::numeric(3,0) as tsales_ads_sccss,

	((SUM(sales) filter (where bulkmail_ad = true))::decimal 
	/ SUM(sales)*100)::numeric(3,0) as prcnt_bulk_sccss,
	
	((SUM(sales) filter (where twitter_ad = true))::decimal 
	/ SUM(sales)*100)::numeric(3,0) as prcnt_twit_sccss,
	
	((SUM(sales) filter (where instagram_ad = true))::decimal 
	/ SUM(sales)*100)::numeric(3,0) as prcnt_inst_sccss,
	
	((SUM(sales) filter (where facebook_ad = true))::decimal 
	/ SUM(sales)*100)::numeric(3,0) as prcnt_face_sccss,
	
	((SUM(sales) filter (where brochure_ad = true))::decimal 
	/ SUM(sales)*100)::numeric(3,0) as prcnt_broch_sccss
	
FROM market_all
;

-- WRONG: duplicate sales get assigned to country/customer in case of 
-- purchases through multiple advertising channels:

SELECT

	(SUM(sales) filter (where count_success > 0))
	as tsales_ads_sccss,

	(SUM(sales) filter (where bulkmail_ad = true))
	as prcnt_bulk_sccss,
	
	(SUM(sales) filter (where twitter_ad = true))
	as prcnt_twit_sccss,
	
	(SUM(sales) filter (where instagram_ad = true))
	as prcnt_inst_sccss,
	
	(SUM(sales) filter (where facebook_ad = true))
	as prcnt_face_sccss,
	
	(SUM(sales) filter (where brochure_ad = true))
	as prcnt_broch_sccss
	
FROM market_all
;

-- customers responsiveness to ads:
SELECT
	-- country,
	-- marital_s_new,
	((SUM(sales) filter (where count_success > 0))::decimal
	/ SUM(sales)*100)::numeric(3,0) as t_pct_sales,
	-- COUNT(count_success) as total_ads,
	-- SUM(count_success) as sccss_ads,
	SUM(CASE WHEN count_success > 0 THEN count_success ELSE 0 END) as t_ads_s,
	(COUNT(bulkmail_ad) filter (where bulkmail_ad = true))::numeric as bulkmail,
	(COUNT(twitter_ad) filter (where twitter_ad = true))::numeric as twitter,
	(COUNT(instagram_ad) filter (where instagram_ad = true))::numeric as instagram,
	(COUNT(facebook_ad) filter (where facebook_ad = true))::numeric as facebook,
	(COUNT(brochure_ad) filter (where  brochure_ad = true))::numeric as brochure
	
FROM public.market_all
-- GROUP by country
-- GROUP by marital_s_new
-- ORDER by t_ads_s DESCAd
;

-- WRONG to compare products response to ads without knowledge of their unit price
-- and products quantities
-- Instead compare unit price of products with the ads dinamics:
SELECT
	country,
	-- marital_s_new,

	SUM(CASE WHEN count_success > 0 THEN count_success ELSE 0 END) as t_ads_s,
	
	(SUM(CASE WHEN count_success > 0 THEN sales ELSE 0 END)
	/SUM(CASE WHEN count_success > 0 THEN count_success ELSE 0 END))::numeric(6,0) as purch_price,
	
	(SUM(sales) filter (where count_success > 0)) as t_rev_ads,
	
	(SUM(CASE WHEN count_success > 0 THEN amtliq ELSE 0 END)
	/SUM(CASE WHEN count_success > 0 THEN count_success ELSE 0 END))::numeric(6,0) as p_liq,
	
	-- (SUM(CASE WHEN count_success > 0 THEN amtvege ELSE 0 END)
	-- /SUM(CASE WHEN count_success > 0 THEN count_success ELSE 0 END))::numeric(6,0) as p_veg,
	
	(SUM(CASE WHEN count_success > 0 THEN amtnonveg ELSE 0 END)
	/SUM(CASE WHEN count_success > 0 THEN count_success ELSE 0 END))::numeric(6,0) as p_meat,
	
	-- (SUM(CASE WHEN count_success > 0 THEN amtpes ELSE 0 END)
	-- /SUM(CASE WHEN count_success > 0 THEN count_success ELSE 0 END))::numeric(6,0) as p_fish,
	
	-- (SUM(CASE WHEN count_success > 0 THEN amtchocolates ELSE 0 END)
	-- /SUM(CASE WHEN count_success > 0 THEN count_success ELSE 0 END))::numeric(6,0) as p_choc,
	
	-- (SUM(CASE WHEN count_success > 0 THEN amtcomm ELSE 0 END)
	-- /SUM(CASE WHEN count_success > 0 THEN count_success ELSE 0 END))::numeric(6,0) as p_comm,

	(COUNT(bulkmail_ad) filter (where bulkmail_ad = true))::numeric as bulkmail,
	(COUNT(twitter_ad) filter (where twitter_ad = true))::numeric as twitter,
	(COUNT(instagram_ad) filter (where instagram_ad = true))::numeric as instagram,
	(COUNT(facebook_ad) filter (where facebook_ad = true))::numeric as facebook,
	(COUNT(brochure_ad) filter (where  brochure_ad = true))::numeric as brochure

FROM public.market_all
GROUP by country
-- GROUP by marital_s_new
ORDER by t_ads_s DESC
;

-- ------------------------ products preference -----------------------------------------------------
SELECT
	-- country,
	marital_s_new,
	SUM(sales) as t_rev,
	SUM(numwebbuy)+ SUM(numwalkinpur) as n_purchases,
	(SUM(sales) 		/	(SUM(numwebbuy)+SUM(numwalkinpur)))::numeric(6,0) as avg_price,
	(SUM(amtliq) 		/	(SUM(numwebbuy)+SUM(numwalkinpur)))::numeric(6,0) as p_liq,
	(SUM(amtvege) 		/	(SUM(numwebbuy)+SUM(numwalkinpur)))::numeric(6,0) as p_veg,
	(SUM(amtnonveg) 	/	(SUM(numwebbuy)+SUM(numwalkinpur)))::numeric(6,0) as p_meat,
	(SUM(amtpes) 		/	(SUM(numwebbuy)+SUM(numwalkinpur)))::numeric(6,0) as p_fish,
	(SUM(amtchocolates) / 	(SUM(numwebbuy)+SUM(numwalkinpur)))::numeric(6,0) as p_choc,
	(SUM(amtcomm) 		/	(SUM(numwebbuy)+SUM(numwalkinpur)))::numeric(6,0) as p_comm

FROM public.market_all
-- GROUP by country
GROUP by marital_s_new
ORDER by n_purchases DESC
;