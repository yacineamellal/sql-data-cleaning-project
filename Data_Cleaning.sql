-- Data Cleaning

select * from layoffs;


-- 1. Remove duplicates
-- 2. Standardize Data
-- 3. Null Values
-- 4. Remove any columns

create table layoffs_staging
like layoffs;

insert layoffs_staging 
select * from layoffs;

-- 1.
select * from layoffs;

select *,
row_number() over(
partition by company,industry,total_laid_off,percentage_laid_off,'date') as row_num
from layoffs_staging;

WITH duplicate_cte AS
(
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_staging 
)
select * from duplicate_cte
where row_num >1 ;




select * from layoffs_staging
where company='Casper';




WITH duplicate_cte AS
(
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_staging 
)
delete  from duplicate_cte
where row_num >1 ; -- we can not delete the data duplicated in this case 


-- we should create another table statement , inserting all the data , then deleting the duplicated 
-- but how did i now all the data duplicated , easy one we add a new column under name row_num how many rows has the same values using this request
-- we used also a CTE 'common table expression' it'z temporary result set 
-- Signification of CTEs : 
-- 1. Make queries easier to read
-- 2. You can use the same CTE multiple times in one query.
-- 3. Work like a “temporary table”

-- after inserting the number of duplicating rows , we store the result in another real table ,
-- the using the Update,Delete query to delete all the date that have row_num over then 1 

create table layoffs_staging2 (
	 company text,
     location text,
     industry text,
     total_laid_off  int default null,
     percentage_laid__off  text,
     date  text,
     stage  text,
     country  text,
     funds_raised_millions  int default null,
     row_num int
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

select * from layoffs_staging2 where row_num>1;
select * from layoffs_staging2
where row_num>1 ;

insert into layoffs_staging2
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_staging ;

delete from layoffs_staging2
where row_num >1;

select * from layoffs_staging2 where row_num >1 ;
-- to disable the safe mode , for the acces of deleting function , to activated  : set SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 0;

update layoffs_staging2 
set industry =null
where industry='';


-- Standardizing Data
-- def: finding issues in the data and then fixing them
-- Trim def: it takes off the white spice off the end 

select company , trim(company)
from layoffs_staging2;

update layoffs_staging2
set company=trim(company);

select *
from layoffs_staging2
where industry like 'Crypto%' ;

update layoffs_staging2
set industry='Crypto'
where industry like 'Crypto%';

select distinct industry from layoffs_staging2 ; 


-- def trailing : it means coming at the end so trailing '.' from a Data means coming from the end of the data and delete it as an example : two data are the same but one of them have an addition part by still the same  to remove the addition using trim and as function called trailing to come from the end 

select distinct country , trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

select distinct country from layoffs_staging2 ;


select date   from layoffs_staging2 ;

update layoffs_staging2
set date =STR_TO_DATE(date,'%m/%d/%Y');

alter table layoffs_staging2
modify column date date ;

select * from layoffs_staging2;



select * from layoffs_staging2
where company='Airbnb';

-- 3. Null Values

select t1.industry , t2.industry , t1.company, t2.company
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company=t2.company
where (t1.industry is null or t1.industry='')
and t2.industry is not null ;

update layoffs_staging2 t1 
join layoffs_staging2 t2
	on t1.company=t2.company
set t1.industry =t2.industry
where t1.industry is null 
and t2.industry is not null ;


select * from layoffs_staging2  where industry is NULL
or industry ='';

select * 
from layoffs_staging2
where total_laid_off is null
and percentage_laid__off is null ;

delete 
from layoffs_staging2
where total_laid_off is null
and percentage_laid__off is null ;

select * 
from layoffs_staging2 ; 

alter table layoffs_staging2 
drop column row_num ; 






































