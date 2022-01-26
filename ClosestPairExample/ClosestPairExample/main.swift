//
//  main.swift
//  ClosestPairExample
//
//  Created by Shawn Frank on 25/01/2022.
//

import Foundation

struct PointPair: Comparable, Hashable
{
    private(set) var startPoint = CGPoint.zero
    private(set) var endPoint = CGPoint.zero
    private(set) var distance = CGFloat.zero
    
    init(withStartPoint start: CGPoint, andEndPoint end: CGPoint)
    {
        startPoint = start
        endPoint = end
        distance = startPoint.distance(to: endPoint)
        
        // Just for convenience
        display()
    }
    
    func display()
    {
        print("Distance (\(startPoint.x), \(startPoint.y)) and (\(endPoint.x), \(endPoint.y)): \(distance)")
    }
    
    // Needed to implement this so that we conform to Comparable and
    // can compare 2 points
    static func < (lhs: PointPair, rhs: PointPair) -> Bool
    {
        return lhs.distance < rhs.distance
    }
    
    // Need to implement this to conform to Hashable so we can insert a PointPair
    // into dictionaries and data structures that work with Hashable types
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(startPoint.x)
        hasher.combine(startPoint.y)
        hasher.combine(endPoint.x)
        hasher.combine(endPoint.y)
    }
}

extension CGPoint
{
    func distance(to point: CGPoint) -> CGFloat
    {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
    
    
    /// Checks if the current point exists in a region. The x and y coordinate of
    /// `regionStart` has  to be less than or equal to `regionEnd` for a
    /// valid check to occur.
    /// - Parameters:
    ///   - regionStart: The top left of the region
    ///   - regionEnd: The bottom right of the region
    /// - Returns: True if the current point falls within the region
    func doesExistInRegion(regionStart: CGPoint, regionEnd: CGPoint) -> Bool
    {
        // Check if we have an invalid region
        if regionStart.x > regionEnd.x || regionStart.y > regionEnd.y
        {
            return false
        }
        
        // Check if the current point is outside the region
        if x < regionStart.x ||
            y < regionStart.y ||
            x > regionEnd.x ||
            y > regionEnd.y
        {
            return false
        }
        
        // The point is within the region
        return true
    }
}

let pointsArray = [(0.1, 10.0), (70.0, 10.0), (10.0, 200.0), (70.0, 200.0), (73.0, 10.0), (133.0, 10.0), (73.0, 200.0), (133.0, 200.0), (135.5, 10.0), (195.5, 10.0), (135.5, 200.0), (195.5, 200.0), (198.5, 10.0), (258.5, 10.0), (198.5, 200.0), (258.5, 200.0), (261.5, 10.0), (321.5, 10.0), (261.5, 200.0), (321.5, 200.0), (324.0, 10.0), (384.0, 10.0), (324.0, 200.0), (384.0, 200.0), (387.0, 10.0), (447.0, 10.0), (387.0, 200.0), (447.0, 200.0), (450.0, 10.0), (510.0, 10.0), (450.0, 200.0), (510.0, 200.0), (512.5, 10.0), (572.5, 10.0), (512.5, 200.0), (572.5, 200.0), (575.5, 10.0), (635.5, 10.0), (575.5, 200.0), (635.5, 200.0), (638.5, 10.0), (698.5, 10.0), (638.5, 200.0), (698.5, 200.0), (701.0, 10.0), (761.0, 10.0), (701.0, 200.0), (761.0, 200.0), (764.0, 10.0), (824.0, 10.0), (764.0, 200.0), (824.0, 200.0), (10.0, 390.0), (70.0, 390.0), (73.0, 390.0), (133.0, 390.0), (135.5, 390.0), (195.5, 390.0), (198.5, 390.0), (258.5, 390.0), (261.5, 390.0), (321.5, 390.0), (324.0, 390.0), (384.0, 390.0), (387.0, 390.0), (447.0, 390.0), (450.0, 390.0), (510.0, 390.0), (512.5, 390.0), (572.5, 390.0), (575.5, 390.0), (635.5, 390.0), (638.5, 390.0), (698.5, 390.0), (701.0, 390.0), (761.0, 390.0), (764.0, 390.0), (824.0, 390.0), (10.0, 580.0), (70.0, 580.0), (73.0, 580.0), (133.0, 580.0), (135.5, 580.0), (195.5, 580.0), (198.5, 580.0), (258.5, 580.0)]

let startPoint = CGPoint(x: 80, y: 20)
let endPoint = CGPoint(x: 170, y: 440)

let validPoints = extractValidPoints()

print("Valid points")

for point in validPoints
{
    print(point)
}

if let nearestPoint = retrieveClosestPairUsingSort(fromPoints: validPoints)
{
    print("The nearest pair using sort O(n log n) is")
    print(nearestPoint.display())
}

if let nearestPoint = retrieveClosestPairUsingHeap(fromPoints: validPoints)
{
    print("The nearest pair using heap O(log n) is")
    print(nearestPoint.display())
}

private func extractValidPoints() -> [CGPoint]
{
    var validPoints: [CGPoint] = []
    
    for point in pointsArray
    {
        let coordinate = CGPoint(x: point.0, y: point.1)
        
        if coordinate.doesExistInRegion(regionStart: startPoint, regionEnd: endPoint)
        {
            validPoints.append(coordinate)
        }
    }
    
    return validPoints
}


private func retrieveClosestPairUsingSort(fromPoints points: [CGPoint]) -> PointPair?
{
    var pairs: [PointPair] = []
    
    // Loop through all the points
    for index in 0 ..< points.count
    {
        for secondIndex in index + 1 ..< points.count
        {
            let pointPair = PointPair(withStartPoint: points[index],
                                      andEndPoint: points[secondIndex])
            
            pairs.append(pointPair)
        }
    }
    
    return pairs.sorted().first
}

private func retrieveClosestPairUsingHeap(fromPoints points: [CGPoint]) -> PointPair?
{
    // Instantiate a min heap so the root will be the closest pair
    var heap = Heap<PointPair>(withProperty: .min)
    
    // Loop through all the points
    for index in 0 ..< points.count
    {
        for secondIndex in index + 1 ..< points.count
        {
            let pointPair = PointPair(withStartPoint: points[index],
                                      andEndPoint: points[secondIndex])
            
            heap.insert(pointPair)
        }
    }
    
    return heap.peek()
}

