//
//  Slider.swift
//  ControlPad
//
//  Created by hansoong on 24/9/24.
//

import Foundation
import SwiftUI
//
public struct CustomSlider : View {
    var label:String
    var defaultValue:Double
    @Binding var value:Double
    var range: (Double, Double)
    var rangeDisplay: (Double, Double)
    var decimalPlace : Int
    var formatString : String
    
    public init(value: Binding<Double>, range: (Double, Double) = (0, 100), label:String = "",
         defaultValue: Double, rangeDisplay: (Double, Double) = (-100, 100), decimalPlace: Int = 0)
    {
        _value = value
        self.range = range
        self.label = label
        self.defaultValue = defaultValue
        self.rangeDisplay = rangeDisplay
        self.decimalPlace = decimalPlace
        self.formatString = "%.\(decimalPlace)f"
    }
    
    public var body: some View{
        
        VStack(spacing: 5){
            HStack{
                if !label.isEmpty{
                    Text(label)
                }
                Spacer()
                Text(String(format: formatString, value))
            }
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.white)
            
            SliderControl(value: $value, defaultValue: defaultValue ,range: range) { modifiers in
                ZStack {
                    Color.gray.opacity(0.5)
                        .cornerRadius(2)
                        .frame(height: 3.5).modifier(modifiers.bar)
                    ZStack {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 15, height: 15)
                        
                    }.modifier(modifiers.knob)
                }
            }
            .frame(height: 15)
        }
    }
    
    func displayValue(_ value:Double) -> String{
        return String(format: "%.0f", value.convert(fromRange: range, toRange: rangeDisplay))
    }
}
