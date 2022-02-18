//
//  MainView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/17/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
      TabView {
        CaptureView()
          .tabItem { Image(systemName: "camera") }
        CatalogView()
          .tabItem { Image(systemName: "book") }
      }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
