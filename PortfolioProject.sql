/*
Abdur Rob

COVID-19 Data Exploration

Skills Used: JOINS, CTE, TEMP TABLES, WINDOWS FUNCTIONS, AGGREGATE FUNCTIONS, CONVERTING DATA TYPES

Data: The dataset is from https://ourworldindata.org/covid-deaths. It has data from January 2020 to  April 2021. 
I manipulated the data in Excel to contain the columns I wanted to work with.

Task: The goal of this project is to explore 2020-2021 COVID-19 Data by asking and answering data exploration questions. 
I choose to look at insights for Bangladesh since I am a Bangladeshi citizen. I also explored data globally and regionally.

*/

USE PortfolioProject;

/* VIEWING THE DATASETS */

-- Covid Deaths Data
SELECT 
	* 
FROM 
	
	PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY date,population

-- Covid Vaccinations Data
SELECT 
	* 
FROM 
	PortfolioProject..covidvaccinations
WHERE 
	continent IS NOT NULL
ORDER BY date,population


/* 
								DATA EXPLORATION - COVID DEATHS DATA
*/

/* How many COVID-19 cases in Bangladesh in July 2023? How many deaths? What is the percentage of death ? */
-- This shows the likelihood of dying in Bangladesh if you contract COVID-19 in July 2023.



