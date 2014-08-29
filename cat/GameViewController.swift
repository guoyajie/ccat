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
var degree = 1

class GameViewController: UIViewController {
 
    var button = [[UIButton]]()
    var catView = UIImageView()
    var clickPoint : CircleLocation?
    var cat = CircleLocation(row: 4, col: 4)
    var gameLevel = 20
    var pathNumber = 0
    var odd = 32
    var width = 30
    var highth = 35
    var isGameOver = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initscene()
        initAllCircleLocation()
        
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
        
        let row = (Int(btn.frame.origin.y)-250) / odd
        var col = 0
        if row%2 == 0 {
            col = (Int(btn.frame.origin.x)-10) / odd
        }
        else {
            col = (Int(btn.frame.origin.x)-10-odd/2) / odd
        }
        if (map[row][col] == 1 && ( cat.row != row || cat.col != col) ){
        }
        else{
            btn.setImage(UIImage(named: "block1"),forState:.Normal)
            updateCost(row, col: col)
            pathNumber++
            if self.isGameOver == 1 && self.cat.row == row && self.cat.col == col {
                showWinAlertView()
                return
            }
            else if self.isGameOver == 1{}
            else{
                isGameOver = catAutoGo()
                if isGameOver == -1 {
                    showLoseAlertView()
                    return
                }
                else if self.isGameOver == 1 && self.cat.row == row && self.cat.col == col {
                    showWinAlertView()
                    return
                }
                
            }
            
            //calAllCost()
        
        }
        
    }
    func showWinAlertView(){
        var alert = UIAlertController(title: "你用了\(pathNumber)步成功捉住了神经猫", message: "在所有玩家中排名第\(degree)", preferredStyle: .Alert)
        
        var actionYes = UIAlertAction(title: "退出游戏", style: .Default, handler: {act in exit(-1)})
        var actionNo = UIAlertAction(title: "再来一次", style: .Default, handler: {act in self.runAgain()})
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func showLoseAlertView(){
        var alert = UIAlertController(title: "神经猫逃走了", message: "你失败了", preferredStyle: .Alert)
        var actionYes = UIAlertAction(title: "退出游戏", style: .Default, handler: {act in exit(1)})
        var actionNo = UIAlertAction(title: "再来一次", style: .Default, handler: {act in self.runAgain()})
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func runAgain(){
        initGame()
    }
    
    func updateCost(row:Int,col:Int){
        var loc = allCircleLocation[row][col]
        map[loc.row][loc.col] = 1
        clickPoint = loc
        //clearAllCost()
        calAllCost()
     
    }
    func catAutoGo() -> Int{
        var bestS = getBestLocation()
        if let best = bestS{
            var i = self.cat.row
            var j = self.cat.col
            if clickPoint!.row == allCircleLocation[i][j].row && clickPoint!.col == allCircleLocation[i][j].col {}
            else{
                map[i][j] = 0
            }
            self.cat.row = best.row
            self.cat.col = best.col
            i = self.cat.row
            j = self.cat.col
            map[i][j] = 1
            if i%2 == 0{
                catView.frame = CGRectMake(CGFloat(10+j*odd), CGFloat(250+i*odd), CGFloat(width), CGFloat(highth))
            }
            else {
                catView.frame = CGRectMake(CGFloat(10+j*odd+odd/2), CGFloat(250+i*odd), CGFloat(width), CGFloat(highth))
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
    func getBestLocation() -> CircleLocation? {
        var catAllSelects = allCircleLocation[cat.row][cat.col].getAllConnectLocation()
        if catAllSelects.count > 0{
            var best = catAllSelects[0]
            if best.isBoundary(){
                return best
            }
            for i in 0...(catAllSelects.count-1) {
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
        clearAllCost()
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
                map[i][j] = 0
            }
        }
        catView.frame = CGRectMake(CGFloat(10+4*odd), CGFloat(250+4*odd), CGFloat(width), CGFloat(highth))
        cat.row = 4
        cat.col = 4
        map[4][4] = 1
        produceGameLevel()
        pathNumber = 0
        isGameOver = 0
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


