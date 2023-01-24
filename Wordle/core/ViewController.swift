//
//  ViewController.swift
//  Wordle
//
//  Created by Daria Strait on 1/23/23.
//

import UIKit

//UI
// Keyboard
// Game board
// Orange/Green

class ViewController: UIViewController {
    
    let answers = [
        "later", "after", "mango", "spent", "loved", "greed", "grace", "glory", "grind", "blind", "blunt", "bored", "break", "based", "blank", "cream", "cured", "there", "think", "ultra", "great", "speed", "cramp", "weird", "wrong"
    ]
    
    var answer = ""
    private var guesses: [[Character?]] = Array(
        repeating: Array(repeating: nil, count: 5),
        count: 6)
    
    let keyboardVC = KeyBoardViewController()
    let boardVS = BoardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        answer = answers.randomElement() ?? "after"
        view.backgroundColor = .systemGray5
        
        addChildren()
    }

    private func addChildren() {
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(boardVS)
        boardVS.didMove(toParent: self)
        boardVS.view.translatesAutoresizingMaskIntoConstraints = false
        boardVS.datasource = self
        view.addSubview(boardVS.view)
        
        addConstraints()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            boardVS.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVS.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVS.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVS.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVS.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ViewController: KeyBoardViewControllerDelegate {
    func keyBoardViewController(_ vc: KeyBoardViewController, didTapKey letter: Character) {
        
        // Update guesses
        var stop = false
        
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }
            
            if stop {
                break
            }
        }
        
        boardVS.reloadData()
    }
}

extension ViewController: BoardViewControllerDatasource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section
        
        let count = guesses[rowIndex].compactMap({ $0 }).count
        guard count == 5 else {
            return nil
        }
        
        let indexAnswer = Array(answer)
        
        guard let letter = guesses[indexPath.section][indexPath.row], indexAnswer.contains(letter) else {
            return nil
        }
        
    
        if indexAnswer[indexPath.row] == letter {
            return .systemGreen
        }
        
        return .systemOrange
    }
}

