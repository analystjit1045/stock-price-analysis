CREATE TABLE nifty_500 (
    "Company Name" VARCHAR(255),
    "Industry" VARCHAR(100),
    "Series" VARCHAR(10),
    "Open" DECIMAL(10, 2),
    "High" DECIMAL(10, 2),
    "Low" DECIMAL(10, 2),
    "Previous Close" DECIMAL(10, 2),
    "Last Traded Price" DECIMAL(10, 2),
    "Change" DECIMAL(10, 2),
    "Percentage Change" DECIMAL(5, 2),
    "Share Volume" INTEGER,
    "Value (Indian Rupee)" DECIMAL(14, 2),
    "52 Week High" DECIMAL(10, 2),
    "52 Week Low" DECIMAL(10, 2),
    "365 Day Percentage Change" DECIMAL(5, 2),
    "30 Day Percentage Change" DECIMAL(5, 2)
);    

copy nifty_500 ("Company Name","Industry","Series","Open","High","Low","Previous Close","Last Traded Price","Change",
"Percentage Change","Share Volume","Value (Indian Rupee)","52 Week High","52 Week Low","365 Day Percentage Change",
"30 Day Percentage Change")from 'D:\Program Files\pgAdmin 4\nifty_500.csv' delimiter ',' csv header ;

select * from nifty_500 ;  

--Q1) TOP 20 COMPANIES BY TRADING VALUE --
select "Company Name", "Value (Indian Rupee)" AS trading_value from nifty_500 ORDER BY "Value (Indian Rupee)" DESC LIMIT 20; 

--Q2) Top 20 Companies by Share Volume --
select "Company Name","Share Volume" from nifty_500 order by "Share Volume" desc limit 20 ; 

--Q3) Companies with Highest 365 Day Percentage Change --
select "Company Name", "365 Day Percentage Change" from  nifty_500 
order by "365 Day Percentage Change" desc
LIMIT 20;  

--Q4) Companies with Lowest 365 Day Percentage Change --
select  "Company Name", "365 Day Percentage Change"
FROM nifty_500 order by "365 Day Percentage Change" ASC LIMIT 10; 

--Q5) Average 30 Day Percentage Change by Industry --
Select  "Industry", AVG("30 Day Percentage Change") as Avg_30_Day_Change 
from nifty_500 Group by  "Industry" Order by  Avg_30_Day_Change DESC;

--Q6) Industry-wise Total Share Volume top 5 --
select  "Industry", sum("Share Volume") as Total_Share_Volume 
FROM nifty_500 
Group by  "Industry" 
Order by Total_Share_Volume DESC limit 5 ;

--Q7) Total Market Value for Each Company (Last Traded Price * Share Volume) --
Select  "Company Name",("Last Traded Price" * "Share Volume") as Market_Value 
from  nifty_500 
order by  Market_Value desc ; 

--Q8) Companies with a positive percentage change in both 30 Day and 365 Day --
Select  "Company Name","30 Day Percentage Change","365 Day Percentage Change"
From nifty_500 Where  "365 Day Percentage Change" > 0 AND "30 Day Percentage Change" > 0;

--Q9) Companies with closing price below Average--
select "Company Name","Last Traded Price" from nifty_500 where "Last Traded Price" < (select  AVG("Last Traded Price")
 from nifty_500) ; 

--Q10) Correlation Between 30 Day and 365 Day Percentage Change --
select  corr("30 Day Percentage Change", "365 Day Percentage Change") as Correlation
from nifty_500;

--Q11) Companies with the highest percentage change in the last trading session --
select "Company Name", "Percentage Change"
from nifty_500
order by "Percentage Change" desc limit 4 ;
     
--Q12) Companies with the highest 52-week range (difference between 52 Week High and 52 Week Low)--
select "Company Name", ("52 Week High" - "52 Week Low") AS price_range from nifty_500 order by  price_range desc limit  10;

--Q13) Companies with the most impactful difference between 365-day and 30-day percentage changes -- 
select  "Company Name","365 Day Percentage Change","30 Day Percentage Change",abs("365 Day Percentage Change" - "30 Day Percentage Change") as change_difference from  nifty_500
 order by  change_difference desc limit 10;       

--Q14) Companies trading close to their 52-week highs (within 5%)-- 
select "Company Name", "Last Traded Price", "52 Week High",(("52 Week High" - "Last Traded Price") / "52 Week High") * 100 AS percent_from_high
from nifty_500 where (("52 Week High" - "Last Traded Price") / "52 Week High") * 100 <= 5 order by percent_from_high ;

--Q15) Companies with the highest trading volume relative to their share price --
select "Company Name", "Share Volume", "Last Traded Price",
       "Share Volume" / "Last Traded Price" as volume_price_ratio
from  nifty_500 group by "Company Name","Share Volume", "Last Traded Price" 
order by  volume_price_ratio desc limit 10 ;

--Q16) Total trading value by industry --
select  "Industry", sum("Value (Indian Rupee)") as total_trading_value
from nifty_500 group by  "Industry" order by  total_trading_value desc; 

--Q17) Companies with the highest positive and negative % changes --
(select  "Company Name", "Percentage Change"
from nifty_500
order by  "Percentage Change" desc
LIMIT 5)
UNION ALL
(select  "Company Name", "Percentage Change" from nifty_500 ORDER BY "Percentage Change" asc LIMIT 5);

--Q18) Distribution of companies by price range --
select case when "Last Traded Price" < 100 then 'Under 100'  
     when "Last Traded Price" between  100 and 500 then  '100-500'
        when "Last Traded Price" between 501 and  1000 then  '501-1000'
        else  'Over 1000' END AS price_range,COUNT(*) AS company_count FROM nifty_500 group by  price_range O price_range ;

 
--Q19) Industries with the most companies in the Nifty 500 --
Select "Industry", count("Company Name") as company_count
from nifty_500 group by "Industry" order by company_count DESC; 


--Q20) Companies with the largest percentage difference between open and close prices --
select "Company Name", 
       (ABS("Last Traded Price" - "Open") / "Open") * 100 AS open_close_diff_percent
from  nifty_500
order by  open_close_diff_percent desc 
LIMIT 10;

--Q21) Average percentage change by series type--
select  "Series", AVG("Percentage Change") AS avg_percentage_change
FROM nifty_500 group by "Series" order by avg_percentage_change DESC;  

--Q22) Companies that hit their 52-week high or low in the last trading session --
SELECT "Company Name", case WHEN "High" = "52 Week High" THEN 'Hit 52 Week High' 
 WHEN "Low" = "52 Week Low" THEN 'Hit 52 Week Low' END AS milestone FROM nifty_500 WHERE "High" = "52 Week High" OR "Low" = "52 Week Low";    
           
--Q23) Top 10 companies by trading volume relative to their average price --
select "Company Name", "Share Volume" / (("High" + "Low") / 2) as volume_to_avg_price_ratio
from  nifty_500 order by  volume_to_avg_price_ratio desc limit  10;      

--Q24) Companies where the current price is closest to the average of their 52-week high and low--
select  "Company Name", "Last Traded Price",("52 Week High" + "52 Week Low") / 2 as  year_avg_price, abs("Last Traded Price" - (("52 Week High" + "52 Week Low") / 2)) as price_difference
from  nifty_500 order by  price_difference asc  limit 10 ;   
  




       











    


        









       











 



















