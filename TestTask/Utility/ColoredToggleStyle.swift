//
//  BlueToggleStyle.swift
//  TestTask
//
//  Created by Anna Ovchynnykova on 19.10.2022.
//

import SwiftUI

struct ColoredToggleStyle: ToggleStyle {
    private var switchedOnColor: Color
    private var switchedOffColor: Color
    
    init(_ onColor:Color, _ offColor: Color) {
        switchedOnColor = onColor
        switchedOffColor = offColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? switchedOnColor: switchedOffColor)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.blue)
                        .padding(.all, 3)
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.linear(duration: 0.1))
                    
                )
                .cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
