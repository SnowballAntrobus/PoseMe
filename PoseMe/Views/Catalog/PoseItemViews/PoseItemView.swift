//
//  PoseItemView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/19/22.
//

import SwiftUI

struct PoseItemView: View {
  let poseItem: PoseItem
    var body: some View {
      HStack {
        if let imgData = poseItem.image {
          if let img = UIImage(data: imgData) {
            Image(uiImage: img)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 50, height: 50)
              .padding(10)
          }
        } else {
          Image(systemName: "square.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .padding(10)
        }
        Text(poseItem.name)
      }
  }
}

struct PoseItemView_Previews: PreviewProvider {
    static var previews: some View {
        PoseItemView(poseItem: PoseItem(name: "Pose", points: [CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1)], image: nil))
    }
}
