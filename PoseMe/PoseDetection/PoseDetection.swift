//
//  PoseDetection.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/19/22.
//

import Vision

func bodyPoseHandler(request: VNRequest, width: Int, height: Int) -> [[CGPoint]] {
  guard let observations =
          request.results as? [VNHumanBodyPoseObservation] else {
            return []
          }
  var results:[[CGPoint]] = []
  
  observations.forEach { results.append(processObservation(observation: $0, width: width, height: height)) }
  
  return results
}

func processObservation(observation: VNHumanBodyPoseObservation, width: Int, height: Int) -> [CGPoint]{
  guard let recognizedPoints = try? observation.recognizedPoints(.torso) else { return [] }
  
  let torsoJointNames: [VNHumanBodyPoseObservation.JointName] = [
    .neck,
    .rightShoulder,
    .rightHip,
    .root,
    .leftHip,
    .leftShoulder
  ]
  
  let imagePoints: [CGPoint] = torsoJointNames.compactMap {
    guard let point = recognizedPoints[$0], point.confidence > 0 else { return nil }
    
    return VNImagePointForNormalizedPoint(point.location, width, height)
  }
  
  return imagePoints

}
