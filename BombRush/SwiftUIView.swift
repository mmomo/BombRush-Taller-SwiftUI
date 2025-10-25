//
//  SwiftUIView.swift
//  BombRush
//
//  Created by César Venzor on 22/10/25.
//

import SwiftUI

struct SwiftUIView: View {
    
    var body: some View {
        VStack {
            Text("Hola")
                .font(.largeTitle)
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Button("Iniciar sesión") {
                print("Iniciar sesión")
            }
        }
    }
}

#Preview {
    SwiftUIView()
}
