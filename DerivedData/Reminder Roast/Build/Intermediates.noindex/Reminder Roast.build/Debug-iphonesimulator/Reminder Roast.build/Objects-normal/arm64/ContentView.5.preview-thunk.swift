import func SwiftUI.__designTimeSelection

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
    var body: some View {
        __designTimeSelection(VStack {
            __designTimeSelection(Image(systemName: __designTimeString("#2610_0", fallback: "globe"))
                .imageScale(.large)
                .foregroundStyle(.tint), "#2610.[1].[0].property.[0].[0].arg[0].value.[0]")
            __designTimeSelection(Text(__designTimeString("#2610_1", fallback: "Hello, world!")), "#2610.[1].[0].property.[0].[0].arg[0].value.[1]")
        }
        .padding(), "#2610.[1].[0].property.[0].[0]")
    }
}

#Preview {
    ContentView()
}
