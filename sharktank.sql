select * from sharktank

truncate  table sharktank

LOAD DATA INFILE "E:/CampusX/sharktank.csv"
INTO TABLE sharktank
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


select * from sharktank


-- 1 You Team have to  promote shark Tank India  season 4, The senior come up with the idea to show highest funding domain wise  and you were assigned the task to  show the same.
	select * from
	(
	select   industry ,total_deal_amount_in_lakhs,row_number() over(partition by industry order by  total_deal_amount_in_lakhs desc) as rnk from sharktank
	) t where rnk=1





-- 2 You have been assigned the role of finding the domain where female as pitchers have female to male pitcher ratio >70%
select * ,(female/Male)*100 as ratio from
(
select Industry, sum(female_presenters) as 'Female', sum(male_presenters) as 'Male' from sharktank group by Industry having sum(female_presenters)>0  and sum(male_presenters)>0
)m where (female/Male)*100>70




-- 3 You are working at marketing firm of Shark Tank India, you have got the task to determine volume of per year sale pitch made, pitches who received 
-- offer and pitches that were converted. Also show the percentage of pitches converted and percentage of pitches received.
select k.season_number , k.total_pitches , m.pitches_received, ((pitches_received/total_pitches)*100) as 'percentage  pitches received', l.pitches_converted 
,((pitches_converted/pitches_received)*100) as 'Percentage pitches converted' 
 from
(
		(
		select season_number , count(startup_Name) as 'Total_pitches' from sharktank group by season_number
		)k 
		inner join
		(
		select season_number , count(startup_name) as 'Pitches_Received' from sharktank where received_offer='yes' group by season_number
		)m on k.season_number= m.season_number
		inner join
		(
		select season_number , count(Accepted_offer) as 'Pitches_Converted' from sharktank where  Accepted_offer='Yes' group by  season_number 
		)l on m.season_number= l.season_number
)



-- 4 As a venture capital firm specializing in investing in startups featured on a renowned entrepreneurship TV show, how would you determine the season with the
-- highest average monthly sales and identify the top 5 industries with the highest average monthly sales during that season to optimize investment decisions?
select * from sharktank

set @seas= (select season_number  from
(
select  season_number , round(avg(monthly_sales_in_lakhs),2)as 'average' from sharktank where monthly_sales_in_lakhs!= 'Not_mentioned'
 group by season_number  
 )k order by average desc
 limit 1);
select @seas

select industry , round(avg(monthly_sales_in_lakhs),2) as average from  sharktank where season_number = @seas and monthly_sales_in_lakhs!= 'Not_mentioned'
group by industry
order by average desc
limit 5




-- 5.As a data scientist at our firm, your role involves solving real-world challenges like identifying industries with consistent increases in funds raised over 
-- multiple seasons. This requires focusing on industries where data is available across all three years.
--  Once these industries are pinpointed, your task is to delve into the specifics, analyzing the number of pitches made, offers received, and offers 
-- converted per season within each industry.



select industry ,season_number , sum(total_deal_amount_in_lakhs) from sharktank group by industry ,season_number -- step 1

WITH ValidIndustries AS (
    SELECT 
        industry, 
        MAX(CASE WHEN season_number = 1 THEN total_deal_amount_in_lakhs END) AS season_1,
        MAX(CASE WHEN season_number = 2 THEN total_deal_amount_in_lakhs END) AS season_2,
        MAX(CASE WHEN season_number = 3 THEN total_deal_amount_in_lakhs END) AS season_3
    FROM sharktank 
    GROUP BY industry 
    HAVING season_3 > season_2 AND season_2 > season_1 AND season_1 != 0
)  -- step 2 
-- select * from validindustries


select * from sharktank as t  inner join validindustries as v on t.industry= v.industry-- step 3


SELECT 
    t.season_number,
    t.industry,
    COUNT(t.startup_Name) AS Total,
    COUNT(CASE WHEN t.received_offer = 'Yes' THEN t.startup_Name END) AS Received,
    COUNT(CASE WHEN t.accepted_offer = 'Yes' THEN t.startup_Name END) AS Accepted
