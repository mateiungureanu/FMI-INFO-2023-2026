#include <iostream>
#include <fstream>
#include <stack>
#include <queue>
#include <vector>

/*
// pb1
int
main()
{
    std::stack<char> stiva;
    std::ifstream f("pb1.txt");
    std::string expresie;
    char last;
    std::getline(f, expresie);
//    std::cout<<expresie;
    for (char i : expresie)
    {
        if (i == '(' or i == '[' or i == '{')
        {
            stiva.push(i);
        }
        if (i == ')' or i == ']' or i == '}')
        {
            last = stiva.top();
            if (last == '(' and i == ')')
            {
                stiva.pop();
            }
            else if (last == '[' and i == ']')
            {
                stiva.pop();
            }
            else if (last == '{' and i == '}')
            {
                stiva.pop();
            }
            else
            {
                std::cout << "expresia nu e corecta";
                return 0;
            }
        }
    }
    std::cout << "expresia e corecta";
    return 0;
}
*/


// pb2
int
main() {
    std::ifstream f("pb2.txt");
    int n;
    f>>n;
    std::vector<int> nums(n);
    for (int i = 0; i < n; ++i) {
        f >> nums[i];
    }
    std::stack<int> s;
    std::queue<int> q1;
    std::queue<int> q2;
    std::vector<int> result(n, -1);
    for (int i = n - 1; i >= 0; --i) {
        while (!s.empty() && nums[s.top()] <= nums[i]) {
            s.pop();
        }
        if (!s.empty()) {
            result[i] = s.top();
        }
        s.push(i);
    }
    for (int i = 0; i < n; ++i) {
        if (result[i] != -1) {
            q1.push(result[i]);
            q2.push(i);
        }
    }
    while (!q1.empty()) {
        std::cout << q2.front() << " " << q1.front() << "\n";
        q2.pop();
        q1.pop();
    }
    return 0;
}