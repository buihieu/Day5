//
//  WordCounter.swift
//  DemoClass
//
//  Created by techmaster on 9/9/14.
//  Copyright (c) 2014 Techmaster. All rights reserved.
//

import UIKit
infix operator =~ {}
func =~ (string: String, regex: NSRegularExpression) -> Bool {
    let matches = regex.numberOfMatchesInString(string,
        options: nil,
        range: NSMakeRange(0, countElements(string)))
    return matches > 0
}
class Word {
    var word: String   //Nội dung của từ
    var count: Int = 0 //số đếm lần lặp lại của từ. Mặc định là 0
    init(word: String) {
        self.word = word
        count = 1
    }
    //Nếu gặp lại từ thì tăng biến đếm lên 1
    func increment() {
        self.count += 1
    }
}
class WordCounter: ConsoleScreen {
    //Định nghĩa một mảng kiểu Word
    var WordCountNSort: [Word] = [Word]()
    let dummyWords = ["", " ","a", "all", "an", "i", "in", "is", "it", "are", "were", "he", "she", "they", "it's", "my", "his", "her", "their", "this", "that", "very", "much"]
    
    let numrex = NSRegularExpression(pattern: "^\\d+$", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*  if let plainString = self.readFileToString("data.txt") {
        self.countWord(plainString)
        }*/
        
        self.countWord("I like this. i hate that dog. Cat is fun,joke,love: is it cool?. dog,flower;dog. hate is bad hate.Love is all around. Red blue green yellow violet sexy")
        //self.countWord("aa nn mm cc kk ee cc bb bb ee dd aa")
        //self.countWord("cc kk cc")
    }
    
    func readFileToString(textFile: String) -> String? {
        let fileNameArr = textFile.componentsSeparatedByString(".")
        if fileNameArr.count != 2 { return nil }
        
        let filePath = NSBundle.mainBundle().pathForResource(fileNameArr[0], ofType: fileNameArr[1])
        println("\(filePath)")
        
       // return String.stringWithContentsOfFile(filePath!, encoding: NSUTF8StringEncoding, error: nil)
        return String(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: nil)
    }
    func shouldRemoveThisWord(word: String) -> Bool {
        //Kiểm tra xem dummyWords có chứa word không. Nếu chứa thì loại bỏ, không đếm nữa
        if contains(dummyWords, word) { return true }
        
        //Tôi viết một toán tử đặc biệt để kiểm tra word có match với numrex là một đối tượng regular expression không
        if (word =~ numrex!) { return true }
        return false;
    }
    
    func countWord(inputString: String) {
        let separator = NSMutableCharacterSet(charactersInString: " .,:;?!")
        let rawWordArray = inputString.lowercaseString.componentsSeparatedByCharactersInSet(separator)
        
        /* ok nhung khong sort duoc
        let wordSet = NSCountedSet()
        for word in rawWordArray {
        if !self.shouldRemoveThisWord(word) {
        wordSet.addObject(word)
        }
        }
        
        for word in wordSet {
        self.writeln("\(word) : \(wordSet.countForObject(word))")
        }*/
        
        for word in rawWordArray {
            if !self.shouldRemoveThisWord(word) {
                self.insertWordToWordCountNSort(word)
            }
        }
        
        for item in WordCountNSort {
            self.writeln("\(item.word) : \(item.count)")
        }
        
    }
    
    func insertWordToWordCountNSort(word: String) {
        var index = 0
        if (WordCountNSort.count == 0) {
            WordCountNSort.append(Word(word: word))
            return
        }
        //Tìm ví trị thích hợp để chèn từ vào
        for item in WordCountNSort {
            //Nếu word nhỏ hơn thì chèn luôn
            if (word < item.word) {
                WordCountNSort.insert(Word(word: word), atIndex: index)
                return
            } else if (word == item.word) {   //Nếu bằng (lặp lại) thì tăng biến đếm
                item.increment()
                return
            } else if (word > item.word) {    //Nếu lớn hơn thì duyệt tiếp phần tử sau của mảng
                index++
                if (index == WordCountNSort.count) {
                    WordCountNSort.append(Word(word: word))
                }
            }
        }
    }
}