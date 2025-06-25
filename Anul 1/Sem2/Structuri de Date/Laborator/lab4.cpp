#include <iostream>
#include <vector>
#include <list>

using namespace std;

vector<list<string>> hashTable(26);

int
hashFunction(const string &word)
{
    char firstLetter = static_cast<char>(tolower(word[0]));
    return firstLetter - 'a';
}

void
insert(const string &word)
{
    int index = hashFunction(word);
    list<string> &bucket = hashTable[index];
    auto it = bucket.begin();
    while (it != bucket.end() && *it < word)
    {
        ++it;
    }
    bucket.insert(it, word);
}

void
print()
{
    for (int i = 0; i < 26; ++i)
    {
        cout << (char)('a' + i) << ": ";
        for (auto &it : hashTable[i])
        {
            cout << it << " ";
        }
        cout << endl;
    }
}

int
main()
{
    cout << "Cuvinte (exit pentru end)" << endl;
    string word;
    while (true)
    {
        cin >> word;
        if (word == "exit")
        {
            break;
        }
        insert(word);
    }
    print();
    return 0;
}
