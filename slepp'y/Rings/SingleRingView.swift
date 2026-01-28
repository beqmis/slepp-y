//
//  RingsView.swift
//  slepp'y
//
//  Created by Яков Демиденко on 26.01.2026.
//
import SwiftUI

extension Double {
    func toRadians() -> Double { self * .pi / 180 }
    func toCGFloat() -> CGFloat {
            return CGFloat(self)
        }
}

struct SingleRingView:View {
    
    static let ShadowColor: Color = Color.black.opacity(0.2)
    static let ShadowRadius: CGFloat = 5
    static let ShadowOffsetMultiplier: CGFloat = ShadowRadius + 2
    
    let model: RingTypeModel
    let ringWidth: CGFloat
    let startAngle: Double = -90
    
    private var absolutePercentageAngle: Double {
        RingShape.percentToAngle(percent: model.percent, startAngle: 0)
    }
    private var relativePercentageAngle: Double {
        absolutePercentageAngle + startAngle
    }
    
    
    var body: some View {
        ZStack() {
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                ZStack {
                    // 2. Background for the ring
                    RingShape()
                        .stroke(style: StrokeStyle(lineWidth: self.ringWidth))
                        .fill(model.backgroundColor)
                    // 3. Foreground
                    RingShape(percent: model.percent, startAngle: self.startAngle)
                        .stroke(style: StrokeStyle(lineWidth: self.ringWidth, lineCap: .round))
                        .fill(model.foregroundColor)
                    
                    if self.getShowShadow(frame: geometry.size)
                    {
                        Circle()
                            .fill(model.foregroundColor)
                            .frame(width: self.ringWidth, height: self.ringWidth, alignment: .center)
                            .offset(x: self.getEndCircleLocation(frame: geometry.size).0,
                                    y: self.getEndCircleLocation(frame: geometry.size).1)
                            .shadow(color: SingleRingView.ShadowColor,
                                    radius: SingleRingView.ShadowRadius,
                                    x: self.getEndCircleShadowOffset().0,
                                    y: self.getEndCircleShadowOffset().1)
                    }
                }
                .frame(width: size, height: size)
                .position(center)
            }
            .padding(self.ringWidth / 2)
        }
    }
    private func getEndCircleLocation(frame: CGSize) -> (CGFloat, CGFloat) {
        let angleOfEndInRadians: Double = relativePercentageAngle.toRadians()
        let offsetRadius = min(frame.width, frame.height) / 2
        return (offsetRadius * cos(angleOfEndInRadians).toCGFloat(), offsetRadius * sin(angleOfEndInRadians).toCGFloat())
    }
    
    private func getEndCircleShadowOffset() -> (CGFloat, CGFloat) {
        let angleForOffset = absolutePercentageAngle + (self.startAngle + 90)
        let angleForOffsetInRadians = angleForOffset.toRadians()
        let relativeXOffset = cos(angleForOffsetInRadians)
        let relativeYOffset = sin(angleForOffsetInRadians)
        let xOffset = relativeXOffset.toCGFloat() * SingleRingView.ShadowOffsetMultiplier
        let yOffset = relativeYOffset.toCGFloat() * SingleRingView.ShadowOffsetMultiplier
        return (xOffset, yOffset)
    }
    
    private func getShowShadow(frame: CGSize) -> Bool {
        let circleRadius = min(frame.width, frame.height) / 2
        let remainingAngleInRadians = (360 - absolutePercentageAngle).toRadians().toCGFloat()
        if model.percent >= 100 {
            return true
        } else if circleRadius * remainingAngleInRadians <= self.ringWidth {
            return true
        }
        return false
    }
}
