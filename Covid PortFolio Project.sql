select * 
 from PortfolioProject..CovidDeaths
order by 3,4

select * 
 from PortfolioProject..CovidVaccinations
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
 from PortfolioProject..CovidDeaths
order by 1,2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 from PortfolioProject..CovidDeaths
 where location like 'India%'
 order by 1,2

select location, date, total_cases, population , (total_cases/population)*100 as PopulationInfected
 from PortfolioProject..CovidDeaths
 where location like 'India%'
order by 1,2

select location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PopulationInfected
from PortfolioProject..CovidDeaths
group by location, population
order by PopulationInfected desc

select location, Max(cast(total_deaths as int)) as TotalDeathCount 
from PortfolioProject..CovidDeaths
Where continent is Not Null
group by location
order by TotalDeathCount desc

select continent, Max(cast(total_deaths as int)) as TotalDeathCount 
from PortfolioProject..CovidDeaths
Where continent is not null
group by continent
order by TotalDeathCount desc


select  date, SUM(new_cases)as total_cases, Sum(cast(new_deaths as int))as total_deaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
Where continent is not null
Group by date
order by 1,2

select * 
from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


with PopulationvsVaccination (continent, Location, date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *,(RollingPeopleVaccinated/Population)*100
 From PopulationvsVaccination

 create table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
and dea.date = vac.date
select *,(RollingPeopleVaccinated/Population)*100
 From #PercentPopulationVaccinated

 create view PercentPopulationVaccinated as  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is Not Null

select *
from PercentPopulationVaccinated
ORDER BY 1,2





