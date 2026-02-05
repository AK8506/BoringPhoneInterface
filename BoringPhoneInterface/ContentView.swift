//
//  ContentView.swift
//  BoringPhoneInterface
//
//  Created by Akshay Patnaik on 2/3/26.
//

import SwiftUI

struct ContentView: View {
  // 2 columns grid
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    ZStack {
      // BACKGROUND: Pure Black
      Color.black.edgesIgnoringSafeArea(.all)
      
      ScrollView(showsIndicators: false) {
        VStack(spacing: 40) { // Increased spacing between zones
          
          // MAIN HEADER
          Text("Blubby")
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(Color(white: 0.5)) // Darker gray for the status text
            .padding(.top, 50)
            .padding(.bottom, 10)
          
          // CATEGORIES LOOP
          ForEach(AppData.categories) { category in
            VStack(alignment: .leading, spacing: 15) {
              
              // CATEGORY LABEL
              // Made bigger (size 16) and monospaced
              Text(category.title.uppercased())
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(Color.white) // Brightest white for headers
                .padding(.leading, 2)
              
              // APP GRID
              LazyVGrid(columns: columns, spacing: 15) {
                ForEach(category.apps) { app in
                  AppButton(app: app)
                }
              }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
          }
          
          // FOOTER SPACER
          Spacer(minLength: 80)
        }
      }
    }
    //        .statusBar(hidden: true)
  }
}

// CLICKIES
struct AppButton: View {
  let app: AppItem
  
  var body: some View {
    Button(action: {
      openApp(scheme: app.urlScheme, fallback: app.fallbackURL)
    }) {
      Text(app.name) // Uppercase looks more "technical"
        .font(.system(size: 16, weight: .medium, design: .monospaced)) // Matches headers
        .foregroundColor(Color(white: 0.85)) // Brighter Gray (85% White)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
          // SHARP EDGES: Rectangle with a stroke
          Rectangle()
            .stroke(Color.clear, lineWidth: 1) // Dark gray border
        )
    }
    .buttonStyle(.plain)
  }
  
  func openApp(scheme: String, fallback: String) {
    // 1. Try URL Scheme
    if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
    // 2. Try Fallback URL
    else if let backupURL = URL(string: fallback) {
      UIApplication.shared.open(backupURL)
    }
  }
}

#Preview {
  ContentView()
}
