import numpy as np
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
import pandas as pd

demoData = np.random.randint(1, 10, (5 ,4)) # de 1 a 10 os numeros, array de array 10 de 4 posições

scalar_model = MinMaxScaler()
feature_data = scalar_model.fit_transform(demoData)

#print(demoData)
#print(feature_data)

df = pd.DataFrame(data=feature_data, columns=['k1', 'k2', 'k3', 'labels'])
print(df)
x = df[['k1', 'k2', 'k3']]
y = df['labels']
#print(x)
#print(y)

x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.30, random_state=42)

print(x_train)
print(x_test)

