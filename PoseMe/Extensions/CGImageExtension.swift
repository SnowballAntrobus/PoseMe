//
//  CGImageExtension.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import CoreGraphics
import VideoToolbox

extension CGImage {
  static func create(from cvPixelBuffer: CVPixelBuffer?) -> CGImage? {
    guard let pixelBuffer = cvPixelBuffer else {
      return nil
    }

    var image: CGImage?
    VTCreateCGImageFromCVPixelBuffer(
      pixelBuffer,
      options: nil,
      imageOut: &image)
    return image
  }
}
