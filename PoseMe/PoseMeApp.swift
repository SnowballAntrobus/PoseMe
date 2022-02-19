//
//  PoseMeApp.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import SwiftUI

@main
struct PoseMeApp: App {
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
