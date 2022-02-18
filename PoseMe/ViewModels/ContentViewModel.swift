//
//  ContentViewModel.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import CoreImage
import Vision

class ContentViewModel: ObservableObject {
  @Published var error: Error?
  @Published var frame: CGImage?

  var poseDetection = false

  private let context = CIContext()

  private let cameraManager = CameraManager.shared
  private let frameManager = FrameManager.shared

  init() {
    setupSubscriptions()
  }

  func setupSubscriptions() {
    cameraManager.$error
      .receive(on: RunLoop.main)
      .map { $0 }
      .assign(to: &$error)

    frameManager.$current
      .receive(on: RunLoop.main)
      .compactMap { buffer in
        guard let cgImage = CGImage.create(from: buffer) else {
          return nil
        }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        if self.poseDetection {
          let requestHandler = VNImageRequestHandler(cgImage: cgImage)
          let poseRequest = VNDetectHumanBodyPoseRequest()
          
          do {
            try requestHandler.perform([poseRequest])
          } catch {
            print("Unable to perform the request: \(error).")
          }
          
          print(self.bodyPoseHandler(request: poseRequest))
          
        }

        return self.context.createCGImage(ciImage, from: ciImage.extent)
      }
      .assign(to: &$frame)
  }
  
  func bodyPoseHandler(request: VNRequest) -> [[CGPoint]] {
    guard let observations =
            request.results as? [VNHumanBodyPoseObservation] else {
              return []
            }
    var results:[[CGPoint]] = []
    
    observations.forEach { results.append(self.processObservation($0)) }
    
    return results
  }
  
  func processObservation(_ observation: VNHumanBodyPoseObservation) -> [CGPoint]{
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
      
      return VNImagePointForNormalizedPoint(point.location, Int(self.frame!.width), Int(self.frame!.height))
    }
    
    return imagePoints

  }
  
}
