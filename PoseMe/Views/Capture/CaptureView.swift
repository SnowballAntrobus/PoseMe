//
//  ContentView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import SwiftUI

struct CaptureView: View {
  @EnvironmentObject var model: CaptureViewModel
  @Binding var poseItems: [PoseItem]
  @Binding var showingCatalog: Bool

  var body: some View {
    ZStack {
      FrameView(image: model.frame)
        .edgesIgnoringSafeArea(.all)

      ErrorView(error: model.error)
      
      ControlView(showPose: $model.poseDetection, showingCatalog: $showingCatalog)
      
      VStack {
        Spacer()
        if model.selectedPose != nil {
          if model.poseDetection {
            Text(model.fixPoseMessage ?? "ERROR: No message found")
              .font(.system(size: 45, weight: .bold, design: .default))
          } else {
            Text("Selected: \(model.selectedPose?.name ?? "ERROR")")
            Text("press the PoseMe button to continue")
          }
        } else {
          Text("Go to the catalog and select a pose")
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    CaptureView(poseItems: .constant([]), showingCatalog: .constant(false))
  }
}
