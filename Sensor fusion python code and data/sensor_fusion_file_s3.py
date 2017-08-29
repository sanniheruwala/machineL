#n[20]:

import pandas
import numpy as np
import pandas as pd
import time
import boto
from sklearn.ensemble import RandomForestClassifier
from boto.s3.key import Key

# In[21]:

filename_train = 'test-drive-ml-2_3_4.csv'
names_train = ['Speed (Kmph)','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg','marker']
data_train = pandas.read_csv(filename_train, names=names_train)

df_train = pd.DataFrame(data_train, columns=data_train.columns)
df_train = df_train.ix[1:]

df_train['is_train'] = np.random.uniform(0, 0, len(df_train)) <= .100
df_train.head()


# In[39]:

filename_test = 'test-drive-ml-5.csv'
names_test = ['Speed (Kmph)','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg','marker','trip_id','holizontalAccuracy','verticalAccuracy','altitude','longitude','latitude','timestamp']
data_test = pandas.read_csv(filename_test, names=names_test)

df_test = pd.DataFrame(data_test, columns=data_test.columns)
df_test = df_test.ix[1:]

df_test_copy = pd.DataFrame(data_test, columns=data_test.columns)
df_test_copy = df_test_copy.ix[1:]

del df_test['trip_id']
del df_test['holizontalAccuracy']
del df_test['verticalAccuracy']
del df_test['altitude']
del df_test['longitude']
del df_test['latitude']
del df_test['timestamp']

df_test['is_train'] = np.random.uniform(0, 0, len(df_test)) <= .100
df_test.head()


# In[40]:

d1_test = df_test[df_test['is_train']==True]
d1_train= df_train[df_train['is_train']==True]

d1_test[['Speed (Kmph)','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg']] = d1_test[['Speed (Kmph)','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg']].astype('float')
d1_train[['Speed (Kmph)','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg']] = d1_train[['Speed (Kmph)','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg']].astype('float')

d1_train['marker'] = d1_train['marker'].astype('category')
d1_test['marker'] = d1_test['marker'].astype('category')


# In[41]:

print('Number of observations in the training data:', len(d1_train))
print('Number of observations in the test data:',len(d1_test))


# In[42]:

features = df_train.columns[:15]
features


# In[43]:

y = pd.factorize(d1_train['marker'])[0]
x = pd.CategoricalIndex(d1_train['marker'])

#x.append(y.tolist)
#print(x[2100:2157])
#y[2100:2157]


# In[44]:


clf = RandomForestClassifier(n_jobs=3)

clf.fit(d1_train[features], y)


# In[45]:

test_data = clf.predict(d1_test[features])
#test_data


# In[46]:

proba = clf.predict_proba(d1_test[features])
#print(proba)


# In[47]:

preds = clf.predict(d1_test[features])


# In[52]:

sLength = len(df_test_copy['marker'])

#for x in np.nditer(preds):
df_test_copy['p_marker'] = pd.Series(preds , index=df_test_copy.index)

df_test_copy['p_marker'].replace(0, 'normal',inplace=True)
df_test_copy['p_marker'].replace(1, 'RightTurn',inplace=True)
df_test_copy['p_marker'].replace(2, 'HardAcceleration',inplace=True)
df_test_copy['p_marker'].replace(3, 'Decceleration',inplace=True)
df_test_copy['p_marker'].replace(4, 'LeftTurn',inplace=True)


# In[54]:

ts = int(time.time())
data_file = df_test_copy.to_csv(str(ts)+".csv",index=False)


# In[55]:

tb = pd.crosstab(d1_test['marker'],  df_test_copy['p_marker'] , rownames=['Actual Events'], colnames=['Predicted Events'])
#import matplotlib.pyplot as plt
#tb.plot()
tb.to_csv(str(ts)+"_cross_table.csv")
#plt.show()
print(tb)

keyId = "AKIAJM6HKMMJJO5MIK4Q"
sKeyId= "j5RD68MBl5KYnKimWgrxxNSnvJzzazYFTMrGois+"
fileName='/SensorFusion/data_files/'+str(ts)+".csv"
bucketName="geo-code"
files = open(str(ts)+".csv")
conn = boto.connect_s3(keyId,sKeyId)
bucket = conn.get_bucket(bucketName)
#Get the Key object of the bucket
k = Key(bucket)
#Crete a new key with id as the name of the file
k.key=fileName
#Upload the file
result = k.set_contents_from_file(files)
#result contains the size of the file uploaded
print('file uploaded successfully...')



