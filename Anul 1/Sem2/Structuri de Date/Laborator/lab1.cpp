#include <iostream>
#include <vector>

void printeaza(const std::vector<int>& v) {
    for (int i : v) {
        std::cout << i << " ";
    }
    std::cout << std::endl;
}

// pb1
void selectionSort(std::vector<int>& v) {
    int n = (int)v.size();
    for (int i = 0; i < n - 1; ++i) {
        int minIndex = i;
        for (int j = i + 1; j < n; ++j) {
            if (v[j] < v[minIndex]) {
                minIndex = j;
            }
        }
        std::swap(v[i], v[minIndex]);
    }
}

int main() {
    std::vector<int> v = {64, 25, 12, 22, 11};
    std::cout << "Vector original: ";
    printeaza(v);
    selectionSort(v);
    std::cout << "Vector sortat: ";
    printeaza(v);
    return 0;
}

// pb2
/*
void heapify(std::vector<int>& v, int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;
    if (left < n && v[left] > v[largest]) {
        largest = left;
    }
    if (right < n && v[right] > v[largest]) {
        largest = right;
    }
    if (largest != i) {
        std::swap(v[i], v[largest]);
        heapify(v, n, largest);
    }
}

void buildHeap(std::vector<int>& v, int n) {
    for (int i = 0; i < n; ++i) {
        int current = i;
        while (current > 0) {
            int parent = (current - 1) / 2;
            if (v[current] > v[parent]) {
                std::swap(v[current], v[parent]);
                current = parent;
            } else {
                break;
            }
        }
    }
}

void heapSort(std::vector<int>& v) {
    int n = (int)v.size();
    buildHeap(v, n);
    for (int i = n - 1; i > 0; --i) {
        std::swap(v[0], v[i]);
        heapify(v, i, 0);
    }
}

int main() {
    std::vector<int> v = {12, 11, 13, 5, 6, 7};
    std::cout << "Vector original: ";
    printArray(v);
    heapSort(v);
    std::cout << "Vector sortat: ";
    printArray(v);
    return 0;
}
*/