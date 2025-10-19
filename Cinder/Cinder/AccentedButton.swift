//
//  Button.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/18/25.
//

import SwiftUI

struct AccentedButton: View {
    private var animationDuration: Double = 1.0
    var body: some View {
        Image("ButtonAccent1")
            .resizable()
            .scaledToFit()
            .ignoresSafeArea()
            .frame(width: 75, height: 75)
    }
}



#Preview {
    AccentedButton()
}
