# -*- coding: utf-8 -*-
"""
Created on Sun Dec  4 10:18:47 2016

@author: Cipher
"""
import pandas as pd
import sklearn
from sklearn import cross_validation
import tensorflow as tf

data = pd.read_csv('/Users/Cipher/Downloads/ML_Training/ML_Training/train.csv')
data1 = pd.read_csv('/Users/Cipher/Downloads/ML_Training/ML_Training/test.csv')

data['Age'].fillna(data['Age'].median(), inplace=True)
data['Embarked'].fillna("S", inplace=True)

train, test = sklearn.cross_validation.train_test_split(data, train_size = 0.8)

CONTINUOUS_COLUMNS = ["Age", "Fare", "SibSp", "Parch"]
CATEGORICAL_COLUMNS = [ "Sex"]
#"Pclass", "Embarked",

def input_fn(df):
  # Creates a dictionary mapping from each continuous feature column name (k) to
  # the values of that column stored in a constant Tensor.
  continuous_cols = {k: tf.constant(df[k].values)
                     for k in CONTINUOUS_COLUMNS}
  # Creates a dictionary mapping from each categorical feature column name (k)
  # to the values of that column stored in a tf.SparseTensor.
  categorical_cols = {k: tf.SparseTensor(
      indices=[[i, 0] for i in range(df[k].size)],
      values=df[k].values,
      shape=[df[k].size, 1])
                      for k in CATEGORICAL_COLUMNS}
  # Merges the two dictionaries into one.
  feature_cols = dict(continuous_cols)
  feature_cols.update(categorical_cols)
  # Converts the label column into a constant Tensor.
  label = tf.constant(df["Survived"].values)
  # Returns the feature columns and the label.
  return feature_cols, label

def train_input_fn():
  return input_fn(train)

def eval_input_fn():
  return input_fn(test)

def predict_input_fn():
  return input_fn(data1)

Sex = tf.contrib.layers.sparse_column_with_keys(
  column_name="Sex", keys=["female", "male"])
  

#Pclass = tf.contrib.layers.sparse_column_with_keys(
#  column_name="Pclass", keys=["1", "2", "3"])  
  
#Embarked = tf.contrib.layers.sparse_column_with_keys(
#  column_name="Embarked", keys=["S", "C", "Q"])    
  
#Embarked = tf.contrib.layers.sparse_column_with_hash_bucket("Embarked", hash_bucket_size=1000) 

Age = tf.contrib.layers.real_valued_column("Age")
Fare = tf.contrib.layers.real_valued_column("Fare")
SibSp = tf.contrib.layers.real_valued_column("SibSp")
Parch = tf.contrib.layers.real_valued_column("Parch")

wide_columns = [Sex]
deep_columns = [
  tf.contrib.layers.embedding_column(Sex, dimension=8),Age, Fare, SibSp, Parch]
#model_dir = "/Users/Cipher/Downloads/ML_Training/ML_Training/"
import tempfile
model_dir = tempfile.mkdtemp()
m = tf.contrib.learn.DNNLinearCombinedClassifier(
    model_dir=model_dir,
    linear_feature_columns=wide_columns,
    dnn_feature_columns=deep_columns,
    dnn_hidden_units=[100, 50])
    
#''', Pclass,Embarked'''
m.fit(input_fn=train_input_fn, steps=200)
results = m.evaluate(input_fn=eval_input_fn, steps=1)  
for key in sorted(results):
    print (key, results[key])  
y = m.predict(input_fn=lambda: input_fn(data1))

print ("Predictions: {}".format(str(y)))
df_output = pd.DataFrame()
df_output['PassengerId'] = data1['PassengerId']
df_output['Survived'] = y
df_output[['PassengerId','Survived']].to_csv('/Users/Cipher/Downloads/ML_Training/ML_Training/tensor_flow_output.csv',index=False)
