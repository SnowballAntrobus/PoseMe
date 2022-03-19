//
//  PoseMeApp.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import SwiftUI
import Firebase


@main
struct PoseMeApp: App {
  init(){
    FirebaseApp.configure()
  }
  @ObservedObject private var poseItems = PoseItems()
  @StateObject private var model = CaptureViewModel()
    
  var body: some Scene {
    WindowGroup {
      MainView(poseItems: $poseItems.data) {
          poseItems.save()
      }
      .environmentObject(model)
      .onAppear {
          poseItems.load()
          
      }
    }
  }
    
}
