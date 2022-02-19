//
//  MainView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import SwiftUI

struct MainView: View {
  @Binding var poseItems: [PoseItem]
  @Environment(\.scenePhase) private var scenePhase
  let saveAction: () -> Void
  
    var body: some View {
      TabView {
        CaptureView()
          .tabItem { Image(systemName: "camera") }
        CatalogView(poseItems: $poseItems)
          .tabItem { Image(systemName: "book") }
      }
      .onChange(of: scenePhase) { phase in if phase == .inactive { saveAction() } }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
      MainView(poseItems: .constant([]), saveAction: {})
    }
}
