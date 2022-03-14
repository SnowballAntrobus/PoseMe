//
//  CatalogView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import SwiftUI

struct CatalogView: View {
  @Binding var poseItems: [PoseItem]
  @Binding var selectedPose: PoseItem?
  
    var body: some View {
        VStack {
          HStack {
            Spacer()
            Text("Catalog")
              .bold()
            Spacer()
          }
          
          PosesView(poseItems: $poseItems, selectedPose: $selectedPose)
          NavigationLink(
            destination: AddPoseItemView(poseItems: $poseItems),
            label: { Text("Add") }
          )
          
        }
    }
}

//struct CatalogView_Previews: PreviewProvider {
//    static var previews: some View {
//      CatalogView(poseItems: .constant([PoseItem(name: "Pose", points: [CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1)], image: nil)]))
//    }
//}
