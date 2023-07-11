SELECT Location,date,total_cases,new_cases,total_deaths,population 
FROM PortfolioProjects..covid_deaths
order by 1,2


--Looking at Total cases vs Total Deaths
SELECT Location,date,total_cases,total_deaths ,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjects..covid_deaths
order by 1,2

---specifying a particular country using where/like
SELECT Location,date,total_cases,total_deaths ,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjects..covid_deaths
WHERE location like 'Kenya'
order by 1,2

---showing the percentage of population that got covid in Kenya
SELECT Location,date,total_cases,population ,(total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProjects..covid_deaths
WHERE location like 'Kenya'
order by 1,2

---Looking at countries with highest infection rates compared to population
SELECT Location,MAX(total_cases) as HighestInfectionCount,population ,Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProjects..covid_deaths
---WHERE location like 'Kenya'
GROUP BY Location,Population
order by PercentPopulationInfected

SELECT Location,MAX(total_cases) as HighestInfectionCount,population ,Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProjects..covid_deaths
---WHERE location like 'Kenya'
GROUP BY Location,Population
order by PercentPopulationInfected desc

---showing countries with highest deatch count per population
SELECT location,MAX(total_deaths) as TotalDeathCount
FROM PortfolioProjects..covid_deaths
---WHERE location like 'Kenya'
GROUP BY Location
order by TotalDeathCount desc

--showing the continent with highest death count per population
SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProjects..covid_deaths
---WHERE location like 'Kenya'
where continent is not null
GROUP BY continent
order by TotalDeathCount desc

--Global numbers
--total number of new cases globally on each date
SELECT date,SUM(new_cases)--,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjects..covid_deaths
where continent is not null
Group By date
order by 1,2

--
SELECT date,SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM 
(new_cases)*100 as DeathPercentage

FROM PortfolioProjects..covid_deaths
where continent is not null
Group By date
order by 1,2

--joining the deaths and vaccination tables and looking at Total population vs vacc
SELECT Dea.continent,Dea.location,Dea.date,Dea.population,Vacc.new_vaccinations
FROM PortfolioProjects..covid_deaths as Dea
Join PortfolioProjects..covid_vaccination as Vacc
     On Dea.location=Vacc.location
	 and Dea.date=Vacc.date
where Dea.continent is not null
order by 2,3


SELECT Dea.continent,Dea.location,Dea.date,Dea.population,Vacc.new_vaccinations
,Sum(CONVERT(int,Vacc.new_vaccinations))OVER (Partition by Dea.location Order by Dea.location,Dea.date)
as RollingPeopleVaccinated
FROM PortfolioProjects..covid_deaths as Dea
Join PortfolioProjects..covid_vaccination as Vacc
     On Dea.location=Vacc.location
	 and Dea.date=Vacc.date
where Dea.continent is not null
order by 2,3

Select *,(RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated



--creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
SELECT Dea.continent,Dea.location,Dea.date,Dea.population,Vacc.new_vaccinations
,Sum(CONVERT(int,Vacc.new_vaccinations))OVER (Partition by Dea.location Order by Dea.location,Dea.date)
as RollingPeopleVaccinated
FROM PortfolioProjects..covid_deaths as Dea
Join PortfolioProjects..covid_vaccination as Vacc
     On Dea.location=Vacc.location
	 and Dea.date=Vacc.date
where Dea.continent is not null
--order by 2,3




