#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;


// pb1 Kruskal
struct Edge
{
    int src, dest, weight;
};

bool
compareEdges(const Edge &a, const Edge &b)
{
    return a.weight < b.weight;
}

class UnionFind
{
public:
    explicit UnionFind(int n) : parent(n), rank(n, 0)
    {
        for (int i = 0; i < n; ++i)
            parent[i] = i;
    }

    int
    find(int u)
    {
        if (u != parent[u])
            parent[u] = find(parent[u]);
        return parent[u];
    }

    void
    unite(int u, int v)
    {
        int rootU = find(u);
        int rootV = find(v);
        if (rootU != rootV)
        {
            if (rank[rootU] > rank[rootV])
                parent[rootV] = rootU;
            else if (rank[rootU] < rank[rootV])
                parent[rootU] = rootV;
            else
            {
                parent[rootV] = rootU;
                rank[rootU]++;
            }
        }
    }

private:
    vector<int> parent;
    vector<int> rank;
};

vector<Edge>
kruskalMST(int V, vector<Edge> &edges)
{
    sort(edges.begin(), edges.end(), compareEdges);
    UnionFind uf(V);
    vector<Edge> mst;
    for (const auto &edge : edges)
    {
        if (uf.find(edge.src) != uf.find(edge.dest))
        {
            mst.push_back(edge);
            uf.unite(edge.src, edge.dest);
        }
    }
    return mst;
}

int
main()
{
    int V = 4;
    vector<Edge> edges = {
        {0, 1, 1},
        {0, 2, 2},
        {1, 2, 3},
        {1, 3, 4},
        {2, 3, 5}
    };
    vector<Edge> mst = kruskalMST(V, edges);
    cout << "Edges in the Minimum Spanning Tree:" << endl;
    for (const auto &edge : mst)
    {
        cout << edge.src << " -- " << edge.dest << " == " << edge.weight << endl;
    }
    return 0;
}

/*
// pb2 Prim
#include <queue>
#include <utility>

void primMST(const vector<vector<pair<int, int>>>& graph, int V) {
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<>> pq;
    vector<int> key(V, INT_MAX);
    vector<int> parent(V, -1);
    vector<bool> inMST(V, false);
    int startVertex = 0;
    pq.emplace(0, startVertex);
    key[startVertex] = 0;
    while (!pq.empty()) {
        int u = pq.top().second;
        pq.pop();
        if (inMST[u])
            continue;
        inMST[u] = true;
        for (const auto& [weight, v] : graph[u]) {
            if (!inMST[v] && weight < key[v]) {
                key[v] = weight;
                pq.emplace(key[v], v);
                parent[v] = u;
            }
        }
    }
    cout << "Edges in the Minimum Spanning Tree:" << endl;
    for (int i = 1; i < V; ++i) {
        cout << parent[i] << " -- " << i << " == " << key[i] << endl;
    }
}

int main() {
    int V = 4;
    vector<vector<pair<int, int>>> graph(V);
    graph[0].emplace_back(1, 1);
    graph[0].emplace_back(2, 2);
    graph[1].emplace_back(1, 0);
    graph[1].emplace_back(3, 2);
    graph[1].emplace_back(4, 3);
    graph[2].emplace_back(2, 0);
    graph[2].emplace_back(3, 1);
    graph[2].emplace_back(5, 3);
    graph[3].emplace_back(4, 1);
    graph[3].emplace_back(5, 2);
    primMST(graph, V);
    return 0;
}
*/