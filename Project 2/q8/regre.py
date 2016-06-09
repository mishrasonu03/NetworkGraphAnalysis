import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import GradientBoostingRegressor
from sklearn import datasets, linear_model
from sklearn.metrics import r2_score

train_path = "/home/rstudio/ee232/regress_train.csv"
test_path = "/home/rstudio/ee232/regress_test.csv"

print "reading data..."
train_data = pd.read_csv(train_path)
test_data = pd.read_csv(test_path)
train_data = train_data.set_index('Id')
test_data = test_data.set_index('Id')
feature_train = pd.DataFrame(columns = list(['v1','v2','v3','v4','v5','g','r',
                                             'X1','X2','X3','X4','X5','X6','X7','X8','X9',
                                             'X10','X11','X12','X13','X14','X15','X16','X17','X18',
                                             'X19','X20','X21','X22','X23','X24','X25','X26','X27',
                                             'X28','X29','X30','X31','X32','X33','X34','X35','X36',
                                             'X37','X38','X39','X40','X41','X42','X43','X44','X45',
                                             'X46','X47','X48','X49','X50','X51','X52','X53','X54',
                                             'X55','X56','X57','X58','X59','X60','X61','X62','X63',
                                             'X64','X65','X66','X67','X68','X69','X70','X71','X72',
                                             'X73','X74','X75','X76','X77','X78','X79','X80','X81',
                                             'X82','X83','X84','X85','X86','X87','X88','X89','X90',
                                             'X91','X92','X93']))
feature_test = pd.DataFrame(columns = list(['v1','v2','v3','v4','v5','g','r',
                                             'X1','X2','X3','X4','X5','X6','X7','X8','X9',
                                             'X10','X11','X12','X13','X14','X15','X16','X17','X18',
                                             'X19','X20','X21','X22','X23','X24','X25','X26','X27',
                                             'X28','X29','X30','X31','X32','X33','X34','X35','X36',
                                             'X37','X38','X39','X40','X41','X42','X43','X44','X45',
                                             'X46','X47','X48','X49','X50','X51','X52','X53','X54',
                                             'X55','X56','X57','X58','X59','X60','X61','X62','X63',
                                             'X64','X65','X66','X67','X68','X69','X70','X71','X72',
                                             'X73','X74','X75','X76','X77','X78','X79','X80','X81',
                                             'X82','X83','X84','X85','X86','X87','X88','X89','X90',
                                             'X91','X92','X93']))

target_train = pd.DataFrame(columns = list(['r']))
target_test = pd.DataFrame(columns = list(['r']))

