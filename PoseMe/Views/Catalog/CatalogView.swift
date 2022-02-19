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
      VStack {
        HStack {
          Spacer()
          Button(action: {}, label: { Text("Add") })
            .padding()
        }
        
        PosesView(poseItems: $poseItems)
      }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
      CatalogView(poseItems: .constant([]))
    }
}
