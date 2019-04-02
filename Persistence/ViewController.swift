//
//  ViewController.swift
//  Persistence
//
//  Created by student on 4/1/19.
//  Copyright © 2019 Sean Klechak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate static let rootKey = "rootKey"
    @IBOutlet var lineFields:[UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fileURL = self.dataFileURL()
        if (FileManager.default.fileExists(atPath: fileURL.path!)){
            if let array = NSArray(contentsOf: fileURL as URL) as? [String] {
                for i in 0..<array.count {
                    lineFields[i].text = array[i]
                }
            }
            let data = NSMutableData(contentsOf: fileURL as URL)
            //            let unarchiver = NSKeyedUnarchiver(forReadingWith: data! as Data)
            let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data! as Data)
            //            let fourLines = unarchiver?.decodeObject(forKey: ViewController.rootKey) as! FourLines
            let fourLines = unarchiver?.decodeObject(forKey: ViewController.rootKey)
                as? FourLines
            // the line above errors a nil. i'm stuck here
            
            unarchiver!.finishDecoding()
            if let newLine = fourLines?.lines {
                for i in 0..<newLine.count{
                    lineFields[i].text = newLine[i]
                }
            }
        }
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notificatioin:)), name: UIApplication.willResignActiveNotification, object: app)
    }
    @objc func applicationWillResignActive(notificatioin:NSNotification) {
        let fileURL = self.dataFileURL()
        let fourLines = FourLines()
        let array = (self.lineFields as NSArray).value(forKey: "text") as! [String]
        fourLines.lines = array
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        archiver.encode(fourLines, forKey: ViewController.rootKey)
        archiver.finishEncoding()
        //        archiver.encode(fourLines, forKey: ViewController.rootKey)
        data.write(to: fileURL as URL, atomically: true)
        
        //        array.write(to: fileURL as URL, atomically: true)
        
        
    }
    
    func dataFileURL() -> NSURL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url:NSURL?
        url = URL(fileURLWithPath: "") as NSURL // create a blank path
        
        do {
            try url = urls.first!.appendingPathComponent("data.whatever") as NSURL
        } catch {
            print("Error is \(error)")
        }
        return url!
    }
    
    
}

