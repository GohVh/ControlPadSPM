//
//  TwoParameterControl.swift
//  ControlPad
//
//  Created by hansoong on 23/9/24.
//
import SwiftUI

/// A view in which dragging on it will change bound variables and perform closures
public struct TwoParameterControl<Content: View>: View {
    let content: (GeometryProxy) -> Content
    var geometry: PlanarGeometry
    @Binding var xPosition: Float
    @Binding var yPosition: Float
    @Binding var value1: Float
    @Binding var value2: Float
    var range1: ClosedRange<Float>
    var range2: ClosedRange<Float>
    var padding: CGSize
    
    @State var hasStarted = false
    @State var rect: CGRect = .zero
    
    @State var touchLocation: CGPoint = .zero {
        didSet {
            ((xPosition, yPosition) , (value1, value2)) = geometry.calculateValuePair(
                value1: value1,
                value2: value2,
                xPosition: xPosition,
                yPosition: yPosition,
                range1: range1,
                range2: range2,
                from: oldValue,
                to: touchLocation,
                inRect: rect,
                padding: padding)
        }
    }
    
    /// Initialize the draggable
    /// - Parameters:
    ///   - geometry: Gesture movement geometry specification
    ///   - value1: First value that is controlled
    ///   - value2: Second value that is controlled
    ///   - onStarted: Closure to perform when the drag starts
    ///   - onEnded: Closure to perform when the drag finishes
    ///   - content: View to render
    public init(value1: Binding<Float>,
                value2: Binding<Float>,
                range1: ClosedRange<Float> = 0 ... 1,
                range2: ClosedRange<Float> = 0 ... 1,
                xPosition: Binding<Float>,
                yPosition: Binding<Float>,
                geometry: PlanarGeometry = .rectilinear,
                padding: CGSize = .zero,
                @ViewBuilder content: @escaping (GeometryProxy) -> Content)
    {
        self.geometry = geometry
        _value1 = value1
        _value2 = value2
        _xPosition = xPosition
        _yPosition = yPosition
        self.range1 = range1
        self.range2 = range2
        self.content = content
        self.padding = padding
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack{
                content(proxy)
            }
            .gesture(
                DragGesture(minimumDistance: 0.5)
                    .onChanged({ value in
                        touchLocation = CGPoint(x: value.location.x, y: value.location.y)
                    })
            )
            .onAppear {
                rect = proxy.frame(in: .local)
            }
            .onChange(of: proxy.size) { oldValue, newValue in
                rect = proxy.frame(in: .local)
            }
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded({
                        // Reset to initial position on double tap
                        touchLocation = CGPoint(x: rect.midX, y: rect.midY)
                    })
            )
        }
    }
}
                
