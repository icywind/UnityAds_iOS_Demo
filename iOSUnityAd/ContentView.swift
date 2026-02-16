//
//  ContentView.swift
//  iOSUnityAd
//
//  Created by Rick Cheng on 2/15/26.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var adsManager = UnityAdsManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "dollarsign.circle")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Unity Ads Demo")
                .font(.title)
            
            // Ad Status Display
            Text(adsManager.adState)
                .font(.headline)
                .foregroundColor(adsManager.isAdReady ? .green : .secondary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            // Ad Buttons
            HStack(spacing: 20) {
                Button(action: {
                    adsManager.loadAd()
                }) {
                    Text("Load Ad")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 44)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    adsManager.showAd()
                }) {
                    Text("Show Ad")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 44)
                        .background(adsManager.isAdReady ? Color.green : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!adsManager.isAdReady)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            // Get the root view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                adsManager.setViewController(rootVC)
            }
            adsManager.initialize()
        }
    }
}

#Preview {
    ContentView()
}
