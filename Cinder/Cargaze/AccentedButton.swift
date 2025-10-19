//
//  Button.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/18/25.
//

import SwiftUI

struct AccentedButton: View {
    var animationDuration: Double = 1.0
    @State var imageName: String
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .ignoresSafeArea()
            .frame(width: 75, height: 75)
    }
}



//#Preview {
//    AccentedButton()
//}
