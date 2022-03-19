//
//  Pose.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 3/14/22.
//

import Foundation
import CoreGraphics

struct Pose: Codable {
  var pointsDict: Dictionary<String, CGPoint?>
  
  init(points: [CGPoint?]) {
    self.pointsDict = [:]
    pointsDict["neck"] = points[0]
    pointsDict["rightShoulder"] = points[1]
    pointsDict["rightElbow"] = points[2]
    pointsDict["rightWrist"] = points[3]
    pointsDict["rightHip"] = points[4]
    pointsDict["rightKnee"] = points[5]
    pointsDict["rightAnkle"] = points[6]
    pointsDict["root"] = points[7]
    pointsDict["leftHip"] = points[8]
    pointsDict["leftKnee"] = points[9]
    pointsDict["leftAnkle"] = points[10]
    pointsDict["leftShoulder"] = points[11]
    pointsDict["leftElbow"] = points[12]
    pointsDict["leftWrist"] = points[13]
  }
  
  func getAngleDict() -> Dictionary<String, Double?>{

    func angleCosRule(p1: CGPoint?, p2: CGPoint?, p3: CGPoint?) -> Double? {
      func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
      }
      if let point1 = p1, let point2 = p2, let point3 = p3 {
        return rad2deg(atan2(point3.y-point1.y, point3.x-point1.x) - atan2(point2.y-point1.y, point2.x-point1.x))
      }
      else {
        return nil
      }
    }

    var angleDict: Dictionary<String, Double?> = [:]
      angleDict["r_neck_elbow"] =
        angleCosRule(
          p1: self.pointsDict["rightShoulder"]!,
          p2: self.pointsDict["neck"]!,
          p3: self.pointsDict["rightElbow"]!)
    angleDict["r_shoulder_wrist"] =
        angleCosRule(
          p1: self.pointsDict["rightElbow"]!,
          p2: self.pointsDict["rightShoulder"]!,
          p3: self.pointsDict["rightWrist"]!)
    angleDict["l_neck_elbow"] =
        angleCosRule(
          p1: self.pointsDict["leftShoulder"]!,
          p2: self.pointsDict["neck"]!,
          p3: self.pointsDict["leftElbow"]!)
    angleDict["l_shoulder_wrist"] =
        angleCosRule(
          p1: self.pointsDict["leftElbow"]!,
          p2: self.pointsDict["leftShoulder"]!,
          p3: self.pointsDict["leftWrist"]!)
    angleDict["r_root_knee"] =
        angleCosRule(
          p1: self.pointsDict["rightHip"]!,
          p2: self.pointsDict["root"]!,
          p3: self.pointsDict["rightKnee"]!)
    angleDict["r_hip_ankle"] =
        angleCosRule(
          p1: self.pointsDict["rightKnee"]!,
          p2: self.pointsDict["rightHip"]!,
          p3: self.pointsDict["rightAnkle"]!)
    angleDict["l_root_knee"] =
        angleCosRule(
          p1: self.pointsDict["leftHip"]!,
          p2: self.pointsDict["root"]!,
          p3: self.pointsDict["leftKnee"]!)
    angleDict["l_hip_ankle"] =
        angleCosRule(
          p1: self.pointsDict["leftKnee"]!,
          p2: self.pointsDict["leftHip"]!,
          p3: self.pointsDict["leftAnkle"]!)

    return angleDict
  }
  
}

//extension Pose {
//    static var data: [Pose] {
//        [
//            Pose(points: CGPoint),
//        ]
//    }
//}
