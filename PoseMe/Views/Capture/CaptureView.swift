//
//  ContentView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import SwiftUI

struct CaptureView: View {
  @StateObject private var model = CaptureViewModel()
  @Binding var poseItems: [PoseItem]
  
  @State var selectedPose: PoseItem?

  var body: some View {
    ZStack {
      FrameView(image: model.frame)
        .edgesIgnoringSafeArea(.all)

      ErrorView(error: model.error)
      
      ControlView(showPose: $model.poseDetection, poseItems: $poseItems, selectedPose: $selectedPose)
      
      VStack {
        Spacer()
        if selectedPose != nil {
          if model.poseDetection {
            Text(model.fixPoseMessage ?? "ERROR: No message found")
          } else {
            Text("Selected: \(selectedPose?.name ?? "ERROR")")
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
    CaptureView(poseItems: .constant([]))
  }
}
