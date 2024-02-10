#!/usr/bin/env python
# coding: utf-8

# In[2]:


import pandas as pd
import requests
from bs4 import BeautifulSoup


# In[3]:


url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'


# In[5]:


page = requests.get(url)
soup = BeautifulSoup(page.text,'html')
print(soup)


# In[16]:


table = soup.findAll('table')[1]


# In[17]:


print(table)


# In[21]:


titles = table.findAll('th')


# In[23]:


World_title = [title.text.strip() for title in titles]
print(World_title)


# In[67]:


df = pd.DataFrame(columns = World_title)
df


# In[68]:


column_data = table.findAll('tr')


# In[70]:


for row in column_data[1:]:
      row_data = row.findAll('td')
      table_data = [data.text.strip()for data in row_data]
      #print(table_data)
        
      length = len(df)
      df.loc[length] = table_data
      
      
      
      


# In[71]:


df


# In[72]:


df.to_csv(r'C:\Users\17059\Desktop\Data Analyst\portfolio project\companies.csv', index = False)


# In[ ]:




