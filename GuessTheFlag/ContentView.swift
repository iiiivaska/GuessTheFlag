//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Василий Буланов on 9/24/21.
//

import SwiftUI

//struct CornerRotateModifier: ViewModifier {
//    let amount: Double
//    let anchor: UnitPoint
//
//    func body(content: Content) -> some View {
//        content.rotationEffect(.degrees(amount), anchor: anchor)
//    }
//}
//
//extension AnyTransition {
//    static var pivot: AnyTransition {
//        .modifier(
//            active: CornerRotateModifier(amount: 360, anchor: .topLeading),
//            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
//        )
//    }
//}

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var animationAmount = 0.0
    @State private var opacity = 1.0
    @State private var wrongAnswer: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .gray]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        if (number == correctAnswer)
                        {
                            FlagImage(country: self.countries[number])
                                .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                                .blur(radius: wrongAnswer)
                        } else {
                            FlagImage(country: self.countries[number])
                                .opacity(opacity)
                                .blur(radius: wrongAnswer)
                        }
//                        Image(self.countries[number])
//                            .renderingMode(.original)
//                            .clipShape(Capsule())
//                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
//                            .shadow(color: .black, radius: 2)
                    }
                }
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                opacity = 1
                wrongAnswer = 0
                self.askQuestion()
            })
        }
    }
    
    func flagTapped (_ number: Int) {
        if (number == correctAnswer) {
            withAnimation {
                animationAmount += 360
                opacity = 0.25
            }
            score += 1
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong! That`s the flag of \(countries[number])"
            score = score > 0 ? score - 1 : 0
            withAnimation {
                wrongAnswer = 5
            }
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
