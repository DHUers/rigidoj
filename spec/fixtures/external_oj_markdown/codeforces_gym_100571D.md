## Description
De Prezer loves troyic paths.Consider we have a graph with n vertices and m edges.Edges are directed in one way.And there is at most one edge from any vertex to any other vertex.If there is an edge from v to u, then c(v, u) is its color and w(v, u) is its length.Otherwise,c(v, u) = w(v, u) =  - 1.

A sequence p1, p2, ..., pk is a troyic path is and only if for each 1 ≤ i ≤ k, 1 ≤ pi ≤ n and if i < k, then c(pi, pi + 1) >  - 1 and if i + 1 < k, then c(pi, pi + 1) ≠ c(pi + 1, pi + 2) .

The length of such troyic path is  and it's called a p1 - pk path.

In such graph, length of the shortest path from vertex v to u is the minimum length of all v - u paths.(The length of the shortest path from any vertex to itself equals 0)

De Prezer gives you a graph like above and a vertex s.

De Prezer also loves query. So he gives you q queries and in each query, gives you number t and you should print the length of the shortest path from s to t (or  - 1 if there is no troyic path from s to t)

## Input
The first line of input contains three integers n and m and C, the number of vertices, the numbers of edges and the number of valid colors.

The next m lines, each line contains 4 integers v, u, w(v, u), c(v, u) (1 ≤ v, u ≤ n and v ≠ u and 1 ≤ w(v, u) ≤ 109 and 1 ≤ c(v, u) ≤ C).

The line after that contains integer s and q.

The next q lines, each line contains information of one query, number t.

1 ≤ n, m, C, q ≤ 105

m ≤ n(n - 1)

1 ≤ s, t ≤ n

## Output
For each query, print the answer.

## Sample test(s)

### Input
```
5 4 1000
1 2 10 1
2 3 10 2
3 4 10 2
4 5 10 1
1 5
1
2
3
4
5
```

### Output
```
0
10
20
-1
-1
```

### Input
```
5 5 2
1 2 10 1
2 3 10 2
3 4 10 1
4 5 10 2
1 5 39 1
1 5
1
2
3
4
5
```

### Output
```
0
10
20
30
39
```

## Remote Url
[Codeforces::Gym 100571D: ShortestPath Query](http://codeforces.com/gym/100571/problem/D)
