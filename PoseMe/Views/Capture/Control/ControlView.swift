//
//  ControlView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import SwiftUI

struct ControlView: View {
  @Binding var poseSelected: Bool

  var body: some View {
    VStack {
      HStack(spacing: 12) {
        Spacer()
        ToggleButton(selected: $poseSelected, label: "Pose")
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

      ControlView(poseSelected: .constant(false))
    }
  }
}
