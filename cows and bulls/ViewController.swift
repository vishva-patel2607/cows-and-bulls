//
//  ViewController.swift
//  cows and bulls
//
//  Created by Vishva Patel on 6/13/20.
//  Copyright © 2020 Vishva Patel. All rights reserved.
//

// color palettes
// https://coolors.co/74776b-adbdff-d2e4c4-b91372-92374d
// https://coolors.co/a675a1-2e294e-f2fdff-4c86a8-bd9391
// https://coolors.co/006989-9b6a6c-f2fdff-c7dae6-659157

import UIKit
import GameplayKit

let randomSource = GKRandomSource.sharedRandom()

class gamevar{
    let res : Int
    var resarray = [0,0,0]
    var numberoftries = 7
    var guessednumber = 0
    var cows = 0
    var bulls = 0

    init() {
        self.res = randomSource.nextInt(upperBound: 899) + 100
        var temp1  = self.res
        var temp2 = 2
        var temp3 : Int
        while (temp1 > 0){
            temp3 = temp1%10
            temp1 /= 10
            self.resarray[temp2]=temp3
            temp2 -= 1
        }
    }

    func guessednumberupdate(number : Int ){
        if (self.guessednumber<100){
            self.guessednumber=self.guessednumber*10+number
        }
    }
    
    func guessednumberdelete(){
            self.guessednumber=self.guessednumber/10
    }
    
    func evaluateguessednumber(){
        var tempnum = self.guessednumber
        var tempresarray = self.resarray
        var tempnumarray = [0,0,0]
        var temp1 : Int
        var temp2 = 2
        while (temp2 >= 0){
            if (tempnum > 0){
                temp1 = tempnum%10
                tempnum /= 10
                tempnumarray[temp2]=temp1
                temp2 -= 1
            }
            else {
                tempnumarray[temp2]=0
                temp2 -= 1
            }
        }
        
        
        
        for i in 0...2{
            
            if (tempnumarray[i]==self.resarray[i]){
                self.cows += 1
                tempresarray.remove(at : i)
                tempresarray.insert(-1, at: i)
                tempnumarray.remove(at : i)
                tempnumarray.insert(-2, at: i)
            }
        }
        
        for i in tempnumarray{
            if (tempresarray.contains(i)){
                self.bulls += 1
            }
        }
        
    }
}

class ViewController: UIViewController {

    
    @IBOutlet weak var Reset: UIButton!
    
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var Delete: UIButton!
    
    @IBOutlet weak var Enter: UIButton!
    
    @IBOutlet var numbers: [UIButton]!
    
    @IBOutlet var outputnumbers: [UILabel]!
    
    @IBOutlet var cownumbers: [UILabel]!
    
    @IBOutlet var bullnumbers: [UILabel]!
    
    var currentgame  : gamevar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        newRound()
    }

    func newRound(){
        currentgame = gamevar()
        print(currentgame.res)
        Enter.isEnabled=true
        Delete.isEnabled=true
        for i in numbers{
            i.isEnabled=true
        }
    }
    
    func updateresult(){
        var tempnum = currentgame.guessednumber
        if (tempnum>0){
            var tempnumarray = [0,0,0]
            var temp1 : Int
            var temp2 = 2
            while (temp2 >= 0){
                if (tempnum > 0){
                    temp1 = tempnum%10
                    tempnum /= 10
                    tempnumarray[temp2]=temp1
                    temp2 -= 1
                }
                else {
                   tempnumarray[temp2]=0
                    temp2 -= 1
                }
            }
            
            result.text = "\(tempnumarray[0]) \(tempnumarray[1]) \(tempnumarray[2])"
        }
        else{
            result.text = "_ _ _"
        }
    }
    
    func updateoutput(){
        
        if (currentgame.guessednumber == 0){
            for i in 0...6{
                outputnumbers[i].text=" "
                cownumbers[i].text=" "
                bullnumbers[i].text=" "
            }
        }
        else{
            let temp = currentgame.cows
            outputnumbers[currentgame.numberoftries-1].text="\(currentgame.guessednumber)"
            cownumbers[currentgame.numberoftries-1].text="\(currentgame.cows)"
            bullnumbers[currentgame.numberoftries-1].text="\(currentgame.bulls)"
            currentgame.guessednumber=0
            currentgame.cows=0
            currentgame.bulls=0
            currentgame.numberoftries -= 1
            if (temp == 3){
                gamewon()
            }
            else if(currentgame.numberoftries == 0){
                gamelost()
            }
            
        }
        
    }
    
    func gamewon(){
        result.text="WIN"
        Enter.isEnabled=false
        Delete.isEnabled=false
        for i in numbers{
            i.isEnabled=false
        }
        
    }
    
    func gamelost(){
        result.text="LOSE"
        Enter.isEnabled=false
        Delete.isEnabled=false
        for i in numbers{
            i.isEnabled=false
        }

    }

    
    @IBAction func numberpressed(_ sender: UIButton) {
        let numberstring = sender.title(for: .normal)!
        let num = Int(numberstring) ?? 0
        currentgame.guessednumberupdate(number: num)
        updateresult()
    }
    

    @IBAction func Resetpressed(_ sender: UIButton) {
        newRound()
        updateresult()
        updateoutput()
    }
    

    @IBAction func Deletepressed(_ sender: Any) {
        currentgame.guessednumberdelete()
        updateresult()
    }
    
    
    @IBAction func Enterpressed(_ sender: UIButton) {
        if (currentgame.guessednumber > 99 && currentgame.numberoftries > 0){
            currentgame.evaluateguessednumber()
            updateoutput()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

