import pandas as pd
import numpy as np


# In[ ]:

data = pd.read_csv("/Users/Cipher/Downloads/ML_Training/ML_Training/train.csv")


# In[ ]:

data.head()


# In[ ]:

data.describe()


# In[ ]:

data["Age"].fillna(data["Age"].median(), inplace=True)


# In[ ]:

data.describe()


# In[ ]:

survived_sex = data[data["Survived"] == 1]["Sex"].value_counts()
dead_sex = data[data["Survived"] == 0]["Sex"].value_counts()
df = pd.DataFrame([survived_sex, dead_sex])
df.index = ["Survived", "Dead"]
df.plot(kind="bar", figsize=(15, 8))


# In[ ]:

survived_embark = data[data["Survived"] == 1]["Embarked"].value_counts()
dead_embark = data[data["Survived"] == 0]["Embarked"].value_counts()
df = pd.DataFrame([survived_embark, dead_embark])
df.index = ["Survived", "Dead"]
df.plot(kind="bar", figsize=(15, 8))


# In[ ]:


def status(feature):
    print("Processing", feature, ": ok")


# In[ ]:


def get_combined_data():
    # reading train data
    train = pd.read_csv("/Users/Cipher/Downloads/ML_Training/ML_Training/train.csv")

    # reading test data
    test = pd.read_csv("/Users/Cipher/Downloads/ML_Training/ML_Training/test.csv")

    # extracting and then removing the targets from the training data
    targets = train.Survived
    train.drop("Survived", 1, inplace=True)

    # merging train data and test data for future feature engineering
    combined = train.append(test)
    combined.reset_index(inplace=True)
    combined.drop("index", inplace=True, axis=1)

    return combined


# In[ ]:

combined = get_combined_data()


# In[ ]:

combined.shape


# In[ ]:


def get_titles():

    global combined

    # we extract the title from each name
    combined["Title"] = combined["Name"].map(
        lambda name: name.split(",")[1].split(".")[0].strip()
    )

    # a map of more aggregated titles
    Title_Dictionary = {
        "Capt": "Officer",
        "Col": "Officer",
        "Major": "Officer",
        "Jonkheer": "Royalty",
        "Don": "Royalty",
        "Sir": "Royalty",
        "Dr": "Officer",
        "Rev": "Officer",
        "the Countess": "Royalty",
        "Dona": "Royalty",
        "Mme": "Mrs",
        "Mlle": "Miss",
        "Ms": "Mrs",
        "Mr": "Mr",
        "Mrs": "Mrs",
        "Miss": "Miss",
        "Master": "Master",
        "Lady": "Royalty",
    }

    # we map each title
    combined["Title"] = combined.Title.map(Title_Dictionary)


# In[ ]:

get_titles()


# In[ ]:

grouped = combined.groupby(["Sex", "Pclass", "Title"])
grouped.median()


# In[ ]:


def process_age():

    global combined

    # a function that fills the missing values of the Age variable

    def fillAges(row):
        if row["Sex"] == "female" and row["Pclass"] == 1:
            if row["Title"] == "Miss":
                return 30
            elif row["Title"] == "Mrs":
                return 45
            elif row["Title"] == "Officer":
                return 49
            elif row["Title"] == "Royalty":
                return 39

        elif row["Sex"] == "female" and row["Pclass"] == 2:
            if row["Title"] == "Miss":
                return 20
            elif row["Title"] == "Mrs":
                return 30

        elif row["Sex"] == "female" and row["Pclass"] == 3:
            if row["Title"] == "Miss":
                return 18
            elif row["Title"] == "Mrs":
                return 31

        elif row["Sex"] == "male" and row["Pclass"] == 1:
            if row["Title"] == "Master":
                return 6
            elif row["Title"] == "Mr":
                return 41.5
            elif row["Title"] == "Officer":
                return 52
            elif row["Title"] == "Royalty":
                return 40

        elif row["Sex"] == "male" and row["Pclass"] == 2:
            if row["Title"] == "Master":
                return 2
            elif row["Title"] == "Mr":
                return 30
            elif row["Title"] == "Officer":
                return 41.5

        elif row["Sex"] == "male" and row["Pclass"] == 3:
            if row["Title"] == "Master":
                return 6
            elif row["Title"] == "Mr":
                return 26

    combined.Age = combined.apply(
        lambda r: fillAges(r) if np.isnan(r["Age"]) else r["Age"], axis=1
    )

    status("age")


# In[ ]:

process_age()


# In[ ]:

combined.info()


# In[ ]:


def process_names():

    global combined
    # we clean the Name variable
    combined.drop("Name", axis=1, inplace=True)

    # encoding in dummy variable
    titles_dummies = pd.get_dummies(combined["Title"], prefix="Title")
    combined = pd.concat([combined, titles_dummies], axis=1)

    # removing the title variable
    combined.drop("Title", axis=1, inplace=True)

    status("names")


# In[ ]:

process_names()


# In[ ]:

combined.head()


# In[ ]:


def process_fares():

    global combined
    # there's one missing fare value - replacing it with the mean.
    combined.Fare.fillna(combined.Fare.mean(), inplace=True)

    status("fare")


# In[ ]:

process_fares()


# In[ ]:


def process_embarked():

    global combined
    # two missing embarked values - filling them with the most frequent one (S)
    combined.Embarked.fillna("S", inplace=True)

    # dummy encoding
    embarked_dummies = pd.get_dummies(combined["Embarked"], prefix="Embarked")
    combined = pd.concat([combined, embarked_dummies], axis=1)
    combined.drop("Embarked", axis=1, inplace=True)

    status("embarked")


# In[ ]:

process_embarked()


# In[ ]:


