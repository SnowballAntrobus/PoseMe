//
//  CGImageExtension.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import CoreGraphics
import VideoToolbox
import ImageIO

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

extension CGImage {
  func copyContext() -> CGContext? {
    if let ctx = CGContext(
      data: nil,
      width: self.width,
      height: self.height,
      bitsPerComponent: self.bitsPerComponent,
      bytesPerRow: self.bytesPerRow,
      space: self.colorSpace!,
      bitmapInfo: self.bitmapInfo.rawValue)
    {
      ctx.draw(self, in: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        return ctx
    } else {
      return nil
    }
  }
}

extension CGImage {
    var data: Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}