FROM sharktank AS t
JOIN ValidIndustries AS v ON t.industry = v.industry
GROUP BY t.season_number, t.industry;   -- step 4





-- 6. Every shark want to  know in how much year their investment will be returned, so you have to create a system for them , where shark will enter the name of the 
-- startup's  and the based on the total deal and quity given in how many years their principal amount will be returned.

delimiter //
create procedure TOT( in startup varchar(100))
begin
   case 
      when (select Accepted_offer ='No' from sharktank where startup_name = startup)
	        then  select 'Turn Over time cannot be calculated';
	 when (select Accepted_offer ='yes' and Yearly_Revenue_in_lakhs = 'Not Mentioned' from sharktank where startup_name= startup)
           then select 'Previous data is not available';
	 else
         select `startup_name`,`Yearly_Revenue_in_lakhs`,`Total_Deal_Amount_in_lakhs`,`Total_Deal_Equity_%`, 
         `Total_Deal_Amount_in_lakhs`/((`Total_Deal_Equity_%`/100)*`Total_Deal_Amount_in_lakhs`) as 'years'
		 from sharktank where Startup_Name= startup;
	
    end case;
end
//
DELIMITER ;


call tot('BluePineFoods')






-- 7. In the world of startup investing, we're curious to know which big-name investor, often referred to as "sharks," tends to put the most money into each
-- deal on average. This comparison helps us see who's the most generous with their investments and how they measure up against their fellow investors.

select sharkname, round(avg(investment),2)  as 'average' from
(
SELECT `Namita_Investment_Amount_in lakhs_` AS investment, 'Namita' AS sharkname FROM sharktank WHERE `Namita_Investment_Amount_in lakhs_` > 0
union all
SELECT `Vineeta_Investment_Amounti_n_lakhs` AS investment, 'Vineeta' AS sharkname FROM sharktank WHERE `Vineeta_Investment_Amounti_n_lakhs` > 0
union all
SELECT `Anupam_Investment_Amount_in_lakhs` AS investment, 'Anupam' AS sharkname FROM sharktank WHERE `Anupam_Investment_Amount_in_lakhs` > 0
union all
SELECT `Aman_Investment_Amount_in_lakhs_` AS investment, 'Aman' AS sharkname FROM sharktank WHERE `Aman_Investment_Amount_in_lakhs_` > 0
union all
SELECT `Peyush_Investment_Amount_in_lakhs` AS investment, 'peyush' AS sharkname FROM sharktank WHERE `Peyush_Investment_Amount_in_lakhs` > 0
union all
SELECT `Amit_Investment_Amount_in_lakhs` AS investment, 'Amit' AS sharkname FROM sharktank WHERE `Amit_Investment_Amount_in_lakhs` > 0
union all
SELECT `Ashneer_Investment_Amount_in_lakhs` AS investment, 'Ashneer' AS sharkname FROM sharktank WHERE `Ashneer_Investment_Amount_in_lakhs` > 0
)k group by sharkname


select * from sharktank









-- 8. Develop a system that accepts inputs for the season number and the name of a shark. The procedure will then provide detailed insights into the total investment made by 
-- that specific shark across different industries during the specified season. Additionally, it will calculate the percentage of their investment in each sector relative to
-- the total investment in that year, giving a comprehensive understanding of the shark's investment distribution and impact.
select * from sharktank

