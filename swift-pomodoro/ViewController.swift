//
//  ViewController.swift
//  swift-pomodoro
//
//  Created by Louis Liao on 2020/4/2.
//  Copyright © 2020 Louis Liao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
    var timer : Timer?
    var endDate : Date?
    
    var secondsLeft : TimeInterval = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure initial state of the label and button
        updateLabel()
        timerButton.setTitle("Start", for: .normal)
    }
    
    
    // MARK: - Liftcycle
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // Check if timer is running
        if timer != nil, endDate != nil {
            
            // Timer is running
            timer?.invalidate()
            
            // Save the end date
            let defaults = UserDefaults.standard
            defaults.set(endDate, forKey: "EndDate")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        // Check if end date saved
        if let date = defaults.value(forKey: "EndDate") as? Date {
            
            if Date() > date {
                // Timer expired
                
            } else {
                // Get seconds left
                secondsLeft = date.timeIntervalSince(Date())
                
                // Start timer
                timerStart()
            }
            defaults.set(nil, forKey: "EndDate")
        }
    }
    
    // MARK: - UI
    
    func updateLabel() {
        TimeLabel.text = String(secondsLeft)
    }
    
    // MARK: - Timer function
    
    @objc func timerTick() {
        
        // Decrement the seconds left
        secondsLeft -= 1
        
        // Update the label
        updateLabel()
        
        // check if timer expired
        if secondsLeft <= 0 {
            timerEnd()
        }
        
    }
    
    func timerStart() {
        
        // Create timer and run it
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        
        // Set an end date
        endDate = Date().addingTimeInterval(secondsLeft)
        
        // Update Label
        updateLabel();
        
        // Update the text of label
        timerButton.setTitle("Pause", for: .normal)
    }
    
    func timerPause() {
        
        // Kill the timer
        timer?.invalidate()
        
        // Reset th end date
        endDate = nil
        
        // Update the button text
        timerButton.setTitle("Continue", for: .normal)
        
    }
    
    func timerEnd() {
            
        // Kill the timer
        timer?.invalidate()
        
        // Reset timer
        timer = nil
        
        // Reset end date
        endDate = nil
        
        // Reset button text
        timerButton.setTitle("Restart", for: .normal)
        
        // Hardcode timer and run it
        secondsLeft = 10
    }
    
    @IBAction func timerTapped(_ sender: UIButton) {
        
        if timer == nil || (timer != nil && endDate == nil) {
            
            // Timer has not been run || Currently paused
            timerStart()
        }
        else if timer != nil && endDate != nil {
            
            // Currently running
            timerPause()
        }
        
    }
}

