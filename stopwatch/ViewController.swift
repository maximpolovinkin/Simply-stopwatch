//
//  ViewController.swift
//  stopwatch
//
//  Created by Максим Половинкин on 17.07.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    
    var timerCounting = false
    var startTime: Date?
    var stopTime: Date?
    
    let userDefoults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    
    var scheldureTimer: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startStopButton.layer.cornerRadius = startStopButton.bounds.height / 2
        resetButton.layer.cornerRadius = resetButton.bounds.height / 2
        
        startTime = userDefoults.object(forKey: START_TIME_KEY) as? Date
        stopTime = userDefoults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefoults.bool(forKey: COUNTING_KEY)
        
        if timerCounting{
            startTimer()
        } else{
            stopTimer()
            if let start  = startTime{
                if let stop = stopTime{
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff  = Date().timeIntervalSince(time)
                    setTimeLabel(val: Int(diff))
                }
            }
        }
    }

    @IBAction func startStopPressed(_ sender: UIButton) {
        if timerCounting{
            setStopTime(date: Date())
            stopTimer()
        } else{
            if  let stop = stopTime{
                let restartTime = calcRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            } else{
                setStartTime(date: Date())
            }
            
            startTimer()
        }
    }
    
    func calcRestartTime(start: Date, stop: Date) -> Date{
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    func stopTimer(){
        if scheldureTimer != nil{
            scheldureTimer.invalidate()
        }
      
        setTimeCounting(val: false)
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.setTitleColor(UIColor.systemGreen, for: .normal)
        startStopButton.backgroundColor = UIColor.green
    }
    
    func startTimer(){
        scheldureTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimeCounting(val: true)
        startStopButton.setTitle("Stop", for: .normal)
        startStopButton.setTitleColor(UIColor.red, for: .normal)
        startStopButton.backgroundColor = UIColor.systemRed
    }
    
    @objc func refreshValue(){
        if let start = startTime{
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(val: Int(diff))
        }
        else{
            stopTimer()
            setTimeLabel(val: 0)
        }
    }
    
    func setTimeLabel(val: Int) {
        let time = secondsToHoursMinutesSeconds(ms: val)
        let timeString = makeTimerString(hour: time.0, min: time.1, sec: time.2)
        timeLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(ms: Int) -> (Int, Int, Int){
        let hour = ms / 3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        
        return(hour, min, sec)
    }
    
    func makeTimerString(hour: Int, min: Int, sec: Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
       
        return timeString
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        setStopTime(date: nil)
        setStartTime(date: nil)
        timeLabel.text = makeTimerString(hour: 0, min: 0, sec: 0)
        stopTimer()
    }
    
    func setStartTime(date: Date?){
        startTime = date
        userDefoults.set(startTime, forKey: START_TIME_KEY)
    }
    
    func setStopTime(date: Date?){
        stopTime = date
        userDefoults.set(stopTime, forKey: STOP_TIME_KEY)
    }
    
    func setTimeCounting(val: Bool){
        timerCounting = val
        userDefoults.set(timerCounting, forKey: COUNTING_KEY)
    }
    
}

