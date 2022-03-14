//
//  PosePointDrawing.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/19/22.
//

import CoreGraphics

func posePointDrawing(ctx: CGContext, points: [CGPoint]) {
  points.forEach { ctx.fillEllipse(in: CGRect(x: $0.x, y: $0.y, width: 50, height: 50)) }
}
