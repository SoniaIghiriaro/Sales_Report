-- Database is on students performance on exam day. the analysis is to know the motivation behind students performance on exam day;
--on the basis of parental level of education, food, ethnicity,and test preparation courses

---Step one: Create Database
create database Genuis;
use Genuis;
select * from StudentsPerformance;

--Step two: streamlining to proposed motivation areas
select upper(trim(race_ethnicity)) as Ethnicity,
count(*) as Count_of_Ethnicity
from StudentsPerformance
Group By upper(trim(race_ethnicity))

select race_ethnicity, Avg(math_score) as Average_Math_Score
from StudentsPerformance
where race_ethnicity is not NULL
Group By race_ethnicity

--Streamlining to Parental level of education
select parental_level_of_education, Avg(math_score) as Average_Math_Score
from StudentsPerformance
where parental_level_of_education is not NULL
Group By parental_level_of_education

--Streamlining to test preparation course
select test_preparation_course, Avg(math_score) as Average_Math_Score
from StudentsPerformance
where test_preparation_course is not NULL
Group By test_preparation_course

--streamlining to categories of food 
select lunch, Avg(math_score) as Average_Math_Score
from StudentsPerformance
where lunch is not NULL
Group By lunch

--Streamlining to gender
select gender, Avg(math_score) as Average_Math_Score
from StudentsPerformance
where gender is not NULL
Group By gender

---Partition
select gender,race_ethnicity,parental_level_of_education,
Avg(math_score) over(partition by parental_level_of_education) as Average_Math_Score
from StudentsPerformance

--Step three: Ranking performance
select gender,race_ethnicity,parental_level_of_education,test_preparation_course,lunch,reading_score,
Dense_Rank()over(partition by parental_level_of_education order by reading_score) as Reading_Rank
from StudentsPerformance

select gender,race_ethnicity,parental_level_of_education,test_preparation_course,lunch,writing_score,
Dense_Rank()over(partition by parental_level_of_education order by writing_score) as Writing_Rank
from StudentsPerformance

select count(math_score) as distinction_in_math
from StudentsPerformance
where math_score>70;

select test_preparation_course, Avg(math_score) as Average_Math_Score
from StudentsPerformance
Group By test_preparation_course; 

select test_preparation_course, Avg(reading_score) as Average_Reading_Score
from StudentsPerformance
Group By test_preparation_course; 

select test_preparation_course, Avg(writing_score) as Average_Writing_Score
from StudentsPerformance
Group By test_preparation_course; 

--Lead
select gender,lunch,test_preparation_course,math_score,
lead(math_score, 1) over(partition by test_preparation_course order by math_score) as Cummulated_Math_Score
from StudentsPerformance

--lag
select gender,lunch,test_preparation_course,math_score,
lag(math_score, 1) over(partition by test_preparation_course order by math_score) as Math_Score_Previous,
math_score - lag(math_score, 1) over(partition by test_preparation_course order by math_score) as Math_Score_Diff
from StudentsPerformance;

--views
create view Maths_Performance AS
select parental_level_of_education,lunch,test_preparation_course,math_score
from studentsperformance;
select * from Maths_Performance

CREATE VIEW Performance_in_Reading AS 
select parental_level_of_education,lunch,test_preparation_course,reading_score
from studentsperformance;
select * from Performance_in_Reading

create view Writing_Performance AS
select parental_level_of_education,lunch,test_preparation_course,writing_score
from studentsperformance;
select * from Writing_Performance

SELECT * FROM StudentsPerformance
WHERE parental_level_of_education = 'high school';

SELECT COUNT(parental_level_of_education) as Level_of_Education
FROM studentsperformance
WHERE math_score>70 'parental_level_of_education';

Select * from studentsperformance
ORDER BY parental_level_of_education DESC;



select gender,race_ethnicity,parental_level_of_education,test_preparation_course,lunch,reading_score,
Dense_Rank()over(partition by parental_level_of_education order by reading_score) as Reading_Rank
from StudentsPerformance
where reading_score >70 and reading_score <99
order by Reading_rank