feature_train_array = np.array(train_data)
feature_train_array = np.array(list(feature_train_array),dtype=float)
feature_train['v1'] = feature_train_array[0:,0]
feature_train['v2'] = feature_train_array[0:,1]
feature_train['v3'] = feature_train_array[0:,2]
feature_train['v4'] = feature_train_array[0:,3]
feature_train['v5'] = feature_train_array[0:,4]
feature_train['g'] = feature_train_array[0:,5]
target_train['r'] = feature_train_array[0:,6]
feature_train['X1'] = feature_train_array[0:,7]
feature_train['X2'] = feature_train_array[0:,8]
feature_train['X3'] = feature_train_array[0:,9]
feature_train['X4'] = feature_train_array[0:,10]
feature_train['X5'] = feature_train_array[0:,11]
feature_train['X6'] = feature_train_array[0:,12]
feature_train['X7'] = feature_train_array[0:,13]
feature_train['X8'] = feature_train_array[0:,14]
feature_train['X9'] = feature_train_array[0:,15]
feature_train['X10'] = feature_train_array[0:,16]
feature_train['X11'] = feature_train_array[0:,17]
feature_train['X12'] = feature_train_array[0:,18]
feature_train['X13'] = feature_train_array[0:,19]
feature_train['X14'] = feature_train_array[0:,20]
feature_train['X15'] = feature_train_array[0:,21]
feature_train['X16'] = feature_train_array[0:,22]
feature_train['X17'] = feature_train_array[0:,23]
feature_train['X18'] = feature_train_array[0:,24]
feature_train['X19'] = feature_train_array[0:,25]
feature_train['X20'] = feature_train_array[0:,26]
feature_train['X21'] = feature_train_array[0:,27]
feature_train['X22'] = feature_train_array[0:,28]
feature_train['X23'] = feature_train_array[0:,29]
feature_train['X24'] = feature_train_array[0:,30]
feature_train['X25'] = feature_train_array[0:,31]
feature_train['X26'] = feature_train_array[0:,32]
feature_train['X27'] = feature_train_array[0:,33]
feature_train['X28'] = feature_train_array[0:,34]
feature_train['X29'] = feature_train_array[0:,35]
feature_train['X30'] = feature_train_array[0:,36]
feature_train['X31'] = feature_train_array[0:,37]
feature_train['X32'] = feature_train_array[0:,38]
feature_train['X33'] = feature_train_array[0:,39]
feature_train['X34'] = feature_train_array[0:,40]
feature_train['X35'] = feature_train_array[0:,41]
feature_train['X36'] = feature_train_array[0:,42]
feature_train['X37'] = feature_train_array[0:,43]
feature_train['X38'] = feature_train_array[0:,44]
feature_train['X39'] = feature_train_array[0:,45]
feature_train['X40'] = feature_train_array[0:,46]
feature_train['X41'] = feature_train_array[0:,47]
feature_train['X42'] = feature_train_array[0:,48]
feature_train['X43'] = feature_train_array[0:,49]
feature_train['X44'] = feature_train_array[0:,50]
feature_train['X45'] = feature_train_array[0:,51]
feature_train['X46'] = feature_train_array[0:,52]
feature_train['X47'] = feature_train_array[0:,53]
feature_train['X48'] = feature_train_array[0:,54]
feature_train['X49'] = feature_train_array[0:,55]
feature_train['X50'] = feature_train_array[0:,56]
feature_train['X51'] = feature_train_array[0:,57]
feature_train['X52'] = feature_train_array[0:,58]
feature_train['X53'] = feature_train_array[0:,59]
feature_train['X54'] = feature_train_array[0:,60]
feature_train['X55'] = feature_train_array[0:,61]
feature_train['X56'] = feature_train_array[0:,62]
feature_train['X57'] = feature_train_array[0:,63]
feature_train['X58'] = feature_train_array[0:,64]
feature_train['X59'] = feature_train_array[0:,65]
feature_train['X60'] = feature_train_array[0:,66]
feature_train['X61'] = feature_train_array[0:,67]
feature_train['X62'] = feature_train_array[0:,68]
feature_train['X63'] = feature_train_array[0:,69]
feature_train['X64'] = feature_train_array[0:,70]
feature_train['X65'] = feature_train_array[0:,71]
feature_train['X66'] = feature_train_array[0:,72]
feature_train['X67'] = feature_train_array[0:,73]
feature_train['X68'] = feature_train_array[0:,74]
feature_train['X69'] = feature_train_array[0:,75]
feature_train['X70'] = feature_train_array[0:,76]
feature_train['X71'] = feature_train_array[0:,77]
feature_train['X72'] = feature_train_array[0:,78]
feature_train['X73'] = feature_train_array[0:,79]
feature_train['X74'] = feature_train_array[0:,80]
feature_train['X75'] = feature_train_array[0:,81]
feature_train['X76'] = feature_train_array[0:,82]
feature_train['X77'] = feature_train_array[0:,83]
feature_train['X78'] = feature_train_array[0:,84]
feature_train['X79'] = feature_train_array[0:,85]
feature_train['X80'] = feature_train_array[0:,86]
feature_train['X81'] = feature_train_array[0:,87]
feature_train['X82'] = feature_train_array[0:,88]
feature_train['X83'] = feature_train_array[0:,89]
feature_train['X84'] = feature_train_array[0:,90]
feature_train['X85'] = feature_train_array[0:,91]
feature_train['X86'] = feature_train_array[0:,92]
feature_train['X87'] = feature_train_array[0:,93]
feature_train['X88'] = feature_train_array[0:,94]
feature_train['X89'] = feature_train_array[0:,95]
feature_train['X90'] = feature_train_array[0:,96]
feature_train['X91'] = feature_train_array[0:,97]
feature_train['X92'] = feature_train_array[0:,98]
feature_train['X93'] = feature_train_array[0:,99]


