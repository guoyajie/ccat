//
//  GameViewController.swift
//  cat
//
//  Created by mohoo on 14/8/20.
//  Copyright (c) 2014年 mohoo. All rights reserved.
//

import Foundation
import UIKit
var allCircleLocation = [[CircleLocation]]()
var hasCircle = 0
var map = [
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0]]

class GameViewController: UIViewController {
 
    var button = [[UIButton]]()
    var catView = UIImageView()
    var clickPoint : CircleLocation?
    var cat = CircleLocation(row: 4, col: 4)
    var gameLevel = 10
    var pathNumber : Int = 0
    var odd = 32
    var width = 30
    var highth = 35
    var isGameOver = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initAllCircleLocation()
        initscene()
        initcat()
        initGame()
     }
    
    func initscene(){
        for j in 0...8 {
            var button1 = [UIButton]()
            for i in 0...8 {
                var btn = UIButton()
                if j%2 == 0{
                    btn.frame = CGRectMake(CGFloat(10+i*odd), CGFloat(250+j*odd), CGFloat(width), CGFloat(highth))
                }
                else{
                    btn.frame = CGRectMake(CGFloat(10+i*odd+odd/2), CGFloat(250+j*odd), CGFloat(width), CGFloat(highth))
                }
                btn.setImage(UIImage(named: "block2"), forState:.Normal)
                self.view.addSubview(btn)
                btn.addTarget(self, action: "changeAndMove:", forControlEvents: .TouchUpInside)
                button1.append(btn)
            }
            button.append(button1)
        }
    }
    

    
    func changeAndMove(btn:UIButton){
        btn.setImage(UIImage(named: "block1"),forState:.Normal)
        let row = (Int(btn.frame.origin.y)-250) / odd
        var col = 0
        if row%2 == 0 {
            col = (Int(btn.frame.origin.x)-10) / odd
        }
        else {
            col = (Int(btn.frame.origin.x)-10-odd/2) / odd
        }
        updateCost(row, col: col)
        pathNumber++
        isGameOver = catAutoGo()
        calAllCost()
        
        
        
    }
    func updateCost(row:Int,col:Int){
        var loc = allCircleLocation[row][col]
        map[loc.row][loc.col] = 1
        clickPoint = loc
        clearAllCost()
        calAllCost()
     
    }
    func catAutoGo() -> Int{
        var bestS = getBestLocation()
        if let best = bestS{
            var i = self.cat.row
            var j = self.cat.col
            if clickPoint!.row == allCircleLocation[i][j].row && clickPoint!.col == allCircleLocation[i][j].col {
                
            }
            else{
                map[i][j] = 0
            }
            self.cat.row = best.row
            self.cat.col = best.col
            i = self.cat.row
            j = self.cat.col
            map[i][j] = 1
            if i%2 == 0{
                catView.frame = CGRectMake(CGFloat(10+j*odd), CGFloat(250+(i-1)*odd), CGFloat(width), CGFloat(highth))
                

            }
            else {
                catView.frame = CGRectMake(CGFloat(10+j*odd+odd/2), CGFloat(250+(i-1)*odd), CGFloat(width), CGFloat(highth))
            }
            if cat.isBoundary(){
                return -1
            }
        }
        else{
            return 1
        }
        return 0
        
    }
    func getBestLocation() -> CircleLocation?{
        var catAllSelects = allCircleLocation[cat.row][cat.col].getAllConnectLocation()
        if catAllSelects.count > 0{
            var best = catAllSelects[0]
            if best.isBoundary(){
                return best
            }
            for i in 1...catAllSelects.count-1 {
                if catAllSelects[i].isBoundary(){
                    best = catAllSelects[i]
                    break
                }
                if best.compare(catAllSelects[i]){
                    best = catAllSelects[i]
                }
            }
            return best
        }
        return nil
    }
    func clearAllCost(){
        for i in 0...8{
            for j in 0...8{
                allCircleLocation[i][j].path = -100
                allCircleLocation[i][j].cost = -100
            }
        }
    }
    func calAllCost(){
        for i in 0...8{
            for j in 0...8{
                allCircleLocation[i][j].calculateCost()
                
            }
        }
        for i in 0...8{
            var k = i
            for j in 0...i{
                allCircleLocation[j][k].calculatePath()
                allCircleLocation[8-j][8-k].calculatePath()
                k--
            }
        }
        for i in 0...8{
            var k = 8-i
            for j in 0...i{
                allCircleLocation[j][k].calculatePath()
                allCircleLocation[k][j].calculatePath()
                k++
            }
        }
        for i in 0...8{
            for j in 0...8{
                allCircleLocation[j][i].calculatePath()
                allCircleLocation[i][j].calculatePath()
                allCircleLocation[j][8-i].calculatePath()
                allCircleLocation[8-i][j].calculatePath()
            }
        }
        hasCircle = self.cat.isInCircle()
        
    }
    
    func initAllCircleLocation(){
        for j in 0...8 {
            var rowCircle = [CircleLocation]()
            for i in 0...8 {
                var circle = CircleLocation(row:j,col:i)
                rowCircle.append(circle)
            }
            allCircleLocation.append(rowCircle)
        }
    }
    
    func initcat(){
        catView.frame = CGRectMake(28*4+20,28*3+170,30,56)
        self.view.addSubview(catView)
        var midImage = UIImage(named: "middle2")
        var leftImage = UIImage(named: "left2")
        var rightImage = UIImage(named: "right2")
        catView.animationDuration = 1.0
        catView.animationImages = [leftImage,midImage,rightImage]
        catView.startAnimating()
    }
    
    func initGame(){
        for j in 0...8 {
            for i in 0...8 {
                button[i][j].setImage(UIImage(named: "block2"), forState: .Normal)
            }
        }
        catView.frame = CGRectMake(CGFloat(10+4*odd), CGFloat(250+4*odd), CGFloat(width), CGFloat(highth))
        cat.row = 4
        cat.col = 4
        map[4][4] = 1
        produceGameLevel()
    }
    
    func produceGameLevel(){
        var num=0
        while num < gameLevel {
            var row = Int(arc4random()%9)
            var col = Int(arc4random()%9)
            if row != 4 && col != 4 {
                map[row][col] = 1
                num++
                button[row][col].setImage(UIImage(named: "block1"), forState:.Normal)
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}


