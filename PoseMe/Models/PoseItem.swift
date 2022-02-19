//
//  PoseItem.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/19/22.
//

import Foundation
import CoreGraphics

struct PoseItem: Identifiable, Codable {
  var id: UUID
  var name: String
  var points: [CGPoint]
  var image: Data?
  
  init(id: UUID = UUID(), name: String, points: [CGPoint], image: CGImage?) {
    self.id = id
    self.name = name
    self.points = points
    if let img = image {
      self.image = img.data
    }
  }
}