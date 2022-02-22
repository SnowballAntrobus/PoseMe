//
//  CatalogView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import SwiftUI

struct CatalogView: View {
  @Binding var poseItems: [PoseItem]
  
    var body: some View {
      NavigationView {
        VStack {
          HStack {
            Text("Catalog")
              .bold()
              .padding()
            Spacer()
            NavigationLink(
              destination: AddPoseItemView(poseItems: $poseItems),
              label: { Text("Add") }
            )
              .padding()
          }
          
          PosesView(poseItems: $poseItems)
            .navigationBarHidden(true)
        }
      }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
      CatalogView(poseItems: .constant([PoseItem(name: "Pose", points: [], image: nil)]))
    }
}
