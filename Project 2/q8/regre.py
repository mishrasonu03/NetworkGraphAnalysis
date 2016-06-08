import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import GradientBoostingRegressor
from sklearn import datasets, linear_model

train_path = "/home/rstudio/ee232/regress_train.csv"
test_path = "/home/rstudio/ee232/q8.csv"

print "reading data..."
train_data = pd.read_csv(train_path)
test_data = pd.read_csv(test_path)
train_data = train_data.set_index('Id')
test_data = test_data.set_index('Id')
feature_train = pd.DataFrame(columns = list(['v1','v2','v3','v4','v5','d','g']))
feature_test = pd.DataFrame(columns = list(['v1','v2','v3','v4','v5','d','g']))

target_train = pd.DataFrame(columns = list(['r']))
target_test = pd.DataFrame(columns = list(['r']))

feature_train_array = np.array(train_data)
feature_train_array = np.array(list(feature_train_array),dtype=float)
feature_train['v1'] = feature_train_array[0:,0]
feature_train['v2'] = feature_train_array[0:,1]
feature_train['v3'] = feature_train_array[0:,2]
feature_train['v4'] = feature_train_array[0:,3]
feature_train['v5'] = feature_train_array[0:,4]
feature_train['d'] = feature_train_array[0:,5]
feature_train['g'] = feature_train_array[0:,6]
target_train['r'] = feature_train_array[0:,7]
feature_train = feature_train.set_index(target_train.index)

feature_test_array = np.array(test_data)
feature_test_array = np.array(list(feature_test_array),dtype=float)
feature_test['v1'] = feature_test_array[0:,0]
feature_test['v2'] = feature_test_array[0:,1]
feature_test['v3'] = feature_test_array[0:,2]
feature_test['v4'] = feature_test_array[0:,3]
feature_test['v5'] = feature_test_array[0:,4]
feature_test['d'] = feature_test_array[0:,5]
feature_test['g'] = feature_test_array[0:,6]
#target_test['r'] = feature_test_array[0:,7]
#feature_test = feature_test.set_index(target_test.index)

rf_r = RandomForestRegressor(800)
rf_r.fit(feature_train, target_train.r.ravel())
predict_r = rf_r.predict(feature_test)
#RSS_r = np.subtract(predict_r,target_test.r).abs()
#error_r = RSS_r.mean()
print predict_r

rf_g = GradientBoostingRegressor(n_estimators = 1000)
rf_g.fit(feature_train, target_train.r.ravel())
predict_g = rf_g.predict(feature_test)
#RSS_g = np.subtract(predict_g,target_test.r).abs()
#error_g = RSS_g.mean()
print predict_g

rf_l = linear_model.LinearRegression()
rf_l.fit(feature_train, target_train.r.ravel())
predict_l = rf_l.predict(feature_test)
#RSS_l = np.subtract(predict_l,target_test.r).abs()
#error_l = RSS_l.mean()
print predict_l