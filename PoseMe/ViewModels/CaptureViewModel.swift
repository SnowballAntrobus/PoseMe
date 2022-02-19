//
//  ContentViewModel.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import CoreImage
import Vision
import SwiftUI

class CaptureViewModel: ObservableObject {
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
          
          if let f = self.frame {
            let posePoints = bodyPoseHandler(request: poseRequest, width: Int(f.width), height: Int(f.height))
            
            if let ctx = cgImage.copyContext() {
              ctx.setFillColor(UIColor.blue.cgColor)
              
              if let points = posePoints.first {
                posePointDrawing(ctx: ctx, points: points)
                
                if let img = ctx.makeImage() {
                  cgImage = img
                }
              }
            }
          }
        }

        return cgImage
      }
      .assign(to: &$frame)
  }
}
