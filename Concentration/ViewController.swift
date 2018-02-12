//
//  ViewController.swift
//  Concentration
//
//  Created by bkmsx on 2/10/18.
//  Copyright © 2018 bkmsx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var MAX_FLIP_COUNT = 30
    let MAX_CARDS = 20
    var game : Contrentration!
    var ghostButtons = [UIButton]()
    var imageChoices = [#imageLiteral(resourceName: "am0"), #imageLiteral(resourceName: "am1"), #imageLiteral(resourceName: "am2"), #imageLiteral(resourceName: "am3"), #imageLiteral(resourceName: "am4"), #imageLiteral(resourceName: "am5"), #imageLiteral(resourceName: "am6"), #imageLiteral(resourceName: "am7"), #imageLiteral(resourceName: "am8"), #imageLiteral(resourceName: "am9")]
    var images = [Int: UIImage]()
    
    @IBOutlet weak var flipCountLable: UILabel!
    @IBOutlet weak var cardPanel: UIView!
    @IBOutlet weak var levelButton: UIButton!
    
    var flipCount = 0 {
        didSet {
            flipCountLable.text = "Remain flips: \(flipCount)"
        }
    }
    
    override func viewDidLoad() {
        flipCount = MAX_FLIP_COUNT
        generateBoard(with: 12)
    }
    
    func generateBoard(with cardNumber: Int) {
        self.ghostButtons.removeAll()
        for view in self.cardPanel.subviews {
            view.removeFromSuperview()
        }
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth = (screenWidth - 10) / 4
        for index in 0..<cardNumber {
            let button = UIButton(frame: CGRect(x: 2 + CGFloat(index % 4) * (cardWidth + 2), y: 50 + CGFloat(index / 4) * (cardWidth + 2), width: cardWidth, height: cardWidth))
            button.backgroundColor = #colorLiteral(red: 0.8707280755, green: 0.4922321439, blue: 0, alpha: 1)
            button.addTarget(self, action:#selector(touchGhost(_:)), for: .touchUpInside)
            self.cardPanel.addSubview(button)
            ghostButtons.append(button)
        }
        game = Contrentration(numberOfPairOfCard: (ghostButtons.count + 1) / 2)
    }
    
    @IBAction func chooseCardNumber(_ sender: Any) {
        let alert = UIAlertController(title: "Game Levels", message: "", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        let twentyAction = UIAlertAction(title: "Hard", style: .default, handler: {action -> Void in
            self.generateBoard(with: 20)
            self.levelButton.setTitle("Hard", for: .normal)
            self.MAX_FLIP_COUNT = 50
            self.flipCount = self.MAX_FLIP_COUNT
        })
        alert.addAction(twentyAction)

        let sixteenAction = UIAlertAction(title: "Medium", style: .default, handler: {action -> Void in
            self.generateBoard(with: 16)
            self.levelButton.setTitle("Medium", for: .normal)
            self.MAX_FLIP_COUNT = 40
            self.flipCount = self.MAX_FLIP_COUNT
        })
        alert.addAction(sixteenAction)
        let twelveAction = UIAlertAction(title: "Easy", style: .default, handler: {action -> Void in
            self.generateBoard(with: 12)
            self.levelButton.setTitle("Easy", for: .normal)
            self.MAX_FLIP_COUNT = 30
            self.flipCount = self.MAX_FLIP_COUNT
        })
        alert.addAction(twelveAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeStyle(_ sender: Any) {
        let alert = UIAlertController(title: "Style", message: "", preferredStyle: .alert)
        let option1 = UIAlertAction(title:"Emoji", style: .default) {action -> Void in
            self.imageChoices = [#imageLiteral(resourceName: "am0"), #imageLiteral(resourceName: "am1"), #imageLiteral(resourceName: "am2"), #imageLiteral(resourceName: "am3"), #imageLiteral(resourceName: "am4"), #imageLiteral(resourceName: "am5"), #imageLiteral(resourceName: "am6"), #imageLiteral(resourceName: "am7"), #imageLiteral(resourceName: "am8"), #imageLiteral(resourceName: "am9")]
            self.images.removeAll()
            self.resetGame("")
        }
        option1.setValue(#imageLiteral(resourceName: "gallery1").withRenderingMode(.alwaysOriginal), forKey: "image")
        alert.addAction(option1)
        let option2 = UIAlertAction(title:"Flowers", style: .default){action -> Void in
            self.imageChoices = [#imageLiteral(resourceName: "fl0"), #imageLiteral(resourceName: "fl1"), #imageLiteral(resourceName: "fl2"), #imageLiteral(resourceName: "fl3"), #imageLiteral(resourceName: "fl4"), #imageLiteral(resourceName: "fl5"), #imageLiteral(resourceName: "fl6"), #imageLiteral(resourceName: "fl7"), #imageLiteral(resourceName: "fl8"), #imageLiteral(resourceName: "fl9")]
            self.images.removeAll()
             self.resetGame("")
        }
        option2.setValue(#imageLiteral(resourceName: "gallery2").withRenderingMode(.alwaysOriginal), forKey: "image")
        alert.addAction(option2)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func touchGhost(_ sender: UIButton) {
        flipCount -= 1
        if let cardNumber = ghostButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        
        if flipCount <= 0 {
            let alert = UIAlertController(title: "You loose!!", message: "You run out of flips", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateViewFromModel(){
        var allMatch = true
        for index in ghostButtons.indices {
            let card = game.cards[index]
            let button = ghostButtons[index]
            if card.isFaceUp {
                button.setImage(getImage(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setImage(nil, for: UIControlState.normal)
                button.backgroundColor = card.isMatch ? #colorLiteral(red: 0.926155746, green: 0.9410773516, blue: 0.9455420375, alpha: 0) : #colorLiteral(red: 0.8707280755, green: 0.4922321439, blue: 0, alpha: 1)
            }
            if allMatch, !card.isMatch {
                allMatch = false
            }
        }
        if allMatch {
            let alert = UIAlertController(title: "You win!!!", message: "Congratulation! You got all cards matched!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Play again", style: .cancel) { action -> Void in
                self.resetGame("")
            }
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func resetGame(_ sender: Any) {
        game.reset()
        updateViewFromModel()
        flipCount = MAX_FLIP_COUNT
    }
    
    func getImage(for card: Card) -> UIImage{
        if images[card.identifier] == nil {
            let randomIndex = Int(arc4random_uniform(UInt32(imageChoices.count)))
            images[card.identifier] = imageChoices.remove(at: randomIndex)
        }
        return (images[card.identifier] ?? nil)!
    }
}