DELIMITER //
create PROCEDURE getseasoninvestment(IN season INT, IN sharkname VARCHAR(100))
BEGIN
      
    CASE 

        WHEN sharkname = 'namita' THEN
            set @total = (select  sum(`Namita_Investment_Amount_in lakhs_`) from sharktank where Season_Number= season );
            SELECT Industry, sum(`Namita_Investment_Amount_in lakhs_`) as 'sum' ,(sum(`Namita_Investment_Amount_in lakhs_`)/@total)*100 as 'Percent' FROM sharktank WHERE season_Number = season AND `Namita_Investment_Amount_in lakhs_` > 0
            group by industry;
        WHEN sharkname = 'Vineeta' THEN
            SELECT industry,sum(`Vineeta_Investment_Amounti_n_lakhs`) as 'sum' FROM sharktank WHERE season_Number = season AND `Vineeta_Investment_Amounti_n_lakhs` > 0
            group by industry;
        WHEN sharkname = 'Anupam' THEN
            SELECT industry,sum(`Anupam_Investment_Amount_in_lakhs`) as 'sum' FROM sharktank WHERE season_Number = season AND `Anupam_Investment_Amount_in_lakhs` > 0
            group by Industry;
        WHEN sharkname = 'Aman' THEN
            SELECT industry,sum(`Aman_Investment_Amount_in_lakhs_`) as 'sum'  FROM sharktank WHERE season_Number = season AND `Aman_Investment_Amount_in_lakhs_` > 0
             group by Industry;
        WHEN sharkname = 'Peyush' THEN
             SELECT industry,sum(`Peyush_Investment_Amount_in_lakhs`) as 'sum'  FROM sharktank WHERE season_Number = season AND `Peyush_Investment_Amount_in_lakhs` > 0
             group by Industry;
        WHEN sharkname = 'Amit' THEN
              SELECT industry,sum(`Amit_Investment_Amount_in_lakhs`) as 'sum'   WHERE season_Number = season AND `Amit_Investment_Amount_in_lakhs` > 0
             group by Industry;
        WHEN sharkname = 'Ashneer' THEN
            SELECT industry,sum(`Ashneer_Investment_Amount_in_lakhs`)  FROM sharktank WHERE season_Number = season AND `Ashneer_Investment_Amount_in_lakhs` > 0
             group by Industry;
        ELSE
            SELECT 'Invalid shark name';
    END CASE;
    
END //
DELIMITER ;


drop procedure getseasoninvestment
call getseasoninvestment(2, 'Namita')

 set @total = (select  sum(Total_Deal_Amount_in_lakhs) from sharktank where Season_Number= 1 );
select @total
-- step 1  -- simple procedure to show output , 
-- step 2 -- industry specific 
-- step 3 -- give output 
-- step 4 -- with total








-- 9. In the realm of venture capital, we're exploring which shark possesses the most diversified investment portfolio across various industries. 
-- By examining their investment patterns and preferences, we aim to uncover any discernible trends or strategies that may shed light on their decision-making
-- processes and investment philosophies.

select sharkname, 
count(distinct industry) as 'unique industy',
count(distinct concat(pitchers_city,' ,', pitchers_state)) as 'unique locations' from 
(
		SELECT Industry, Pitchers_City, Pitchers_State, 'Namita'  as sharkname from sharktank where  `Namita_Investment_Amount_in lakhs_` > 0
		union all
		SELECT Industry, Pitchers_City, Pitchers_State, 'Vineeta'  as sharkname from sharktank where `Vineeta_Investment_Amounti_n_lakhs` > 0
		union all
		SELECT Industry, Pitchers_City, Pitchers_State, 'Anupam'  as sharkname from sharktank where  `Anupam_Investment_Amount_in_lakhs` > 0 
		union all
		SELECT Industry, Pitchers_City, Pitchers_State, 'Aman'  as sharkname from sharktank where `Aman_Investment_Amount_in_lakhs_` > 0
		union all
		SELECT Industry, Pitchers_City, Pitchers_State, 'Peyush'  as sharkname from sharktank where   `Peyush_Investment_Amount_in_lakhs` > 0
		union all
		SELECT Industry, Pitchers_City, Pitchers_State, 'Amit'  as sharkname from sharktank where `Amit_Investment_Amount_in_lakhs` > 0
		union all
		SELECT Industry, Pitchers_City, Pitchers_State, 'Anupam'  as sharkname from sharktank where  `Anupam_Investment_Amount_in_lakhs` > 0 
		union all
		SELECT Industry, Pitchers_City, Pitchers_State, 'Ashneer'  as sharkname from sharktank where `Ashneer_Investment_Amount_in_lakhs` > 0
)t  
group by sharkname 
order by  'unique industry' desc ,'unique location' desc

-- 10.Explain the concept of indexes in MySQL. How do indexes improve query performance, and what factors should be considered when deciding which columns to index in a database table

-- https://dev.mysql.com/doc/refman/8.0/en/mysql-indexes.html


