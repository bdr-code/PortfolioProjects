Abdur Rob

COVID-19 Data Exploration Project

QUERIES USED FOR TABLEAU DASHBOARD


--1.GLOBAL CASES, DEATHS & DEATH PERCENTAGE

Select SUM(new_cases) as total_cases,
	  SUM(cast(new_deaths as int)) as total_deaths, 
	  SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
	 From PortfolioProject..CovidDeaths

where continent is not null 
order by total_cases, total_deaths




-- 2. Deaths Based on Continents

SELECT 
	continent, 
	MAX(CAST(total_deaths AS INT)) as total_death_count
FROM 
	PortfolioProject..coviddeaths
WHERE 
	continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC


-- 3. PERCENT POPULATION INFECTED
SELECT
	location, 
	population, 
	MAX(total_cases) AS highest_infection_count,  
	Max((total_cases/population))*100 AS percent_population_infected
FROM 
	PortfolioProject..coviddeaths
GROUP BY location, population
ORDER BY percent_population_infected DESC



-- 4.PERCENT POPULATION INFECTED OVERTIME


Select
	Location, 
	Population,
	date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From 
	PortfolioProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc


