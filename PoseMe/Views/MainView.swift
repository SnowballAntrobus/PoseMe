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
  @State var showingCatalog = false
  let saveAction: () -> Void
  
    var body: some View {
      CaptureView(poseItems: $poseItems, showingCatalog: $showingCatalog)
      
        .sheet(isPresented: $showingCatalog) {
          CatalogView(poseItems: $poseItems, showingCatalog: $showingCatalog)
        }
        
        
      .onChange(of: scenePhase) { phase in if phase == .inactive { saveAction() } }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
      MainView(poseItems: .constant([PoseItem(name: "Pose", points: [], image: nil)]), saveAction: {})
    }
}
