Select * From db_portfolio.CovidDeaths 
Where continent is not null and trim(continent) <>''
Order by 3, 4;
-- SELECT * FROM db_portfolio.CovidVaccinations ORDER BY 3, 4;
-- Select data we are going to be using
Select location, date, total_cases, new_cases, total_deaths, population
From db_portfolio.CovidDeaths
Where continent is not null and trim(continent) <>''
Order by 1, 2;

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract COVID in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From db_portfolio.CovidDeaths
Where location like '%kingdom%'
and continent is not null and trim(continent) <>''
ORDER BY 1, 2;

-- Looking at the Total Cases vs Population
-- Shows what percentage of population got COVID
Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From db_portfolio.CovidDeaths
-- Where location like '%kingdom%'
Where continent is not null and trim(continent) <>''
ORDER BY 1, 2;

-- Creating View to Store Data for Later Visualizations
Create View TotalCaseVsPopulation as
Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From db_portfolio.CovidDeaths
-- Where location like '%kingdom%'
Where continent is not null and trim(continent) <>'';

-- Looking at countries with the Highest Infection rate compared to Population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From db_portfolio.CovidDeaths
-- Where location like '%kingdom%'
Where continent is not null and trim(continent) <>''
Group by location, population
ORDER BY PercentPopulationInfected DESC;

-- Creating View to Store Data for Later Visualizations
Create View HighestInfectionRate as
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From db_portfolio.CovidDeaths
-- Where location like '%kingdom%'
Where continent is not null and trim(continent) <>''
Group by location, population
ORDER BY PercentPopulationInfected DESC;

-- Looking at countries with the Highest Infection rate compared to Population by Date
Select location, population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From db_portfolio.CovidDeaths
-- Where location like '%kingdom%'
Group by location, population, date
ORDER BY PercentPopulationInfected DESC;

-- Shows the Countries with the Highest Death Count per Population
Select location, MAX(cast(total_deaths as unsigned)) as TotalDeathCount
From db_portfolio.CovidDeaths
Where total_deaths REGEXP '^[0-9]+$'
and continent is not null and trim(continent) <>''
-- Where location like '%kingdom%'
Group by location
Order by TotalDeathCount DESC;

-- Creating View to Store Data for Later Visualizations
Create View HighestDeathByPopulation as
Select location, MAX(cast(total_deaths as unsigned)) as TotalDeathCount
From db_portfolio.CovidDeaths
Where total_deaths REGEXP '^[0-9]+$'
and continent is not null and trim(continent) <>''
-- Where location like '%kingdom%'
Group by location
Order by TotalDeathCount DESC;

-- Showing the Continents with the Highest Death Count per Population
Select continent, MAX(cast(total_deaths as unsigned)) as TotalDeathCount
From db_portfolio.CovidDeaths
-- Where location like '%states%'
Where continent is not null and trim(continent) <>''
Group by continent
Order by TotalDeathCount DESC;

-- Showing the Continents with the Highest Total Death Count per Population (SUM)
Select continent, SUM(cast(total_deaths as unsigned)) as TotalDeathCountContinent
From db_portfolio.CovidDeaths
Where total_deaths REGEXP '^[0-9]+$'
and continent is not null and trim(continent) <>''
-- Where location like '%kingdom%'
Group by continent
Order by TotalDeathCountContinent DESC;

-- Global Numbers
Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)* 100 as DeathPercentage
From db_portfolio.CovidDeaths
-- Where location like '%kingdom%'
Where continent is not null and trim(continent) <>''
Group by date
ORDER BY 1, 2;

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)* 100 as DeathPercentage
From db_portfolio.CovidDeaths
-- Where location like '%kingdom%'
Where continent is not null and trim(continent) <>''
-- Group by date
ORDER BY 1, 2;

-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From db_portfolio.coviddeaths dea
Join db_portfolio.covidvaccinations vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null and trim(dea.continent) <>''
order by 2,3;

-- Use a CTE
With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From db_portfolio.coviddeaths dea
Join db_portfolio.covidvaccinations vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null and trim(dea.continent) <>''
-- order by 2,3
)
Select *, (RollingPeopleVaccinated/Population) * 100
From PopvsVac;

-- TEMP TABLE
Create Table PercentPopulationVaccinated
(
continent varchar(255),
location varchar(255),
Date date,
population bigint,
new_vaccinations bigint,
RollingPeopleVaccinated bigint
);

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From db_portfolio.coviddeaths dea
Join db_portfolio.covidvaccinations vac
On dea.location = vac.location
and dea.date = vac.date;
-- Where dea.continent is not null and trim(dea.continent) <>''
-- order by 2,3

Select *, (RollingPeopleVaccinated/Population) * 100
From PercentPopulationVaccinated;

-- Creating View to Store Data for Later Visualizations
Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From db_portfolio.coviddeaths dea
Join db_portfolio.covidvaccinations vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null and trim(dea.continent) <>'';
-- order by 2,3

Select *
From PercentPopulationVaccinated;