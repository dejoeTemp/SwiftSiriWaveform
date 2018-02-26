//
//  SiriWaveformView.swift
//  WaveformPlayground
//
//  Created by Dejoe John on 2/26/18.
//  Copyright © 2018 Dejoe John. All rights reserved.
//

import UIKit

class SiriWaveformView: UIView {
    /*
     * The frequency of the sinus wave. The higher the value, the more sinus wave peaks you will have.
     * Default: 1.5
     */
    @IBInspectable var frequency:Float = 1.5
    
    /*
     * The amplitude that is used when the incoming amplitude is near zero.
     * Setting a value greater 0 provides a more vivid visualization.
     * Default: 0.01
     */
    @IBInspectable var idleAmplitude:Float = 0.01
    
    /*
     * The phase shift that will be applied with each level setting
     * Change this to modify the animation speed or direction
     * Default: -0.15
     */
    @IBInspectable var phaseShift:Float = -0.15
    
    /*
     * The lines are joined stepwise, the more dense you draw, the more CPU power is used.
     * Default: 5
     */
    @IBInspectable var density:Float = 5.0
    
    /*
     * Line width used for the prominent wave
     * Default: 1.5
     */
    @IBInspectable var primaryLineWidth:Float = 3
    
    /*
     * Line width used for all secondary waves
     * Default: 0.5
     */
    @IBInspectable var secondaryLineWidth:Float = 1
    
    
    /*
     * The total number of waves
     * Default: 5
     */
    @IBInspectable var numberOfWaves:Int = 5
    
    /*
     * Color to use when drawing the waves
     * Default: white
     */
    @IBInspectable var waveColor:UIColor = UIColor.white
    
    
    /*
     * The current amplitude.
     */
    @IBInspectable var amplitude:Float = 1.0
    
    var phase:Float = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.clear(self.bounds)
        self.backgroundColor?.set()
        context.fill(rect)
        var i:Int = 0;
        while(i < self.numberOfWaves) {
            let strokeLineWidth = (i == 0 ? self.primaryLineWidth : self.secondaryLineWidth)
            context.setLineWidth(CGFloat(Float(strokeLineWidth)))
            
            let halfHeight = Float(self.bounds.height) / 2;
            let width = Float(self.bounds.width)
            let mid = width/2
            
            let maxAmplitude:Float = halfHeight - (strokeLineWidth*2)
            
            let progress:Float = 1 - Float(i)/Float(self.numberOfWaves)
            let normedAmplitude = (1.5 * progress - (2/Float(self.numberOfWaves))) * self.amplitude
            let multipler:Float = min(1, (progress / 3.0 * 2.0) + (1.0/3.0))
            
            self.waveColor.withAlphaComponent(CGFloat(multipler * Float(waveColor.cgColor.alpha))).set()
            
            var x:Float = Float(0);
            while (x < width + self.density) {
                let scaling:Float = Float(-pow(1/mid*(x-mid), 2) + 1)
                let y: Float = scaling * maxAmplitude * normedAmplitude * sinf(2.0 * Float(Double.pi) * (x/width) * self.frequency + self.phase) + halfHeight;
                
                let xTemp = x
                let yTemp = y
                if(x == 0){
                    context.move(to: CGPointMake(xTemp, yTemp))
                } else {
                    context.addLine(to: CGPointMake(xTemp, yTemp))
                }
                x += self.density
            }
            
            context.strokePath()
            i+=1
        }
        
    }
    
    func updateWithLevel (level:Float) {
        self.phase += self.phaseShift
        self.amplitude = fmax(level, self.idleAmplitude)
        self.setNeedsDisplay()
    }
    
}

func CGPointMake(_ x: Float, _ y: Float) -> CGPoint {
    return CGPoint(x: CGFloat(x), y: CGFloat(y))
}
