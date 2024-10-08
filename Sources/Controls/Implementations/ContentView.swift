//
//  ContentView.swift
//  ControlPad
//
//  Created by hansoong on 23/9/24.
//

//import Controls
import SwiftUI

struct XYPadDemoView: View {
    @State var x: Float = 0.5
    @State var y: Float = 0.5
    @State var xPosition: Float = 0.5
    @State var yPosition: Float = 0.5
    @State var sliderValue: Double = 10

    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 20) {
                Text("Controls two parameters in the x- and y-dimensions:\nx: \(x)\ny: \(y)")
                
                VStack(alignment: .center, spacing: 40) {
                    XYPad(x: $x, y: $y, xPosition: $xPosition, yPosition: $yPosition,  xrange: 0...2, yrange: -0.2...0.2)
                            .backgroundColor(.gray.opacity(0.5))
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .indicatorSize(CGSize(width: 20, height: 20))
                            .frame(width: 300, height: 170)
                    
                    CustomSlider(value: $sliderValue, label: "R", defaultValue: 0)
                }
            }
        }
        .navigationTitle("XYPad")
        .padding()
    }
}

