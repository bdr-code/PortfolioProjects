
Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4



--Select *
--From PorfolioProject..CovidVaccinations

--Order by 3,4


-- Select data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
Order By 1,2



--Looking at Total Cases Vs Total Death


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order By 1,2

--Shows likelihood of dying if you contract Covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Bangla%'
and  continent is not null
Order By 1,2


--Shows What Percentage of Population got Covid
Select location, date, population,total_cases,  (total_cases/population)*100 As PercentOfPopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null
Order By 1,2

--Looking at Countries with Highest infection rate compared to Population

Select location,  population, Max(total_cases) As HighestInfectionCount,  Max((total_cases/population))*100 As PercentOfPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group By location, population
Order By PercentOfPopulationInfected desc

--Showing Countries with Highest Death Count per population





-- showing continents with highest death count per populaton

Select continent, Max(cast(total_deaths as int) ) As TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group By continent
Order By TotalDeathCount desc

-- Global Numbers

Select sum(new_cases)as total_cases, sum(cast(new_deaths as int))as total_Deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 As DeathPercentage --,total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group By Date
Order By 1,2

--Looking at Total Population Vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order By 2,3



--Use CTE

With PopvsVac(Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3
)

Select * , (RollingPeopleVaccinated/population)*100
From PopvsVac

--Temp Table
Drop Table If exists #PercentOfPopulationVaccinated

Create Table #PercentOfPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert Into #PercentOfPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--Where dea.continent is not null
--Order By 2,3

Select * , (RollingPeopleVaccinated/population)*100
From #PercentOfPopulationVaccinated

-- Creating View for storing data for later Visualisations
Create View PercentOfPopulationVaccinated as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3

Select * from PercentOfPopulationVaccinated