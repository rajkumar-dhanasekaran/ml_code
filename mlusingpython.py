# coding: utf-8

# In[1]:

# https://www.dataquest.io/blog/machine-learning-python/
import pandas


# In[2]:

games = pandas.read_csv("/Users/Cipher/Documents/ml_code/mlusingpython.csv")


# In[3]:

games.columns


# In[4]:

games.shape


# In[5]:

import matplotlib.pyplot as plt


# In[6]:

plt.hist(games["average_rating"])


# In[ ]:

plt.show()


# In[ ]:

games[games["average_rating"] == 0]


# In[ ]:

print(games[games["average_rating"] == 0].iloc[0])


# In[ ]:

print(games[games["average_rating"] > 0].iloc[0])


# In[ ]:

games = games[games["users_rated"] > 0]


# In[ ]:

games = games.dropna(axis=0)


# In[ ]:

from sklearn.cluster import KMeans


# In[ ]:

kmeans_model = KMeans(n_clusters=5, random_state=1)


# In[ ]:

good_columns = games._get_numeric_data()


# In[ ]:

kmeans_model.fit(good_columns)


# In[ ]:

good_columns


# In[ ]:

labels = kmeans_model.labels_


# In[ ]:

labels


# In[ ]:

from sklearn.decomposition import PCA


# In[ ]:

pca_2 = PCA(2)


# In[ ]:

plot_columns = pca_2.fit_transform(good_columns)


# In[ ]:

plot_columns


# In[ ]:

plt.scatter(x=plot_columns[:, 0], y=plot_columns[:, 1], c=labels)


# In[ ]:

plt.show()


# In[ ]:

games.corr()["average_rating"]


# In[ ]:

columns = games.columns.tolist()


# In[ ]:

columns = [
    c
    for c in columns
    if c not in ["bayes_average_rating", "average_rating", "type", "name"]
]


# In[ ]:

columns


# In[ ]:

target = "average_rating"


# In[ ]:

from sklearn.cross_validation import train_test_split


# In[ ]:

train = games.sample(frac=0.8, random_state=1)
test = games.loc[~games.index.isin(train.index)]


# In[ ]:

print(train.shape)
print(test.shape)


# In[ ]:

from sklearn.linear_model import LinearRegression


# In[ ]:

model = LinearRegression()


# In[ ]:

model.fit(train[columns], train[target])


# In[ ]:

from sklearn.metrics import mean_squared_error


# In[ ]:

predictions = model.predict(test[columns])


# In[ ]:

mean_squared_error(predictions, test[target])


# In[ ]:

from sklearn.ensemble import RandomForestRegressor


# In[ ]:

model = RandomForestRegressor(n_estimators=100, min_samples_leaf=10, random_state=1)


# In[ ]:

model.fit(train[columns], train[target])


# In[ ]:

predictions = model.predict(test[columns])


# In[ ]:

mean_squared_error(predictions, test[target])


# In[ ]:

# explore using SVM, ensemble techniques, predict other columns
