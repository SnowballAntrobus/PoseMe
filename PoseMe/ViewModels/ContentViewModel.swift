//
//  ContentViewModel.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import CoreImage
import Vision
import SwiftUI

class ContentViewModel: ObservableObject {
  @Published var error: Error?
  @Published var frame: CGImage?

  var poseDetection = false

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
        guard var cgImage = CGImage.create(from: buffer) else {
          return nil
        }
        
        if self.poseDetection {
          let requestHandler = VNImageRequestHandler(cgImage: cgImage)
          let poseRequest = VNDetectHumanBodyPoseRequest()
          
          do {
            try requestHandler.perform([poseRequest])
          } catch {
            print("Unable to perform the request: \(error).")
          }
          
          let posePoints = self.bodyPoseHandler(request: poseRequest)
          
          let ctx = CGContext(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)
          
          ctx!.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
          
          ctx!.setFillColor(UIColor.red.cgColor)
          
          posePoints.first?.forEach { ctx!.fillEllipse(in: CGRect(x: $0.x, y: $0.y, width: 50, height: 50)) }
          
          cgImage = (ctx!.makeImage())!
          
        }

        return cgImage
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
