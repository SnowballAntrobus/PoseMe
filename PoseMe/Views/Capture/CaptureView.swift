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

  var body: some View {
    ZStack {
      FrameView(image: model.frame)
        .edgesIgnoringSafeArea(.all)

      ErrorView(error: model.error)
      
      ControlView(poseSelected: $model.poseDetection, poseItems: $poseItems)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    CaptureView(poseItems: .constant([]))
  }
}
