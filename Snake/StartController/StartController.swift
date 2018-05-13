//
//  StartController.swift
//  Snake
//
//  Created by Pavlo Boiko on 13.05.18.
//  Copyright © 2018 DevChallenge. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let hightScoreKey:String = "StartController.keys.hightScore"
    static let lastScoreKey:String = "StartController.keys.lastScore"
}

class StartController:UIViewController, GameControllerDelegate {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var levelTitle: UILabel!
    @IBOutlet weak var levelSlider: UISlider!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var worldSizeSegmentControl: UISegmentedControl!
    @IBOutlet weak var lastScoreValue: UILabel!
    @IBOutlet weak var hightScoreValue: UILabel!
    
    //MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateScores()
    }
    
    func updateScores() {
        OperationQueue.main.addOperation {
            self.lastScoreValue.text = UserDefaults.standard.string(forKey: Constants.lastScoreKey) ?? "0"
            self.hightScoreValue.text = UserDefaults.standard.string(forKey: Constants.hightScoreKey) ?? "0"
        }
    }
    
    //MARK: - Action
    
    @IBAction func playAction(_ sender: Any) {
        guard let gameVc = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else { return }
        gameVc.level = Int(levelSlider.value)
        gameVc.gridSize = worldSizeSegmentControl.selectedSegmentIndex == 0 ? 11 : 21
        gameVc.delegate = self
        present(gameVc, animated: true)
    }
    
    @IBAction func repeatAction(_ sender: Any) {
    }
    
    //MARK: - Overrides
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - GameControllerDelegate
    
    func gameControllerDidFinishGame(_ controller: GameViewController, with score: Int, log: Data) {
        UserDefaults.standard.set("\(score)", forKey: Constants.lastScoreKey)
        let hightScore = Int(UserDefaults.standard.string(forKey: Constants.hightScoreKey) ?? "0")!
        if score > hightScore {
           UserDefaults.standard.set("\(score)", forKey: Constants.hightScoreKey)
        }
        updateScores()
    }
}
