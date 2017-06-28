import pandas
from sklearn.ensemble import RandomForestClassifier
import numpy as np
import pandas as pd
import time
import boto
from boto.s3.key import Key
import pandas as pd
from sqlalchemy import create_engine
from pymongo import MongoClient
import psycopg2, csv

#--------------------------------------load training data from file---------------------------------------

filename_train = 'D:/Machine Learning/Bike sensor data/Test-Drive-Sasken/test-drive-ml-2_3_4.csv'
names_train = ['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg','marker']
data_train = pandas.read_csv(filename_train, names=names_train)

df_train = pd.DataFrame(data_train, columns=data_train.columns)
df_train = df_train.ix[1:]

df_train['is_train'] = np.random.uniform(0, 0, len(df_train)) <= .100
df_train.head()

#------------------------------------connect to mongo db to get test data----------------------------------

conn = MongoClient('ec2-35-154-102-28.ap-south-1.compute.amazonaws.com',1234)
db = conn.get_database('sensor_data')
collection = db.get_collection('apple_sensor')
cursor = collection.find()
df_mongo =  pd.DataFrame(list(cursor))
del df_mongo['_id']

#------------------------------------re-arrange columns and change speed m/s2 to kmph------------------------

df_mongo = df_mongo[['speed','gyroscop_x','gyroscop_y','gyroscop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','marker','trip_id','holizontalAccuracy','verticalAccuracy','altitude','longitude','latitude','timestamp']]
df_mongo['speed'] = df_mongo['speed'].astype('float') *(60.00000*60.00000/1000.00000)

#------------------------------------sort data based on timestamp,reset the index---------------------------

df_mongo = df_mongo.sort_values('timestamp')
df_mongo = df_mongo.reset_index(drop=True)

#------------------------------------rename column name,calculating moving average--------------------------

df_mongo.rename(columns = {'speed':'Speed','gyroscop_x':'GyroScop_x','gyroscop_y':'GyroScop_y','gyroscop_z':'GyroScop_z'}, inplace = True)
df_mongo['G_x_avg'] = df_mongo['GyroScop_x'].rolling(window=50).mean().fillna(0)
df_mongo['G_y_avg'] = df_mongo['GyroScop_y'].rolling(window=50).mean().fillna(0)
df_mongo['A_x_avg'] = df_mongo['acceleration_x'].rolling(window=50).mean().fillna(0)
df_mongo['A_y_avg'] = df_mongo['acceleration_y'].rolling(window=50).mean().fillna(0)
df_mongo['A_z_avg'] = df_mongo['acceleration_z'].rolling(window=50).mean().fillna(0)

#------------------------------------replace marker,rearrange and make two copy-----------------------------

df_mongo['marker'].replace('No Button Pressed', 'normal',inplace=True)
df_mongo['marker'].replace('No Button Pressed ', 'normal',inplace=True)
df_test = df_mongo[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg','marker','trip_id','holizontalAccuracy','verticalAccuracy','altitude','longitude','latitude','timestamp']]
df_test_copy = df_mongo[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg','marker','trip_id','holizontalAccuracy','verticalAccuracy','altitude','longitude','latitude','timestamp']]

#-------------------------------------code to read test data from file----------------------------------------

#filename_test = 'D:/Machine Learning/Bike sensor data/Test-Drive-Sasken/test-drive-ml-5.csv'
#names_test = ['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg','marker','trip_id','holizontalAccuracy','verticalAccuracy','altitude','longitude','latitude','timestamp']
#data_test = pandas.read_csv(filename_test, names=names_test)

#df_test = pd.DataFrame(data_test, columns=data_test.columns)
#df_test = df_test.ix[1:]

#df_test_copy = pd.DataFrame(data_test, columns=data_test.columns)
#df_test_copy = df_test_copy.ix[1:]

#-------------------------------------delete useless columns for test-----------------------------------------

del df_test['trip_id']
del df_test['holizontalAccuracy']
del df_test['verticalAccuracy']
del df_test['altitude']
del df_test['longitude']
del df_test['latitude']
del df_test['timestamp']

#-------------------------------------100% data for test,fixing data-type for train and test-------------------------------------

df_test['is_train'] = np.random.uniform(0, 0, len(df_test)) <= .100

df_test_copy[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg','holizontalAccuracy','verticalAccuracy','altitude','longitude','latitude','timestamp']] = df_test_copy[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg','holizontalAccuracy','verticalAccuracy','altitude','longitude','latitude','timestamp']].astype('object')
df_test_copy[['marker','trip_id']] = df_test_copy[['marker','trip_id']].astype('string')

d1_test = df_test[df_test['is_train']==True]
d1_train= df_train[df_train['is_train']==True]

d1_test[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg']] = d1_test[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg']].astype('float')
d1_train[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg']] = d1_train[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg']].astype('float')

