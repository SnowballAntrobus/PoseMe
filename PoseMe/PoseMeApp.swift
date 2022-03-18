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
    
  var body: some Scene {
    WindowGroup {
      MainView(poseItems: $poseItems.data) {
          poseItems.save()
      }
      .onAppear {
          poseItems.load()
          
      }
    }
  }
    
}
