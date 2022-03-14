//
//  Pose.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 3/14/22.
//

import Foundation
import CoreGraphics

struct Pose: Codable {
  let pointsDict: Dictionary<String, CGPoint?>
  
  init(points: [CGPoint?]) {
    self.pointsDict = [
      "neck": points[0],
      "rightShoulder": points[1],
      "rightElbow": points[2],
      "rightWrist": points[3],
      "rightHip": points[4],
      "rightKnee": points[5],
      "rightAnkle": points[6],
      "root": points[7],
      "leftHip": points[8],
      "leftKnee": points[9],
      "leftAnkle": points[10],
      "leftShoulder": points[11],
      "leftElbow": points[12],
      "leftWrist": points[13]
    ]
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

    let angleDict = [
      "r_neck_elbow":
        angleCosRule(
          p1: self.pointsDict["rightShoulder"]!,
          p2: self.pointsDict["neck"]!,
          p3: self.pointsDict["rightElbow"]!),
      "r_shoulder_wrist":
        angleCosRule(
          p1: self.pointsDict["rightElbow"]!,
          p2: self.pointsDict["rightShoulder"]!,
          p3: self.pointsDict["rightWrist"]!),
      "l_neck_elbow":
        angleCosRule(
          p1: self.pointsDict["leftShoulder"]!,
          p2: self.pointsDict["neck"]!,
          p3: self.pointsDict["leftElbow"]!),
      "l_shoulder_wrist":
        angleCosRule(
          p1: self.pointsDict["leftElbow"]!,
          p2: self.pointsDict["leftShoulder"]!,
          p3: self.pointsDict["leftWrist"]!),
      "r_root_knee":
        angleCosRule(
          p1: self.pointsDict["rightHip"]!,
          p2: self.pointsDict["root"]!,
          p3: self.pointsDict["rightKnee"]!),
      "r_hip_ankle":
        angleCosRule(
          p1: self.pointsDict["rightKnee"]!,
          p2: self.pointsDict["rightHip"]!,
          p3: self.pointsDict["rightAnkle"]!),
      "l_root_knee":
        angleCosRule(
          p1: self.pointsDict["leftHip"]!,
          p2: self.pointsDict["root"]!,
          p3: self.pointsDict["leftKnee"]!),
      "l_hip_ankle":
        angleCosRule(
          p1: self.pointsDict["leftKnee"]!,
          p2: self.pointsDict["leftHip"]!,
          p3: self.pointsDict["leftAnkle"]!),
    ]

    return angleDict
  }
  
}