SELECT 
    location, 
    date,
    CAST(total_cases AS INT) AS total_cases,
    CAST(total_deaths AS INT) AS total_deaths,
    (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS PercentOfDeath
FROM 
    Portfolioproject..CovidDeaths
WHERE 
    location LIKE '%Bangladesh%' AND date = '2023-07-15 00:00:00.000'
ORDER BY date;

/*As of July 15, 2023, there are 2,043,485 total cases and the death percentage is about 1.44%. 
This means that 2,043,485 people have been infected by COVID-19 since Jan 2020 and that there is about a 1.44 chance of dying if you contract COVID-19 while living in the Bangladesh.*/

-- How does this compare to a year ago, two years ago and 3 years ago?

SELECT 
    location, 
    date,
    CAST(total_cases AS INT) AS total_cases,
    CAST(total_deaths AS INT) AS total_deaths,
    (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS PercentOfDeath
FROM 
    Portfolioproject..CovidDeaths
WHERE 
    location LIKE '%Bangladesh%' AND date = '2022-07-15 00:00:00.000'
ORDER BY date;

SELECT 
    location, 
    date,
    CAST(total_cases AS INT) AS total_cases,
    CAST(total_deaths AS INT) AS total_deaths,
    (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS PercentOfDeath
FROM 
    Portfolioproject..CovidDeaths
WHERE 
    location LIKE '%Bangladesh%' AND date = '2021-04-30 00:00:00.000'
ORDER BY date;

SELECT 
    location, 
    date,
    CAST(total_cases AS INT) AS total_cases,
    CAST(total_deaths AS INT) AS total_deaths,
    (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS PercentOfDeath
FROM 
    Portfolioproject..CovidDeaths
WHERE 
    location LIKE '%Bangladesh%' AND date = '2020-07-30 00:00:00.000'
ORDER BY date;





-- One year ago in 2022, 1,994,433 people were infected with COVID-19 and there was a 1.46% chance of dying upon contraction.




/* What percentage of the Bangladesh population contracted COVID-19? */
-- This shows what percentage of the Bangladeshi population was infected with COVID-19
SELECT 
	
	location, 
	population,
	date,
	total_cases, 
	total_deaths, 
	(total_deaths/population)*100 AS percent_population_infected
FROM 
	PortfolioProject..Coviddeaths
WHERE 
	location LIKE '%Bangla%' AND date = '2023-07-15 00:00:00.000'
ORDER BY date 

-- Of 171,186,368 people only 0.017% of the Bangladesh population contracted COVID-19 as of July 15, 2023



/* Which countries have the highest infections rate? 

Showing countries with highest infection rate compared to their population and Where does Bangldesh Fall */
SELECT
	location,
	continent,
	population, 
	MAX(total_cases) AS highest_infection_count, 
	MAX((total_cases/population))*100 AS percent_population_infected
FROM 
	PortfolioProject..coviddeaths
GROUP BY location, continent, population
ORDER BY percent_population_infected DESC

--The country with the highest infection rate is Cyprus.The San Marino, Brunei, Austria are among the top 5 countires after Cyprus. Bangladesh position is 194th.


SELECT 
	location,
	population, 
	MAX(total_cases) AS highest_infection_count, 
	MAX((total_cases/population))*100 AS percent_population_infected
FROM 
	portfolioproject..coviddeaths
WHERE 
	location = 'Bangladesh'
GROUP BY location, population

-- The Bangladesh has an infection rate of 1.19%.

--  Has this changed over time?
SELECT 
	location,
	population,
	MAX(total_cases) AS highest_infection_count, 
	MAX((total_cases/population))*100 AS percent_population_infected
FROM 
	PortfolioProject..coviddeaths
WHERE 
	location = 'Bangladesh' AND date = '2020-7-15 00:00:00.000'
GROUP BY location, population


SELECT 
	location,
	population,
	MAX(total_cases) AS highest_infection_count, 
	MAX((total_cases/population))*100 AS percent_population_infected
FROM 
	PortfolioProject..coviddeaths
WHERE 
	location = 'Bangladesh' AND date = '2021-7-15 00:00:00.000'
GROUP BY location, population

SELECT 
	location,
	population,
	MAX(total_cases) AS highest_infection_count, 
	MAX((total_cases/population))*100 AS percent_population_infected
FROM 
	PortfolioProject..coviddeaths
WHERE 
	location = 'Bangladesh' AND date = '2022-7-15 00:00:00.000'
GROUP BY location, population



SELECT 
	location,
	population,
	MAX(total_cases) AS highest_infection_count, 
	MAX((total_cases/population))*100 AS percent_population_infected
FROM 
	PortfolioProject..coviddeaths
WHERE 
	location = 'Bangladesh' AND date = '2023-7-15 00:00:00.000'
GROUP BY location, population

 



-- Yes. In July 15, 2020, the Bangladesh infection rate was 0.11% and in 2021 it was 0.62%. The infection rate  increased almost 6 fold btween 2020 and 2021. 
-- In 2022 July, it was 1.16 which is alomst twich as much as in 2021 and in 2023, it was 1.19 


/* Which country had the highest death count in 2020 , 2021, 2022 and 2023? */
-- Showing the countries with the highest death count per population



-- 2020
SELECT
	location, 
	MAX(CAST(total_deaths AS INT)) as total_death_count
FROM 
	PortfolioProject..coviddeaths
WHERE 
	continent IS NOT NULL AND (DATEPART(yy, date) = 2020)
GROUP BY location
ORDER BY total_death_count DESC

-- 2021
SELECT 
	location, 
	MAX(CAST(total_deaths AS INT)) as total_death_count
FROM 
	PortfolioProject..coviddeaths
WHERE 
	continent IS NOT NULL AND (DATEPART(yy, date) = 2021)
GROUP BY location
ORDER BY total_death_count DESC

-- 2022
SELECT 
	location, 
	MAX(CAST(total_deaths AS INT)) as total_death_count
FROM 
	PortfolioProject..coviddeaths
WHERE 
	continent IS NOT NULL AND (DATEPART(yy, date) = 2022)
GROUP BY location
ORDER BY total_death_count DESC


-- 2023
SELECT 
	location, 
	MAX(CAST(total_deaths AS INT)) as total_death_count
FROM 
	PortfolioProject..coviddeaths
WHERE 
	continent IS NOT NULL AND (DATEPART(yy, date) = 2023)
GROUP BY location
ORDER BY total_death_count DESC

-- The United States, Brazil and India had  the highest death counts each year  
-- The death count in Mexico has improved since 2020, going from 4th place to 5th.Th UK went from 4th to 7th. Russia went from 9th to 4th.

/* How many people in the Bangladesh were hospitalized due to COVID-19? How many in the ICU? */

SELECT
	location,
	date,
	cast(total_cases as int) as total_cases,
	cast(hosp_patients as int) as hosp_patients,
	(cast(hosp_patients as float)/cast(total_cases as float))*100 AS hosp_per_case
FROM
	PortfolioProject..coviddeaths
WHERE 
	location LIKE '%Bangla%'
ORDER BY date

-- I think Hospitalisation data was not entered in the dataset even though  I know many people had been hospitalised to due covid 19

SELECT
	location,
	date,
	cast(total_cases as int) as total_cases,
	cast(icu_patients as int) as icu_patients,
	(cast(icu_patients as float)/cast(total_cases as float))*100 AS icu_per_case
FROM
	PortfolioProject..coviddeaths
WHERE 
	location LIKE '%Bangla%'
ORDER BY date

-- Icu addmision data are null as well



-------------------------------- LET'S BREAK THINGS DOWN BY CONTINENT ------------------------------------

/* Which continent has the highest death count? */
--  This shows contintents with the highest death count per population
SELECT 
	continent, 
	MAX(CAST(total_deaths AS INT)) as total_death_count
FROM 
	PortfolioProject..coviddeaths
WHERE 
	continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC

-- As of right now , North America has the highest death count.

-------------------------------------- GLOBAL NUMBERS ------------------------------




/* How many cases are there worldwide?
   How many deaths?
   What is the overall global death percentage?
*/
SELECT 
SUM(new_cases) AS total_cases, 
SUM(CAST(new_deaths AS INT)) AS total_deaths, 
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS global_death_pecentage
FROM 
	PortfolioProject..coviddeaths

WHERE continent IS NOT NULL 
ORDER BY 1,2
-- Presently, there are 770,43,2109 cases and 70,79,107 deaths worldwide due to COVID-19. The global death percentage is 0.91%.




/* 
								       DATA EXPLORATION - COVID VACCINATIONS DATA
*/


/* Viewing vaccination data*/

SELECT 
	* 
FROM 
	PortfolioProject..covidvaccinations
WHERE continent IS NOT NULL
ORDER BY date,population

/* What percentage of people are vaccinated? */
-- Shows percentage of population that has received at least one COVID-19 vaccine

SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_ppl_vaccinated
FROM 
	PortfolioProject..coviddeaths dea
		JOIN 
	PortfolioProject..covidvaccinations vac ON dea.location = vac.location
		AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
ORDER BY 2,3

---- Using Common Table Expression (CTE) to perform calculation on PARTITION BY in previous query

WITH population_vaccinated (continent, location, date, population, new_vaccinations, rolling_ppl_vaccinated)
AS
(
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_ppl_vaccinated
FROM 
	PortfolioProject..coviddeaths dea
		JOIN 
	PortfolioProject..covidvaccinations vac ON dea.location = vac.location
		AND dea.date = vac.date
WHERE 
	dea.continent IS NOT NULL
)

SELECT 
	* , 
	(rolling_ppl_vaccinated/population)*100 AS percent_vaccinated
FROM 
	population_vaccinated;
	
-- From this we can see how many people are being vaccinated daily in each country. 
-- new_vaccinations tells us how many people have been vaccinated that day while rolling_ppl_vaccinated provided a rolling count. 
-- percent_vaccinated gives us the daily percentage of peoole vaccinated in each country respective to their population

/* To do futher exploration, lets create a temp table */

DROP TABLE IF EXISTS #percent_population_vaccinated
CREATE TABLE #percent_population_vaccinated
(
	Continent NVARCHAR(255),
	Location NVARCHAR(255),
	Date DATETIME,
	Population NUMERIC,
	New_vaccinations NUMERIC,
	Rolling_People_Vaccinated NUMERIC
)

INSERT INTO #percent_population_vaccinated
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_ppl_vaccinated
FROM 
	PortfolioProject..coviddeaths dea
		JOIN 
	PortfolioProject..covidvaccinations vac ON dea.location = vac.location
		AND dea.date = vac.date
WHERE 
	dea.continent IS NOT NULL

SELECT 
	*, 
	(Rolling_People_Vaccinated/Population)*100 AS Percent_Vaccinated
FROM 
	#percent_population_vaccinated


/* What percentage of each country's population is vaccinated as of  (04/30/2021)? */
SELECT 
	Location,
	Date,
	Population,
	New_vaccinations,
	Rolling_People_Vaccinated,
	(Rolling_People_Vaccinated/Population)*100 AS Percent_vaccinated
FROM
	#percent_population_vaccinated
WHERE 
	Date = '2023-07-15 00:00:00.000'
ORDER BY Date

/* What percentage of the Bangladesh population is vaccinated as of 04/30/2023? */
SELECT 
	Location,
	Date,
	Population,
	New_vaccinations,
	Rolling_People_Vaccinated,
	(Rolling_People_Vaccinated/Population)*100 AS Percent_vaccinated
FROM
	#percent_population_vaccinated
WHERE 
	Date = '2023-04-30 00:00:00.000'and Location = 'Bangladesh' 
ORDER BY Date

--  Over 81%

/* What percentage of the world is vaccinated? */
SELECT
	SUM(New_vaccinations) AS total_vaccinations,
	(SUM(CAST(New_vaccinations AS BIGINT))/SUM(Population))*100 AS global_vacc_percentage
FROM
	#percent_population_vaccinated
WHERE continent IS NOT NULL

-- 10849191153 people worldwide were vaccinated with at least one vaccine, that's 0.1% of the global population.


/* Which countries has the highest vaccination rate? */
SELECT 
	*, 
	(Rolling_People_Vaccinated/Population)*100 AS Percent_Vaccinated
FROM 
	#percent_population_vaccinated

SELECT
	Location,
	Continent,
	Population,
	MAX(New_vaccinations) as highest_vaccination_count,
	MAX((New_vaccinations/Population))*100 AS percent_vacc
FROM
	#percent_population_vaccinated
GROUP BY Location, Continent, Population
ORDER BY percent_vacc DESC 

-- Mongolia has the highest vaccination rate.

/* Which continents have the highest vaccination count? */
SELECT
	Continent,
	MAX(New_vaccinations) as highest_vaccination_count
FROM
	#percent_population_vaccinated
WHERE Continent IS NOT NULL 
GROUP BY Continent
ORDER BY highest_vaccination_count DESC 

-- Asia has the highest vaccination count
