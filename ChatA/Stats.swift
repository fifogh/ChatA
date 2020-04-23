//
//  stats.swift
//  ChatA
//
//  Created by Philippe Faurie on 4/7/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import Foundation


var centers : [Int] = Array()     // set by getOutliers; used by Kmean as initial values



//------------------------------------------
// Class:
// Extension to Int to calculate distance
//
extension Int  {
    
    func distanceTo ( pt: Int) -> Int {
        
        return abs (self - pt)
        
    }
}


//------------------------------------------
// Class:
// Clusterize a set of points
//
class KMeans<Label: Hashable> {

  let numCenters: Int
  let labels: [Label]
  private(set) var centroids = [Int]()

  init(labels: [Label]) {
    assert(labels.count > 1, "Exception: KMeans with less than 2 centers.")
    self.labels = labels
    self.numCenters = labels.count
  }

  //---------------------------------------------------------------
  // Func:
  // return index in Center Array for which point is the closest
  //
  private func indexOfNearestCenter(_ x: Int, centers: [Int]) -> Int {
    var nearestDist = Int.max  //  max value of Int
    
    var minIndex = 0

    for (idx, center) in centers.enumerated() {
      let dist = x.distanceTo(pt:center)
      if dist < nearestDist {
        minIndex = idx
        nearestDist = dist
      }
    }
    return minIndex
  }
    
    
   //---------------------------------------------------------------
   // Func:
   // implements the K-Mean algo.
   //
   func trainCenters(_ points: [Int], convergeDistance: Double) -> [Int] {

    var clusters : [[Int]]
    
    var centerMoveDist = 0
    
    repeat {
      // This array keeps track of which data points belong to which centroids.
      var classification: [[Int]] = .init(repeating: [], count: numCenters)

      // For each data point, find the centroid that it is closest to.
      for p in points {
        let classIndex = indexOfNearestCenter(p, centers: centers)
        classification[classIndex].append(p)
      }

      // Take the average of all the data points that belong to each centroid.
      // This moves the centroid to a new position.
      let newCenters = classification.map { assignedPoints in
        assignedPoints.reduce(0, +) / Int(assignedPoints.count)
      }

      // Find out how far each centroid moved since the last iteration. If it's
      // only a small distance, then we're done.
      centerMoveDist = 0

      for idx in 0..<numCenters {
        centerMoveDist += centers[idx].distanceTo(pt:newCenters[idx])
        //let max = classification[idx].max()
       }

      centers = newCenters
        
     clusters = classification
    } while centerMoveDist > Int (convergeDistance)

    centroids = centers
    print (centroids)
    
    print (clusters)
    return (centroids)
  }
/*
  func fit(_ point: Int) -> Label {
    assert(!centroids.isEmpty, "Exception: KMeans tried to fit on a non trained model.")

    let centroidIndex = indexOfNearestCenter(point, centers: centroids)
    return labels[centroidIndex]
  }

  func fit(_ points: [Int]) -> [Label] {
    assert(!centroids.isEmpty, "Exception: KMeans tried to fit on a non trained model.")

    return points.map(fit)
  }
 */
}
/*
// Pick k random elements from samples
func reservoirSample<T>(_ samples: [T], k: Int) -> [T] {
  var result = [T]()

  // Fill the result array with first k elements
  for i in 0..<k {
    result.append(samples[i])
  }

  // Randomly replace elements from remaining pool
  for i in k..<samples.count {
    let j = Int(arc4random_uniform(UInt32(i + 1)))
    if j < k {
      result[j] = samples[i]
    }
  }
   // print (result)
  return result
 }
*/
// aaray should be sorted




//---------------------------------------------------------------
// Func:
// get list of outliers
//
/*
Sort a list of integers, from low to high
Split a list of integers into 2 parts (by a middle) and put them into 2 new separate ArrayLists (call them "left" and "right")
Find a middle number (median) in both of those new ArrayLists
Q1 is a median from left side, and Q3 is the median from the right side
Applying mathematical formula:
IQR = Q3 - Q1
LowerFence = Q1 - 1.5*IQR
UpperFence = Q3 + 1.5*IQR
More info about this formula: http://www.mathwords.com/o/outlier.htm
Loop through all of my original elements, and if any of them are lower than a lower fence, or higher than an upper fence, add them to "output" ArrayList
This new "output" ArrayList contains the outliers
*/

  func getOutliers(input: [Int])-> [Int] {
    
    var output = [Int]();
    var data1  : Array <Int> = Array()
    var data2  : Array <Int> = Array()
    
    
    // split array in 2 (in the middle)
    var stop: Int
    if (input.count % 2 == 0) {
        stop = input.count / 2
    }else {
        stop = (input.count / 2) + 1
    }
    
    for (idx, elem) in input.enumerated() {
        if (idx < stop){
            data1.append(elem)
        } else {
            data2.append(elem)
        }
    }
    
    print ("data1; \(data1)")
   print ("data2; \(data2)")

    
    let q1 = Double( getMedian(data: data1) );
    let q3 = Double( getMedian(data: data2) );
    
    // Initial value for KMean
    centers.removeAll()
    centers.append(Int(q1))
    
  //  let other = (data2[0])
  //   centers.append(other)
    
    centers.append(Int(q3))


    let iqr = q3 - q1;
    let lowerFence = q1 - 1.5 * iqr;
    let upperFence = q3 + 1.5 * iqr;
    
    for i in 0...input.count-1 {
        
        if ( (Double(input[i]) < lowerFence) || (Double(input[i]) > upperFence)) {
             output.append(input[i])
        }
           
    }
    print ("outliers: \(output)")
    return output;
  }

  func getMedian( data: [Int]) -> Int  {
    
      var median: Int
      if (data.count % 2 == 0) {
          median = ( data [data.count / 2] + data [data.count / 2 - 1]) / 2
      }else {
          median = data [data.count / 2]
      }
    
    return median
  }


func getKMean (distances: [Int]) -> Double {
   
    // Sort + remove ourliers
    let distanceL = distances.sorted()
    let outLiersL = getOutliers(input: distanceL)
    let cleanDistanceL = distanceL.filter { element in return !outLiersL.contains(element)}
    
    // clusterize and return smaller centroid
    let kmeans = KMeans(labels:["UN", "DEUX"])      // need 2 clusters
    let centroids = kmeans.trainCenters( cleanDistanceL, convergeDistance: 3)
    return  (Double(min (Int(centroids [0]), Int(centroids [1]))))
    
}

