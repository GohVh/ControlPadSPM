//
//  CurveControl.swift
//  ControlPad
//
//  Created by hansoong on 25/9/24.
//

import SwiftUI

struct BezierCurveView: View {
    @State private var points: [CGPoint] = [
        CGPoint(x: 50, y: 300),   // Start point
        CGPoint(x: 120, y: 100),  // Control point 1
        CGPoint(x: 180, y: 500),  // Control point 2
        CGPoint(x: 250, y: 300),  // midpoint
        CGPoint(x: 380, y: 500),  // Control point 3
        CGPoint(x: 380, y: 100),  // Control point 4
        CGPoint(x: 450, y: 300)   // End point
    ]
    
    var body: some View {
        ZStack {
            // Draw the Bezier curve
            Path { path in
                path.move(to: points[0])
                path.addCurve(
                    to: points[3],
                    control1: points[1],
                    control2: points[2]
                )
                path.move(to: points[3])
                path.addCurve(to: points[6],
                              control1: points[5],
                              control2: points[4])
            }
            .stroke(Color.blue, lineWidth: 3)
            
            // Draw circles at control points
            ForEach(0..<points.count, id: \.self) { i in
                Circle()
                    .fill(i == 0 || i == 3 || i == 6 ? Color.red : Color.green) // Red for start/end, green for control points
                    .frame(width: 20, height: 20)
                    .position(points[i])
                    .gesture(DragGesture()
                                .onChanged { value in
                                    points[i] = value.location
                                }
                    )
            }
        }
        .frame(width: 500, height: 600)
    }
}


struct curvecontrolpreview: PreviewProvider {
    static var previews: some View {
//        let photoManager = PhotoManager()
        BezierCurveView()
//            .environmentObject(photoManager)
    }
}

//struct ContentView: View {
//    var body: some View {
//        BezierCurveView()
//    }
//}
//
//@main
//struct BezierCurveApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

