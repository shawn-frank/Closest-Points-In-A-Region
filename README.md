# Closest points in a region using Swift
Find the closest pair of CGPoints that exist in a region. This was created in response to this question: https://stackoverflow.com/questions/70844120/find-points-between-two-cgpoints/70845089

For example, here is the input you have:

```
let pointsArray = [(10.0, 10.0), (70.0, 10.0), (10.0, 200.0), (70.0, 200.0), (73.0, 10.0), (133.0, 10.0), (73.0, 200.0), (133.0, 200.0), (135.5, 10.0), (195.5, 10.0), (135.5, 200.0), (195.5, 200.0), (198.5, 10.0), (258.5, 10.0), (198.5, 200.0), (258.5, 200.0), (261.5, 10.0), (321.5, 10.0), (261.5, 200.0), (321.5, 200.0), (324.0, 10.0), (384.0, 10.0), (324.0, 200.0), (384.0, 200.0), (387.0, 10.0), (447.0, 10.0), (387.0, 200.0), (447.0, 200.0), (450.0, 10.0), (510.0, 10.0), (450.0, 200.0), (510.0, 200.0), (512.5, 10.0), (572.5, 10.0), (512.5, 200.0), (572.5, 200.0), (575.5, 10.0), (635.5, 10.0), (575.5, 200.0), (635.5, 200.0), (638.5, 10.0), (698.5, 10.0), (638.5, 200.0), (698.5, 200.0), (701.0, 10.0), (761.0, 10.0), (701.0, 200.0), (761.0, 200.0), (764.0, 10.0), (824.0, 10.0), (764.0, 200.0), (824.0, 200.0), (10.0, 390.0), (70.0, 390.0), (73.0, 390.0), (133.0, 390.0), (135.5, 390.0), (195.5, 390.0), (198.5, 390.0), (258.5, 390.0), (261.5, 390.0), (321.5, 390.0), (324.0, 390.0), (384.0, 390.0), (387.0, 390.0), (447.0, 390.0), (450.0, 390.0), (510.0, 390.0), (512.5, 390.0), (572.5, 390.0), (575.5, 390.0), (635.5, 390.0), (638.5, 390.0), (698.5, 390.0), (701.0, 390.0), (761.0, 390.0), (764.0, 390.0), (824.0, 390.0), (10.0, 580.0), (70.0, 580.0), (73.0, 580.0), (133.0, 580.0), (135.5, 580.0), (195.5, 580.0), (198.5, 580.0), (258.5, 580.0)]

let startPoint = CGPoint(x: 80, y: 20)
let endPoint = CGPoint(x: 170, y: 440)
```

A region is defined as follows in the iOS coordinate system with the top left being 0,0:

![image](https://user-images.githubusercontent.com/80219691/151209372-387abde2-39b7-4566-ab36-8d96da45ef75.png)

However, the below logic will work in other 2D coordinate systems where the bottom left is 0, 0 for instance

So to define a valid region, here are the rules:
- the start x and start y will be <= end x and end y.
- Start and end can be a straight line
- Start and end can be the same point
- But end cannot be below or to the left of start

# Approach

- Filter the array to get an array of only valid points that fall in the region
- Get the distances between the valid points in the region
- Option 1: is sort the distances array to get the closest pair in O(n log n)
- Option 2: would be to use a min heap to get the closest pair in O(n)

A swift implementation of Heap can be taken from: https://github.com/shawn-frank/Swift-Data-Structures-And-Algorithms/tree/production/Heap