feature_train = feature_train.set_index(target_train.index)

feature_test_array = np.array(test_data)
feature_test_array = np.array(list(feature_test_array),dtype=float)
feature_test['v1'] = feature_test_array[0:,0]
feature_test['v2'] = feature_test_array[0:,1]
feature_test['v3'] = feature_test_array[0:,2]
feature_test['v4'] = feature_test_array[0:,3]
feature_test['v5'] = feature_test_array[0:,4]
feature_test['g'] = feature_test_array[0:,5]
target_test['r'] = feature_test_array[0:,6]
feature_test['X1'] = feature_test_array[0:,7]
feature_test['X2'] = feature_test_array[0:,8]
feature_test['X3'] = feature_test_array[0:,9]
feature_test['X4'] = feature_test_array[0:,10]
feature_test['X5'] = feature_test_array[0:,11]
feature_test['X6'] = feature_test_array[0:,12]
feature_test['X7'] = feature_test_array[0:,13]
feature_test['X8'] = feature_test_array[0:,14]
feature_test['X9'] = feature_test_array[0:,15]
feature_test['X10'] = feature_test_array[0:,16]
feature_test['X11'] = feature_test_array[0:,17]
feature_test['X12'] = feature_test_array[0:,18]
feature_test['X13'] = feature_test_array[0:,19]
feature_test['X14'] = feature_test_array[0:,20]
feature_test['X15'] = feature_test_array[0:,21]
feature_test['X16'] = feature_test_array[0:,22]
feature_test['X17'] = feature_test_array[0:,23]
feature_test['X18'] = feature_test_array[0:,24]
feature_test['X19'] = feature_test_array[0:,25]
feature_test['X20'] = feature_test_array[0:,26]
feature_test['X21'] = feature_test_array[0:,27]
feature_test['X22'] = feature_test_array[0:,28]
feature_test['X23'] = feature_test_array[0:,29]
feature_test['X24'] = feature_test_array[0:,30]
feature_test['X25'] = feature_test_array[0:,31]
feature_test['X26'] = feature_test_array[0:,32]
feature_test['X27'] = feature_test_array[0:,33]
feature_test['X28'] = feature_test_array[0:,34]
feature_test['X29'] = feature_test_array[0:,35]
feature_test['X30'] = feature_test_array[0:,36]
feature_test['X31'] = feature_test_array[0:,37]
feature_test['X32'] = feature_test_array[0:,38]
feature_test['X33'] = feature_test_array[0:,39]
feature_test['X34'] = feature_test_array[0:,40]
feature_test['X35'] = feature_test_array[0:,41]
feature_test['X36'] = feature_test_array[0:,42]
feature_test['X37'] = feature_test_array[0:,43]
feature_test['X38'] = feature_test_array[0:,44]
feature_test['X39'] = feature_test_array[0:,45]
feature_test['X40'] = feature_test_array[0:,46]
feature_test['X41'] = feature_test_array[0:,47]
feature_test['X42'] = feature_test_array[0:,48]
feature_test['X43'] = feature_test_array[0:,49]
feature_test['X44'] = feature_test_array[0:,50]
feature_test['X45'] = feature_test_array[0:,51]
feature_test['X46'] = feature_test_array[0:,52]
feature_test['X47'] = feature_test_array[0:,53]
feature_test['X48'] = feature_test_array[0:,54]
feature_test['X49'] = feature_test_array[0:,55]
feature_test['X50'] = feature_test_array[0:,56]
feature_test['X51'] = feature_test_array[0:,57]
feature_test['X52'] = feature_test_array[0:,58]
feature_test['X53'] = feature_test_array[0:,59]
feature_test['X54'] = feature_test_array[0:,60]
feature_test['X55'] = feature_test_array[0:,61]
feature_test['X56'] = feature_test_array[0:,62]
feature_test['X57'] = feature_test_array[0:,63]
feature_test['X58'] = feature_test_array[0:,64]
feature_test['X59'] = feature_test_array[0:,65]
feature_test['X60'] = feature_test_array[0:,66]
feature_test['X61'] = feature_test_array[0:,67]
feature_test['X62'] = feature_test_array[0:,68]
feature_test['X63'] = feature_test_array[0:,69]
feature_test['X64'] = feature_test_array[0:,70]
feature_test['X65'] = feature_test_array[0:,71]
feature_test['X66'] = feature_test_array[0:,72]
feature_test['X67'] = feature_test_array[0:,73]
feature_test['X68'] = feature_test_array[0:,74]
feature_test['X69'] = feature_test_array[0:,75]
feature_test['X70'] = feature_test_array[0:,76]
feature_test['X71'] = feature_test_array[0:,77]
feature_test['X72'] = feature_test_array[0:,78]
feature_test['X73'] = feature_test_array[0:,79]
feature_test['X74'] = feature_test_array[0:,80]
feature_test['X75'] = feature_test_array[0:,81]
feature_test['X76'] = feature_test_array[0:,82]
feature_test['X77'] = feature_test_array[0:,83]
feature_test['X78'] = feature_test_array[0:,84]
feature_test['X79'] = feature_test_array[0:,85]
feature_test['X80'] = feature_test_array[0:,86]
feature_test['X81'] = feature_test_array[0:,87]
feature_test['X82'] = feature_test_array[0:,88]
feature_test['X83'] = feature_test_array[0:,89]
feature_test['X84'] = feature_test_array[0:,90]
feature_test['X85'] = feature_test_array[0:,91]
feature_test['X86'] = feature_test_array[0:,92]
feature_test['X87'] = feature_test_array[0:,93]
feature_test['X88'] = feature_test_array[0:,94]
feature_test['X89'] = feature_test_array[0:,95]
feature_test['X90'] = feature_test_array[0:,96]
feature_test['X91'] = feature_test_array[0:,97]
feature_test['X92'] = feature_test_array[0:,98]
feature_test['X93'] = feature_test_array[0:,99]

feature_test = feature_test.set_index(target_test.index)

'''rf_r = RandomForestRegressor(800)
rf_r.fit(feature_train, target_train.r.ravel())
predict_r = rf_r.predict(feature_test)
RSS_r = np.subtract(predict_r,target_test.r).abs()
error_r = RSS_r.mean()
r2_r = r2_score(target_test.r,predict_r)a
print r2_r

rf_g = GradientBoostingRegressor(n_estimators = 1000)
rf_g.fit(feature_train, target_train.r.ravel())
predict_g = rf_g.predict(feature_test)
RSS_g = np.subtract(predict_g,target_test.r).abs()
error_g = RSS_g.mean()
r2_g = r2_score(target_test.r,predict_g)
print r2_g'''

rf_l = linear_model.LinearRegression()
rf_l.fit(feature_train, target_train.r.ravel())
predict_l = rf_l.predict(feature_test)
#RSS_l = np.subtract(predict_l,target_test.r).abs()
#error_l = RSS_l.mean()
#print target_test
r2_l = r2_score(target_test.r,predict_l)
print r2_l
