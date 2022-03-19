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
  @Published var selectedPose: PoseItem?
  @Published var fixPoseMessage: String?

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
          let posePoints = runPoseDetection(cgImage: cgImage)
          if let ctx = cgImage.copyContext() {
            ctx.setFillColor(UIColor.blue.cgColor)
              
            if let points = posePoints.first {
              if points.count == 14 {
                let currentPose = Pose(points: points)
                if let spose = self.selectedPose {
                  if let pose = spose.pose{
                    self.fixPoseMessage = fixPose(currentPose: currentPose, groudTruthPose: pose)
                  } else {
                    print("ERROR: selected pose does not exist")
                  }
                }
              } else {
                self.fixPoseMessage = "Move Back - \(points.count) out of 14 found)"
              }
              
              posePointDrawing(ctx: ctx, points: points)
                
              if let img = ctx.makeImage() {
                cgImage = img
              }
            }
          }
        }

        return cgImage
      }
      .assign(to: &$frame)
  }
}
