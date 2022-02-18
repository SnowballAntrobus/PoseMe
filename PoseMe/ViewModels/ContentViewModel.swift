//
//  ContentViewModel.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import CoreImage

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
    // swiftlint:disable:next array_init
    cameraManager.$error
      .receive(on: RunLoop.main)
      .map { $0 }
      .assign(to: &$error)

    frameManager.$current
      .receive(on: RunLoop.main)
      .compactMap { buffer in
        guard let image = CGImage.create(from: buffer) else {
          return nil
        }

        var ciImage = CIImage(cgImage: image)
        
        if self.poseDetection {
              ciImage = ciImage.applyingFilter("CIComicEffect")
            }

        return self.context.createCGImage(ciImage, from: ciImage.extent)
      }
      .assign(to: &$frame)
  }
}
