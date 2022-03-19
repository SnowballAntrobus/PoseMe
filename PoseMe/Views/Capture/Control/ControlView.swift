//
//  ControlView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import SwiftUI

struct ControlView: View {
  @Binding var showPose: Bool
  @Binding var showingCatalog: Bool

  var body: some View {
    VStack {
      HStack(spacing: 12) {
        ToggleButton(selected: $showingCatalog, label: "Catalog")
          .padding()
        Spacer()
        ToggleButton(selected: $showPose, label: "PoseMe")
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

      ControlView(showPose: .constant(false), showingCatalog: .constant(false))
    }
  }
}
