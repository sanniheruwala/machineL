import pandas
import numpy as np
import pandas as pd
import time
import boto
from boto.s3.key import Key
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sqlalchemy import create_engine
import psycopg2

filename_train = 'test-drive-ml-2_3_4.csv'
names_train = ['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg','marker']
data_train = pandas.read_csv(filename_train, names=names_train)

df_train = pd.DataFrame(data_train, columns=data_train.columns)
df_train = df_train.ix[1:]

df_train['is_train'] = np.random.uniform(0, 0, len(df_train)) <= .100
df_train.head()

filename_test = 'sensor.csv'
names_test = ['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg','marker','trip_id','holizontalAccuracy','verticalAccuracy','altitude','longitude','latitude','timestamp']
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

df_test_copy[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg','holizontalAccuracy','verticalAccuracy','altitude','longitude','latitude','timestamp']] = df_test_copy[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg','holizontalAccuracy','verticalAccuracy','altitude','longitude','latitude','timestamp']].astype('float')
df_test_copy[['marker','trip_id']] = df_test_copy[['marker','trip_id']].astype('string')

d1_test = df_test[df_test['is_train']==True]
d1_train= df_train[df_train['is_train']==True]

d1_test[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg']] = d1_test[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg']].astype('float')
d1_train[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg']] = d1_train[['Speed','GyroScop_x','GyroScop_y','GyroScop_z','attitude_pitch','attitude_roll','attitude_yaw','acceleration_x','acceleration_y','acceleration_z','G_x_avg','G_y_avg','A_x_avg','A_y_avg','A_z_avg']].astype('float')

d1_train['marker'] = d1_train['marker'].astype('category')
d1_test['marker'] = d1_test['marker'].astype('category')

print('Number of observations in the training data:', len(d1_train))
print('Number of observations in the test data:',len(d1_test))

features = df_train.columns[:15]
features

y = pd.factorize(d1_train['marker'])[0]
x = pd.CategoricalIndex(d1_train['marker'])

clf = RandomForestClassifier(n_jobs=1000)

clf.fit(d1_train[features], y)

test_data = clf.predict(d1_test[features])

proba = clf.predict_proba(d1_test[features])

preds = clf.predict(d1_test[features])

sLength = len(df_test_copy['marker'])
df_test_copy['p_marker'] = pd.Series(preds , index=df_test_copy.index)

df_test_copy['p_marker'].replace(0, 'normal',inplace=True)
df_test_copy['p_marker'].replace(1, 'RightTurn',inplace=True)
df_test_copy['p_marker'].replace(2, 'HardAcceleration',inplace=True)
df_test_copy['p_marker'].replace(3, 'Decceleration',inplace=True)
df_test_copy['p_marker'].replace(4, 'LeftTurn',inplace=True)


tb = pd.crosstab(d1_test['marker'], df_test_copy['p_marker'], rownames=['Actual Events'], colnames=['Predicted Events'])
print(tb)


# In[47]:

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

# insert to postgresql
import psycopg2, csv

try:
    conn = psycopg2.connect("dbname='SensorFusionDatabase' user='sanni' host='sensorfusiondbinstance.cjz4wrixhzjb.us-west-2.rds.amazonaws.com' password='mysensorfusiondb'")
    print("connected")
except:
    print ("I am unable to connect to the database")

cur= conn.cursor()

reader = csv.reader(open('data.csv', 'r'))
     
dataText = ','.join(cur.mogrify("(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)", tuple(row))for i, row in enumerate(reader))
      
cur.execute('INSERT INTO "apple_sensor" VALUES ' + dataText)

conn.commit()
cur.close()

print("Data loaded successfully ... ")

#dataText = ','.join( cur.mogrify('(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)', tuple(row)) for i,row in enumerate(reader))
#cur.execute('INSERT INTO apple_sensor_test VALUES ' + dataText)

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