def process_cabin():

    global combined

    # replacing missing cabins with U (for Uknown)
    combined.Cabin.fillna("U", inplace=True)

    # mapping each Cabin value with the cabin letter
    combined["Cabin"] = combined["Cabin"].map(lambda c: c[0])

    # dummy encoding ...
    cabin_dummies = pd.get_dummies(combined["Cabin"], prefix="Cabin")

    combined = pd.concat([combined, cabin_dummies], axis=1)

    combined.drop("Cabin", axis=1, inplace=True)

    status("cabin")


# In[ ]:

process_cabin()


# In[ ]:

combined.head()


# In[ ]:

combined.info()


# In[ ]:


def process_sex():

    global combined
    # mapping string values to numerical one
    combined["Sex"] = combined["Sex"].map({"male": 1, "female": 0})

    status("sex")


# In[ ]:

process_sex()


# In[ ]:


def process_pclass():

    global combined
    # encoding into 3 categories:
    pclass_dummies = pd.get_dummies(combined["Pclass"], prefix="Pclass")

    # adding dummy variables
    combined = pd.concat([combined, pclass_dummies], axis=1)

    # removing "Pclass"

    combined.drop("Pclass", axis=1, inplace=True)

    status("pclass")


# In[ ]:

process_pclass()


# In[ ]:

# has some error in map,filter functions, couldn't resolve in time
def process_ticket():

    global combined

    # a function that extracts each prefix of the ticket, returns 'XXX' if no prefix (i.e the ticket is a digit)
    def cleanTicket(ticket):
        ticket = ticket.replace(".", "")
        ticket = ticket.replace("/", "")
        ticket = ticket.split()
        ticket = map(lambda t: t.strip(), ticket)
        ticket = list(filter(lambda t: not t.isdigit(), ticket))
        if len(ticket) > 0:
            return ticket[0]
        else:
            return "XXX"

    # Extracting dummy variables from tickets:

    combined["Ticket"] = combined["Ticket"].map(cleanTicket)
    tickets_dummies = pd.get_dummies(combined["Ticket"], prefix="Ticket")
    combined = pd.concat([combined, tickets_dummies], axis=1)
    combined.drop("Ticket", inplace=True, axis=1)

    status("ticket")


# In[ ]:

# ticket = combined['Ticket'].replace('/','')


# In[ ]:

process_ticket()


# In[ ]:


def process_family():

    global combined
    # introducing a new feature : the size of families (including the passenger)
    combined["FamilySize"] = combined["Parch"] + combined["SibSp"] + 1

    # introducing other features based on the family size
    combined["Singleton"] = combined["FamilySize"].map(lambda s: 1 if s == 1 else 0)
    combined["SmallFamily"] = combined["FamilySize"].map(
        lambda s: 1 if 2 <= s <= 4 else 0
    )
    combined["LargeFamily"] = combined["FamilySize"].map(lambda s: 1 if 5 <= s else 0)

    status("family")


# In[ ]:

process_family()


# In[ ]:

combined.shape


# In[ ]:


def scale_all_features():

    global combined

    features = list(combined.columns)
    features.remove("PassengerId")
    # features.remove('Ticket')
    combined[features] = combined[features].apply(lambda x: x / x.max(), axis=0)

    print("Features scaled successfully !")


# In[ ]:

combined.head()


# In[ ]:

scale_all_features()


# In[ ]:

from sklearn.pipeline import make_pipeline
from sklearn.ensemble import RandomForestClassifier
from sklearn.feature_selection import SelectKBest
from sklearn.cross_validation import StratifiedKFold
from sklearn.grid_search import GridSearchCV
from sklearn.ensemble.gradient_boosting import GradientBoostingClassifier
from sklearn.cross_validation import cross_val_score


# In[ ]:


def compute_score(clf, X, y, scoring="accuracy"):
    xval = cross_val_score(clf, X, y, cv=5, scoring=scoring)
    return np.mean(xval)


# In[ ]:


def recover_train_test_target():
    global combined

    train0 = pd.read_csv("/Users/Cipher/Downloads/ML_Training/ML_Training/train.csv")

    targets = train0.Survived
    train = combined.ix[0:890]
    test = combined.ix[891:]

    return train, test, targets


# In[ ]:

train, test, targets = recover_train_test_target()


# In[ ]:

from sklearn.ensemble import ExtraTreesClassifier
from sklearn.feature_selection import SelectFromModel

clf = ExtraTreesClassifier(n_estimators=200)
clf = clf.fit(train, targets)


# In[ ]:

features = pd.DataFrame()
features["feature"] = train.columns
features["importance"] = clf.feature_importances_


# In[ ]:

features.sort(["importance"], ascending=False)


# In[ ]:

model = SelectFromModel(clf, prefit=True)
train_new = model.transform(train)
train_new.shape


# In[ ]:

test_new = model.transform(test)
test_new.shape


# In[ ]:

forest = RandomForestClassifier(max_features="sqrt")

parameter_grid = {
    "max_depth": [4, 5, 6, 7, 8],
    "n_estimators": [200, 210, 240, 250],
    "criterion": ["gini", "entropy"],
}

cross_validation = StratifiedKFold(targets, n_folds=5)

grid_search = GridSearchCV(forest, param_grid=parameter_grid, cv=cross_validation)

grid_search.fit(train_new, targets)

print("Best score: {}".format(grid_search.best_score_))
print("Best parameters: {}".format(grid_search.best_params_))


# In[ ]:

output = grid_search.predict(test_new).astype(int)
df_output = pd.DataFrame()
df_output["PassengerId"] = test["PassengerId"]
df_output["Survived"] = output
df_output[["PassengerId", "Survived"]].to_csv(
    "/Users/Cipher/Downloads/ML_Training/ML_Training/output.csv", index=False
)


# In[ ]:
