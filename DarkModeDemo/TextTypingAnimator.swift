//
//  TextTypingAnimator.swift
//
//  Created by Eden on 2023/6/26.
//

import UIKit

public
class TextTypingAnimator
{
    // MARK: - Properties -
    
    public private(set)
    var text: String
    
    public private(set)
    var finalText: String
    
    public
    var cursor: String = "|"
    
    public private(set)
    var isAnimated: Bool = false
    
    public private(set)
    var isFinished: Bool = false
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init(from text: String, to finalText: String)
    {
        self.text = text
        self.finalText = finalText
    }
    
    public
    func startAnimation(with label: UILabel)
    {
        label.text = self.text
        
        self.isAnimated = true
        self.blink(with: label)
    }
}

private
extension TextTypingAnimator
{
    func sleep(for seconds: TimeInterval, execute: @escaping () -> Void)
    {
        let popTime: DispatchTime = DispatchTime.now() + seconds
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: popTime, execute: execute)
    }
    
    func blink(with label: UILabel, times: Int = 1)
    {
        guard times < 3 else {
            
            self.typing(with: label)
            return
        }
        
        label.text = self.cursor
        
        self.sleep(for: .milliseconds(500.0)) {
            
            [weak self] in
            
            label.text = ""
            
            self?.sleep(for: .milliseconds(200.0)) {
                
                [weak self] in
                
                self?.blink(with: label, times: times + 1)
            }
        }
    }
    
    func typing(with label: UILabel, index: Int = 0)
    {
        let finalText: String = self.finalText
        guard index < finalText.count else {
            
            label.text = finalText
            self.isAnimated = false
            self.isFinished = true
            return
        }
        
        let stringIndex: String.Index = finalText.index(finalText.startIndex, offsetBy: index)
        let text: String = String(self.finalText.prefix(through: stringIndex)) + self.cursor
        
        label.text = text
        
        let milliseconds = Double(1 + UInt64.random(in: 0 ... 1)) * 100.0
        self.sleep(for: .milliseconds(milliseconds)) {
            
            [weak self] in
            
            self?.typing(with: label, index: index + 1)
        }
    }
}

private extension Double
{
    static func milliseconds(_ milliseconds: TimeInterval) -> Double
    {
        return milliseconds / 1000.0
    }
}
