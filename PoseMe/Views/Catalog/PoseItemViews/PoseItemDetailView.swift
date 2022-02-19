//
//  PoseItemDetailView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/19/22.
//

import SwiftUI

struct PoseItemDetailView: View {
  @Binding var poseItem: PoseItem
    var body: some View {
      VStack {
        if let imgData = poseItem.image {
          if let img = UIImage(data: imgData) {
            Image(uiImage: img)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .padding(10)
          }
        } else {
          Image(systemName: "square.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(10)
        }
        Text(poseItem.name)
      }
    }
}

struct PoseItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
      PoseItemDetailView(poseItem: .constant(PoseItem(name: "Pose", points: [], image: nil)))
    }
}
