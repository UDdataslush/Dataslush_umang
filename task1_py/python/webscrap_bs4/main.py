from bs4 import BeautifulSoup
import requests

print('Put some skill that you are not familiar with')
unfamiliar_skill = input('>')
print(f'Filtering out {unfamiliar_skill}')

html_text = requests.get('https://www.timesjobs.com/candidate/job-search.html?searchType=personalizedSearch&from=submit&txtKeywords=python&tpythonxtLocation=').text
soup = BeautifulSoup(html_text, 'lxml')
jobs = soup.find_all('li', class_='clearfix job-bx wht-shd-bx')

for job in jobs:
    published_date_tag = job.find('span', class_='sim-posted')
    published_date = published_date_tag.span.text if published_date_tag and published_date_tag.span else ""
    
    if 'few' in published_date:
        company_name_tag = job.find('h3', class_='joblist-comp-name')
        company_name = company_name_tag.text.strip().replace(' ', '') if company_name_tag else "Unknown Company"
        
        skills_tag = job.find('span', class_='srp-skills')
        skills = skills_tag.text.strip().replace(' ', '') if skills_tag else "No skills mentioned"
        
        more_info = job.header.h2.a['href'] if job.header and job.header.h2 and job.header.h2.a else "No link available"

        if unfamiliar_skill.lower() not in skills.lower():
            print(f"Company Name: {company_name}")
            print(f"Required Skills: {skills}")
            print(f"More Info: {more_info}")
            print('')
