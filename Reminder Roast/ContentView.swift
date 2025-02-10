//
//  ContentView.swift
//  Reminder Roast
//
//  Created by Dane Ohr on 2/8/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isOnboardingComplete = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    var body: some View {
        NavigationView{
            VStack{
                if isOnboardingComplete{
                    HomeView()
                } else {
                    OnboardingView()
                }
            }
        } .navigationBarItems(trailing: NavigationLink(destination: SettingsView()){
            Image(systemName: "gearshape.fill")
                .font(.title)
                .padding()
        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

