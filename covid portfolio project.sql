select * from coviddeaths;


select * from covidvaccinated;

select location,date,population,total_cases,new_cases,total_deaths,new_deaths
from coviddeaths
order by 1;

/*DEATH PERCENTAGE*/
select location,date,population,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from coviddeaths
order by 1;

/*PERCENTAGE OF POPULATION GOT COVID*/
select location,date,population,total_cases,total_deaths,(total_cases/population)*100 as infected_percentage
from coviddeaths
order by 1;

/*countries with highest infection rate compared to population*/
select location,population,max(total_cases) as highest_Infected_count,max((total_cases/population))*100 as infected_percentage
from coviddeaths
group by location,population
order by infected_percentage desc;

/* death rate by locations*/
select location,max(cast(total_deaths as double)) as totaldeathcount
from coviddeaths
group by location
order by totaldeathcount desc;

/*death rate by continent*/
select continent,max(cast(total_deaths as double)) as totaldeaths_continent
from coviddeaths
group by continent
order by totaldeaths_continent desc;



/*countries with highest death count per population*/
select continent,location,population,max(total_deaths) as highest_deathrate,max((total_deaths/population))*100 as deathpercent_perpopulation
from coviddeaths
where continent is not null
group by continent,location,population
order by deathpercent_perpopulation desc;

/*GLOBAL NUMBERS*/
select date,sum(new_cases) as total_newcases,sum(new_deaths) as total_newdeaths,(sum(new_deaths)/sum(new_cases))*100 as percentage_death
from coviddeaths
group by date;

/* total cases*/
select sum(new_cases) as total_newcases,sum(new_deaths) as total_newdeaths,(sum(new_deaths)/sum(new_cases))*100 as percentage_death
from coviddeaths;

/*covid vaccination table*/
select * from covidvaccinated;

/* joining 2 tables*/
select * from coviddeaths as cd
join covidvaccinated as cv
on cd.location=cv.location
and cd.date=cv.date;


/*new vaccinated*/
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
from coviddeaths as cd
join covidvaccinated as cv
on cd.location=cv.location
and cd.date=cv.date
order by 2;

/*Rolling people vaccinates*/
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.date,cd.location) as rollingpeoplevaccinated
from coviddeaths as cd
join covidvaccinated as cv
on cd.location=cv.location
and cd.date=cv.date
order by 2;

/*finding percentage of people vaccinated*/
-- by using CTE
with per_peo_vac(continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.date,cd.location) as rollingpeoplevaccinated
from coviddeaths as cd
join covidvaccinated as cv
on cd.location=cv.location
and cd.date=cv.date
-- order by 2;
)
select *,(rollingpeoplevaccinated/population)*100 as percent_rollingpeople from per_peo_vac;

/* creating view */
create view percentpopulationvaccinated as
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.date,cd.location) as rollingpeoplevaccinated
from coviddeaths as cd
join covidvaccinated as cv
on cd.location=cv.location
and cd.date=cv.date;

select * from percentpopulationvaccinated;














