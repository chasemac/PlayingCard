//
//  ViewController.swift
//  PlayingCard
//
//  Created by Chase McElroy on 5/15/20.
//  Copyright © 2020 ChaseMcElroy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)

    lazy var cardBehavior = CardBehavior(in: animator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count + 1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView)
        }
        
    }
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter {$0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1 }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    var lastChosenCardView: PlayingCardView?
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView, faceUpCardViews.count < 2 {
                lastChosenCardView = chosenCardView
                cardBehavior.removeItem(chosenCardView)
                UIView.transition(with: chosenCardView, duration: 0.6, options: [.transitionFlipFromLeft], animations: {
                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                }) { finished in
                    let cardsToAnimate = self.faceUpCardViews
                    if self.faceUpCardViewsMatch {
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 0.6,
                            delay: 0,
                            options: [],
                            animations: {
                                cardsToAnimate.forEach {
                                    print($0.suit)
                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                }
                        }, completion: { position in
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.75,
                                delay: 0,
                                options: [],
                                animations: {
                                    cardsToAnimate.forEach {
                                        print($0.description)
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                        $0.alpha = 0
                                    }
                            },
                                completion: { position in
                                    cardsToAnimate.forEach {
//                                        cardsToAnimate.forEach { cardView in
//                                                 cardView.isFaceUp = false
//                                         }
                                        $0.isHidden = true
                                        $0.alpha = 1
                                        $0.transform = .identity
                                        
                                    }
                                    
                            }
                            )
                        }
                      )
                    }
                    if cardsToAnimate.count == 2 && !self.faceUpCardViewsMatch {
                        guard chosenCardView == self.lastChosenCardView else {
                          return
                        }
                        cardsToAnimate.forEach { cardView in
                            UIView.transition(
                                with: cardView,
                                duration: 0.8,
                                options: [.transitionFlipFromLeft],
                                animations: {
                                cardView.isFaceUp = false
                            }) { finished in
                                self.cardBehavior.addItem(cardView)
                            }
                        }
                    } else {
                        if !chosenCardView.isFaceUp {
                            self.cardBehavior.addItem(chosenCardView)
                        }
                    }
                }
            }
        default: break
            
        }

    }
}


extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(self)))
        } else {
            return CGFloat(0)
        }
    }
}
