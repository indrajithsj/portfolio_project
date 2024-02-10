
# webscrapping using python and other libraries

import pandas as pd
import requests
from bs4 import BeautifulSoup


# getting the url


url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'



page = requests.get(url)
soup = BeautifulSoup(page.text,'html')
print(soup)



table = soup.findAll('table')[1]
print(table)



titles = table.findAll('th')
World_title = [title.text.strip() for title in titles]
print(World_title)




df = pd.DataFrame(columns = World_title)
df



column_data = table.findAll('tr')
for row in column_data[1:]:
      row_data = row.findAll('td')
      table_data = [data.text.strip()for data in row_data]
      #print(table_data)
        
      length = len(df)
      df.loc[length] = table_data


df

df.to_csv(r'C:\Users\17059\Desktop\Data Analyst\portfolio project\companies.csv', index = False)





