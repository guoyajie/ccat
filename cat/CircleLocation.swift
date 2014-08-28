//
//  CircleLocation.swift
//  cat
//
//  Created by mohoo on 14/8/26.
//  Copyright (c) 2014年 mohoo. All rights reserved.
//

import Foundation
class CircleLocation{
    var row : Int
    var col : Int
    var path : Int = -100
    var cost : Int = -100
    init(row:Int,col:Int){
        self.row = row
        self.col = col
    }
    func getLeft() -> CircleLocation?{
        var newp : CircleLocation?
        if col > 0 {
            newp = allCircleLocation[row][col-1]
        }
        return newp
    }
    func getRight() -> CircleLocation?{
        var newp : CircleLocation?
        if col < 8 {
            newp = allCircleLocation[row][col+1]
        }
        return newp
    }
    func getLeftup() -> CircleLocation?{
        var newp : CircleLocation?
        if row > 0{
            if row%2 == 0{
                if col > 0{
                    newp = allCircleLocation[row-1][col-1]
                }
            }
            else{
                newp = allCircleLocation[row-1][col]
            }
        }
        return newp
    }
    func getLeftdown() -> CircleLocation?{
        var newp : CircleLocation?
        if row < 8 {
            if row%2 == 0{
                if col > 0{
                    newp = allCircleLocation[row+1][col-1]
                }
            }
            else{
                newp = allCircleLocation[row+1][col]
            }
        }
        return newp
    }
    func getRightup() -> CircleLocation?{
        var newp : CircleLocation?
        if row > 0{
            if row%2 != 0{
                if col < 8{
                    newp = allCircleLocation[row-1][col+1]
                }
            }
            else{
                newp = allCircleLocation[row-1][col]
            }
        }
        return newp
    }
    func getRightdown() -> CircleLocation?{
        var newp : CircleLocation?
        if row > 0{
            if row%2 != 0{
                if col < 8{
                    newp = allCircleLocation[row+1][col+1]
                }
            }
            else{
                newp = allCircleLocation[row+1][col]
            }
        }
        return newp
    }
    
    func getAllConnectLocation() -> [CircleLocation]{
        var arr = [CircleLocation]()
        var cl = getLeft()
        if let temp = cl {
            if map[temp.row][temp.col] == 0{
                arr.append(temp)
            }
        }
        cl = getRight()
        if let temp = cl {
            if map[temp.row][temp.col] == 0{
                arr.append(temp)
            }
        }
        cl = getLeftup()
        if let temp = cl {
            if map[temp.row][temp.col] == 0{
                arr.append(temp)
            }
        }
        cl = getLeftdown()
        if let temp = cl {
            if map[temp.row][temp.col] == 0{
                arr.append(temp)
            }
        }
        cl = getRightup()
        if let temp = cl {
            if map[temp.row][temp.col] == 0{
                arr.append(temp)
            }
        }
        cl = getRightdown()
        if let temp = cl {
            if map[temp.row][temp.col] == 0{
                arr.append(temp)
            }
        }
        return arr
    }
    
    func isBoundary() -> Bool {
        if row == 0 || row == 8 || col == 0 || col == 8 {
            return true
        }
        else {
            return false
        }
    }
    
    func calculateCost() -> Int {
        if map[row][col] == 1 {
            cost = 100
            return cost
        }
        if isBoundary(){
            cost = 0
            return cost
        }
        var allConnectLoc = getAllConnectLocation()
        cost = allConnectLoc.count
        return cost
    }
    func calculatePath() -> Int{
        var i = self.row
        var j = self.col
        if map[i][j] == 1 {
            self.path = 100
            return self.path
        }
        if self.isBoundary(){
            self.path = 0
            return self.path
        }
        var allConnectLoc = getAllConnectLocation()
        var min = 100
        for obj in allConnectLoc {
            if obj.path > -100 {
                var tmp = obj.path
                if tmp < 0{
                    tmp = -tmp
                }
                if min > tmp {
                    min = tmp
                }
            }
        }
        if min < 100 {
            self.path = min + 1
        }
        else {
            self.path = self.path + 1
        }
        return self.path
    }
    func compare(cl:CircleLocation) -> Bool {
        if hasCircle == 0{
            return self.isMoreThan(cl)
        }
        else {
            return self.isLessThan(cl)
        }
    }
    func isMoreThan(cl:CircleLocation) -> Bool{
        var spath = self.path
        var cpath = cl.path
        if spath < 0{
            spath = -spath
        }
        if cpath < 0{
            cpath = -cpath
        }
        if spath > cpath {
            return true
        }
        else{
            return false
        }
    }
    func isLessThan(cl:CircleLocation) -> Bool{
        if cost < cl.cost {
            return true
        }
        else{
            return false
        }
    }
   
    func isInCircle() -> Int{
        var allConnectLoc = self.getAllConnectLocation()
        var num = 0
        for obj in allConnectLoc{
            if (obj.path > -100 && obj.path < 0)||(obj.path == 100){
                num++
            }
        }
        if num == 6 {
            return 1
        }
        else{
            return 0
        }
    }
  }