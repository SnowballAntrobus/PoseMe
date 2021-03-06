//
//  CatalogView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import SwiftUI

struct CatalogView: View {
  @Binding var poseItems: [PoseItem]
  @Binding var showingCatalog: Bool
  
    var body: some View {
      NavigationView {
        VStack {
          HStack {
            Spacer()
            Text("Catalog")
              .bold()
            Spacer()
          }
          
          PosesView(poseItems: $poseItems, showingCatalog: $showingCatalog)
          NavigationLink(
            destination: AddPoseItemView(poseItems: $poseItems, showingCatalog: $showingCatalog),
            label: { Text("Add") }
          )
          
        }
      }
      
    }
}

//struct CatalogView_Previews: PreviewProvider {
//    static var previews: some View {
//      CatalogView(poseItems: .constant([PoseItem(name: "Pose", points: [CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1), CGPoint(1,1)], image: nil)]))
//    }
//}
