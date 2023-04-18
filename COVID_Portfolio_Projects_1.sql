--PortfolioProject

select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 1, 2


select *
from PortfolioProject..CovidVaccinations
order by 1, 2


-- Select Data that we are going to be using

Select Location, date, total_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_death/total_cases)*100 as DrathsPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select Location, date, total_cases, Population(total_cases/Population)*100 as DrathsPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

-- Looking at Countries with highest Infection Rate comapred to Population

Select Location, Population,MAX(total_case) as HighestInfectionCount, MAX(total_cases/Population)*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
Group by LOcation, Population
order by PercentagePopulationInfected desc

-- Showing Countries with Highest Death Count perPopulation

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathsCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by LOcation
order by TotalDeathsCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathsCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by LOcation
order by TotalDeathsCount desc

-- Showing contintents with highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathsCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent 
order by TotalDeathsCount desc

-- GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DrathsPercentage
from PortfolioProject..CovidDeaths
-- where location like '%states%'
where continent is not null
Group by date 
order by 1,2


-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

-- USE CTE

with PopvsVac(Continent, Location, Date, Population, new_vaccinations ,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3
)

select *, (,RollingPeopleVaccinated/Population)*100
from PopvsVac

-- TEMP TABLE

Drop Table if exists #PercenPopulationVaccinated
Create Table #PercenPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercenPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 1,2,3

select *, (,RollingPeopleVaccinated/Population)*100
from #PercenPopulationVaccinated

-- Creation view for the later visulisation

Create view PercenPopulationVaccinated as

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3


select * 
from PercenPopulationVaccinated 

