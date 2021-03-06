//
//  ContentView.swift
//  SlotMachine
//
//  Created by Carina Tze on 2021-01-05.
//

import SwiftUI

struct ContentView: View {
    
    @State private var symbols = ["apple", "star", "cherry"]
    @State private var numbers = Array(repeating: 0, count: 9)
    @State private var backgrounds = Array(repeating: Color.white, count: 9)
    @State private var credits = 1000
    private var betAmount = 5
    
    var body: some View {
        ZStack {
            // Background
            Rectangle().foregroundColor(Color(red: 156/255, green: 175/255, blue: 136/255))
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            Rectangle()
                .foregroundColor(Color(red: 156/255, green: 146/255, blue: 176/255))
                .rotationEffect(Angle(degrees: 45))
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                
                Spacer()
                
                // Title
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Slots Game")
                        .font(.title2)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }.scaleEffect(2)
                
                Spacer()
                
                // Credits Counter
                Text("Credits: " + String(credits))
                    .foregroundColor(.black)
                    .padding(.all,10)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(20)
                
                Spacer()
                
                // Cards
                VStack {
                    Spacer()
                    
                    HStack {
                        CardView(symbol:$symbols[numbers[0]], background: $backgrounds[0])
                        CardView(symbol:$symbols[numbers[1]], background: $backgrounds[1])
                        CardView(symbol:$symbols[numbers[2]], background: $backgrounds[2])
                    }
                    
                    HStack {
                        CardView(symbol:$symbols[numbers[3]], background: $backgrounds[3])
                        CardView(symbol:$symbols[numbers[4]], background: $backgrounds[4])
                        CardView(symbol:$symbols[numbers[5]], background: $backgrounds[5])
                    }
                    
                    HStack {
                        CardView(symbol:$symbols[numbers[6]], background: $backgrounds[6])
                        CardView(symbol:$symbols[numbers[7]], background: $backgrounds[7])
                        CardView(symbol:$symbols[numbers[8]], background: $backgrounds[8])
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                // Button
                HStack (spacing: 20){
                VStack {
                    Button(action: {
                        // Process a single spin
                        self.processResults()
                    }, label: {
                        Text("Spin")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.all, 10)
                            .padding([.leading, .trailing], 30)
                            .background(Color(red: 176/255, green: 128/255, blue: 140/255))
                            .cornerRadius(20)
                    })
                    Text("\(betAmount) credits").padding(.top, 10).font(.footnote)
                }
                
                    VStack {
                        Button(action: {
                            // Process a single spin
                            self.processResults(true)
                        }, label: {
                            Text("Max Spin")
                                .bold()
                                .foregroundColor(.white)
                                .padding(.all, 10)
                                .padding([.leading, .trailing], 30)
                                .background(Color(red: 176/255, green: 128/255, blue: 140/255))
                                .cornerRadius(20)
                        })
                        Text("\(betAmount) credits").padding(.top, 10).font(.footnote)
                    }
                }
            }
        }
    }
    
    func processResults(_ isMax:Bool = false) {
        // set backgrounds back to white
        //                    self.backgrounds[0] = Color.white
        //                    self.backgrounds[1] = Color.white
        //                    self.backgrounds[2] = Color.white
        
        self.backgrounds = self.backgrounds.map { _ in
            Color.white
        }
        
        if(isMax) {
            // spin all the cards
            self.numbers = self.numbers.map { _ in
                Int.random(in: 0...symbols.count-1)
            }
            
        } else {
            // spin the middle row
            //change the images
            self.numbers[3] = Int.random(in: 0...symbols.count-1)
            self.numbers[4] = Int.random(in: 0...symbols.count-1)
            self.numbers[5] = Int.random(in: 0...symbols.count-1)
            
        }
        processWin(isMax)
    }
    
    func processWin(_ isMax:Bool = false) {
        var matches = 0
        // check winnings
        if (!isMax) {
            
            // processing for a single spin
            if (isMatch(3, 4, 5)){ matches += 1 }
            } else {
                // Processing for max spin
                // top row
                if (isMatch(0, 1, 2)) { matches += 1 }
                
                // Middle row
                if (isMatch(3, 4, 5)) { matches += 1 }
                
                // bottom row
                if (isMatch(6, 7, 8)) { matches += 1 }
                
                // diagonal top left to bottom right
                if (isMatch(6, 7, 8)) { matches += 1 }
                
                // diagonal top right to bottom left
                if (isMatch(2, 4, 6)) { matches += 1 }
            }
            if (matches > 0) {
                // at least 1 win
                self.credits += self.betAmount * matches * 2
            } else if (!isMax) {
                // 0 wins, single spin
                self.credits -= self.betAmount
            } else {
                // 0 wins, max spin
                self.credits -= self.betAmount * 5
            }
        }
    
    func isMatch(_ index1:Int, _ index2:Int, _ index3:Int) -> Bool {
        if (self.numbers[index1] == self.numbers[index2] && self.numbers[index3] == self.numbers[index2]) {
            
            self.backgrounds[index1] = Color.green
            self.backgrounds[index2] = Color.green
            self.backgrounds[index3] = Color.green
            
            return true
        }
        return false
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
