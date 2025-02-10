import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/ContentView.swift", line: 1)
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
            Image(systemName: __designTimeString("#4140_0", fallback: "gearshape.fill"))
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

