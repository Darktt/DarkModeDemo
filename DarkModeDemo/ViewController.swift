//
//  ViewController.swift
//  DarkModeDemo
//
//  Created by Eden on 2022/5/23.
//

import UIKit
import Combine

class ViewController: UIViewController, UserInterfaceSupportable
{
    // MARK: - Properties -
    
    @IBOutlet fileprivate weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet fileprivate weak var lightView: UIView!
    
    @IBOutlet fileprivate weak var darkView: UIView!
    
    override var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        
        didSet {
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    var subscribers: [AnyCancellable] = []
    
    // MARK: - Instance Methods -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.segmentedControl.apply {
            
            $0.removeAllSegments()
            $0.insertSegment(withTitle: "System", at: 0, animated: false)
            $0.insertSegment(withTitle: "Light", at: 1, animated: false)
            $0.insertSegment(withTitle: "Dark", at: 2, animated: false)
//            $0.addTarget(self, action: #selector(self.segmentedUpdateAction(_:)), for: .valueChanged)
        }.fluent
            .selectedSegmentIndex(0)
            .subject
            .propertyPublisher(.valueChanged, keyPath: \.selectedSegmentIndex)
            .compactMap(UIUserInterfaceStyle.init(rawValue:))
            .assign(to: \.overrideUserInterfaceStyle, on: self)
            .store(in: &self.subscribers)
        
        self.lightView.fluent
            .backgroundColor(.sharkLightColor)
            .discardResult
        
        self.darkView.fluent
            .backgroundColor(.sharkDarkColor)
            .discardResult
    }
}

// MARK: - Action Methods -

private extension ViewController
{
    @objc
    func segmentedUpdateAction(_ sender: UISegmentedControl)
    {
        let style: UIUserInterfaceStyle = {
            
            var style = UIUserInterfaceStyle.unspecified
            
            switch sender.selectedSegmentIndex {
                case 1:
                    style = .light
                
                case 2:
                    style = .dark
                
                default:
                    break
            }
            
            return style
        }()
        
        self.overrideUserInterfaceStyle = style
    }
}
