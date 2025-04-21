select *
from PortfolioProject..CovidDeaths
Where continent is not null
order by 3, 4 


--select *
--from PortfolioProject..CovidVaccinations
--order by 3, 4

--Select Data that we are going to be using

select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2 

--Looking for Total case vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%state%'
and continent is not null
order by 1,2 

-- Looking at Total Cases vs population
-- Shows what percentage of population got Covid

select Location, date,population, total_cases,(total_cases/population)*100 as percentagepopulationinfected
From PortfolioProject..CovidDeaths
-- Where location like '%state%'
order by 1,2


 -- Looking at countries with Highest Infection Rate compared to population

 select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as percentagepopulationinfected
From PortfolioProject..CovidDeaths
-- Where location like '%state%'
Group by location, population
order by percentagepopulationinfected desc


-- Showing Countries with Highest Death Count per population

select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location like '%state%'
Where continent is not null
Group by location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT


-- Showing continent with the highest death count per population

select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location like '%state%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

Select SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%state%'
Where continent is not null
--Group by date
order by 1,2 


-- Looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- USE CTE 
With PopvsVac (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select *, (RollingPeopleVaccinated/population)* 100
From PopvsVac



--TEMP TABlE

Create Table #PercentPppulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingpeopleVaccinated numeric
)

Insert into #PercentPppulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)* 100
From #PercentPppulationVaccinated


-- Create View to store data for later visualization

Create View percentpopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3



Select *
From percentpopulationVaccinated


























































