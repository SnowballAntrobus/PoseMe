//
//  ControlView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import SwiftUI

struct ControlView: View {
  @Binding var poseSelected: Bool
  @Binding var poseItems: [PoseItem]

  var body: some View {
    VStack {
      HStack(spacing: 12) {
        NavigationLink(
          destination: CatalogView(poseItems: $poseItems),
          label: { Image(systemName: "book") }
        )
          .padding()
        Spacer()
        ToggleButton(selected: $poseSelected, label: "PoseMe")
          .padding()
      }
      
      Spacer()
    }
  }
}

struct ControlView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.black
        .edgesIgnoringSafeArea(.all)

      ControlView(poseSelected: .constant(false), poseItems: .constant([]))
    }
  }
}