d1_train['marker'] = d1_train['marker'].astype('category')
d1_test['marker'] = d1_test['marker'].astype('category')

print('Number of observations in the training data:', len(d1_train))
print('Number of observations in the test data:',len(d1_test))

#-----------------------------------choosing features(without marker),create index for marker(int)----------------------------

features = df_train.columns[:15]
features

y = pd.factorize(d1_train['marker'])[0]
x = pd.CategoricalIndex(d1_train['marker'])

#-----------------------------------init classifier,train model,predict for test data,check prob for test----------------------

clf = RandomForestClassifier(n_jobs=1000)

clf.fit(d1_train[features], y)

test_data = clf.predict(d1_test[features])

proba = clf.predict_proba(d1_test[features])

preds = clf.predict(d1_test[features])

#----------------------------------combining prediction as column with test data , confusion matrix--------------------------------------

sLength = len(df_test_copy['marker'])
df_test_copy['p_marker'] = pd.Series(preds , index=df_test_copy.index)

df_test_copy['p_marker'].replace(0, 'normal',inplace=True)
df_test_copy['p_marker'].replace(1, 'Right Turn',inplace=True)
df_test_copy['p_marker'].replace(2, 'Hard Acceleration',inplace=True)
df_test_copy['p_marker'].replace(3, 'Decceleration',inplace=True)
df_test_copy['p_marker'].replace(4, 'Left Turn',inplace=True)

tb = pd.crosstab(d1_test['marker'], df_test_copy['p_marker'], rownames=['Actual Events'], colnames=['Predicted Events'])
print(tb)

#----------------------------------adding few column for index and store data as data.csv------------------------------------------

df_test_copy['Line_Group']= df_test_copy.index
df_test_copy['Order_of_Points']= df_test_copy.index


def f(row):
    if (row['marker'] == 'normal') & (row['p_marker'] == 'normal'):
        val = 'normal'
    elif row['marker'] == row['p_marker']:
        val = 'matched'
    else:
        val = 'not_matched'
    return val
        
df_test_copy['combined_marker'] = df_test_copy.apply(f, axis=1)
df_test_copy.to_csv("data.csv",index = False,header = False)

#---------------------------connection to postgres-----------------------------------

try:
    conn = psycopg2.connect("dbname='SensorFusionDatabase' user='sanni' host='sensorfusiondbinstance.cjz4wrixhzjb.us-west-2.rds.amazonaws.com' password='mysensorfusiondb'")
    print("connected")
except:
    print ("I am unable to connect to the database")

cur= conn.cursor()

reader = csv.reader(open('data.csv', 'r'))

#---------------------------data insertion to postgres-------------------------------
     
dataText = ','.join(cur.mogrify("(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)", tuple(row))for i, row in enumerate(reader))
      
cur.execute('INSERT INTO "apple_sensor" VALUES ' + dataText)

conn.commit()
cur.close()

print("Data loaded successfully ... ")

#---------------------------comparatively slow insert--------------------------------

#print dataText
#reader = csv.reader(open('data.csv', 'r'))

#for i, row in enumerate(reader):
    #print(i, row)
    #if i == 0: continue
 
#    cur.execute('''
#       INSERT INTO "apple_sensor_test" (
#            "Speed","GyroScop_x","GyroScop_y","GyroScop_z","attitude_pitch","attitude_roll","attitude_yaw","acceleration_x","acceleration_y","acceleration_z","G_x_avg","G_y_avg","A_x_avg","A_y_avg","A_z_avg","marker","trip_id","holizontalAccuracy","verticalAccuracy","altitude","longitude","latitude","timestamp","p_marker","Line_Group","Order_of_Points","combined_marker"
#        ) values %s''', [tuple(row)]
#    )

#conn.commit()
#cur.close()
