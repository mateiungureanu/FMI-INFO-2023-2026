import numpy as np
import matplotlib.pyplot as plt
from sklearn import svm

train_sentences = np.load('training_sentences.npy', allow_pickle=True)
train_labels = np.load('training_labels.npy', allow_pickle=True)

test_sentences = np.load('test_sentences.npy', allow_pickle=True)
test_labels = np.load('test_labels.npy', allow_pickle=True)

def normalize_data(train_data, test_data, type=None):
    if type == "standard":
        deviatie_standard = np.std(train_data, axis=0)
        medie = np.mean(train_data, axis=0)
        train_data = (train_data - medie) / deviatie_standard
        test_data = (test_data - medie) / deviatie_standard
    elif type == "l1":
        train_data = train_data / (np.sum(np.abs(train_data), axis=0) + 1e-5)
        test_data = test_data / (np.sum(np.abs(test_data), axis=0) + 1e-5)
    elif type == "l2":
        train_data = train_data / (np.sqrt(np.sum(np.square(train_data), axis=1, keepdims=True)) + 1e-5)
        test_data = test_data / (np.sqrt(np.sum(np.square(test_data), axis=1, keepdims=True)) + 1e-5)
    return train_data, test_data

class BagOfWords:
    def __init__(self):
        self.vocabulary = {}
        self.order = []

    def build_vocabulary(self, data):
        for sentence in data:
            for word in sentence:
                if word not in self.vocabulary:
                    self.vocabulary[word] = len(self.vocabulary)
                    self.order += [word]

    def get_features(self, data):
        matrix = np.zeros((len(data), len(self.vocabulary)))
        for index, sentence in enumerate(data):
            for word in sentence:
                if word in self.vocabulary:
                    matrix[index, self.vocabulary[word]] += 1
        return matrix

obiect = BagOfWords()
obiect.build_vocabulary(train_sentences)
print(len(obiect.order))

bow_train = obiect.get_features(train_sentences)
bow_test = obiect.get_features(test_sentences)
bow_train, bow_test = normalize_data(bow_train, bow_test, "l2")

model = svm.SVC(C = 1, kernel="linear")
model.fit(bow_train, train_labels)
array = model.predict(bow_test)
model.score(bow_test, test_labels)

dict_id2word = {v:k for k,v in obiect.vocabulary.items()}

print("the first 10 positive words are", [dict_id2word[i] for i in np.argsort(model.coef_[0])[::-1][:10]])
print("the first 10 negative words are", [dict_id2word[i] for i in np.argsort(model.coef_[0])[:10]])