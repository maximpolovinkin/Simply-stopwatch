//
//  ViewController.swift
//  stopwatch
//
//  Created by Максим Половинкин on 17.07.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 50
    }


}

