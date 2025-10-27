//
//  Background.swift
//  FinanceTracker
//
//  Created by Ryan on 27/10/2025.
//

import SwiftUI

struct Background: View {
    var body: some View {
        ZStack {
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.5, 1.0], [0.7, 0.5], [1.0, 0.7],
                    [0.0, 1.0], [0.0, 0.5], [0.0, 0.5]
                ],
                colors: [
                    .teal, .purple, .indigo,
                    .purple, .blue, .pink,
                    .purple, .red, .purple
                ]
            )
            .ignoresSafeArea()
            .shadow(color: .gray, radius: 25, x: -10, y: 10)
        }
    }
}

#Preview {
    Background()
}
