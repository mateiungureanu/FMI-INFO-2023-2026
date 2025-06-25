import numpy as np
from sklearn import preprocessing
from sklearn.linear_model import LinearRegression, Ridge, Lasso
from sklearn.metrics import mean_squared_error, mean_absolute_error
from sklearn.model_selection import KFold
from sklearn.utils import shuffle

training_data = np.load('training_data.npy')
prices = np.load('prices.npy')
training_data, prices = shuffle(training_data, prices, random_state=0)

lasso_regression_model = Lasso(alpha=1)


def normalizeData(trainData, testData):
    scaler = preprocessing.StandardScaler().fit(trainData)
    # scaler = preprocessing.Normalizer().fit(trainData)
    trainData = scaler.transform(trainData)
    testData = scaler.transform(testData)

    return trainData, testData


def linearRegression(nrSplits):
    linear_regression_model = LinearRegression()

    kf = KFold(n_splits=nrSplits)

    mse_final = 0
    mae_final = 0

    for train_index, test_index in kf.split(training_data):
        train_data = training_data[train_index]
        test_data = training_data[test_index]
        train_prices = prices[train_index]
        test_prices = prices[test_index]
        train_data, test_data = normalizeData(trainData=train_data, testData=test_data)
        linear_regression_model.fit(train_data, train_prices)
        y_true = np.array(test_prices)
        y_pred = linear_regression_model.predict(test_data)

        mse_value = mean_squared_error(y_true, y_pred)
        mae_value = mean_absolute_error(y_true, y_pred)
        mae_final += mae_value
        mse_final += mse_value

    return mae_final/nrSplits, mse_final/nrSplits


print("ex2:", linearRegression(3))


def ridgeRegression(nrSplits, a):
    ridge_regression_model = Ridge(alpha=a)

    kf = KFold(n_splits=nrSplits)

    mse_final = 0
    mae_final = 0

    for train_index, test_index in kf.split(training_data):
        train_data = training_data[train_index]
        test_data = training_data[test_index]
        train_prices = prices[train_index]
        test_prices = prices[test_index]
        train_data, test_data = normalizeData(trainData=train_data, testData=test_data)
        ridge_regression_model.fit(train_data, train_prices)
        y_true = np.array(test_prices)
        y_pred = ridge_regression_model.predict(test_data)

        mse_value = mean_squared_error(y_true, y_pred)
        mae_value = mean_absolute_error(y_true, y_pred)
        mae_final += mae_value
        mse_final += mse_value

    return mae_final/nrSplits, mse_final/nrSplits


print("ex3:")
for alpha in [1, 10, 100, 1000]:
    print(ridgeRegression(3, alpha))

a=10
ridge_regression_model = Ridge(alpha=a)
training_data_normalized, _ = normalizeData(training_data, training_data)
ridge_regression_model.fit(training_data_normalized, prices)
print("ex4:")
print(f"Coeficients:", ridge_regression_model.coef_)
print(f"Bias:", ridge_regression_model.intercept_)
print(f"Most significant attribute:", np.argmax(np.abs(ridge_regression_model.coef_)))
print(f"Second most significant attribute:", np.argsort(np.abs(ridge_regression_model.coef_))[-2])
print(f"Least significant attribute:", np.argmin(np.abs(ridge_regression_model.coef_)))