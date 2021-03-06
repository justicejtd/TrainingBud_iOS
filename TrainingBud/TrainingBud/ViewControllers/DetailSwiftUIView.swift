//
//  DetailSwiftUIView.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 16/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import SwiftUI

//struct DetailSwiftUIView: View {
//    var course1: TrainingSession
//    @Binding var show: Bool
//    @Binding var active: Bool
//    @Binding var activeIndex: Int
//    @State var appear = false
//    
//    var body: some View {
//        ScrollView {
//            VStack {
//                VStack {
//                    HStack(alignment: .top) {
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text(course1.hostId)
//                                .font(.system(size: 24, weight: .bold))
//                                .lineLimit(3)
//                                .foregroundColor(.white)
//                            Text(course1.description.uppercased())
//                                .foregroundColor(Color.white.opacity(0.7))
//                        }
//                        Spacer()
//                        ZStack {
//                            VStack {
//                                Image(systemName: "xmark")
//                                    .font(.system(size: 16, weight: .medium))
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 36, height: 36)
//                            .background(Color.black)
//                            .clipShape(Circle())
//                            .onTapGesture {
//                                self.show = false
//                                self.active = false
//                                self.activeIndex = -1
//                            }
//                        }
//                    }
//                    .opacity(appear ? 1 : 0)
//                    .animation(.linear(duration: 1))
//                    .onAppear {
//                        self.appear = true
//                    }
//                    
//                    Spacer()
//                    
//                }
//                .padding(30)
//                .padding(.top, 44)
//                .frame(height: 460)
//                .frame(maxWidth: 712)
//                .background(Color.blue)
//                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
//                .shadow(color: Color.gray.opacity(0.3), radius: 20, x: 0, y: 20)
//                
//                VStack(alignment: .leading,spacing: 30) {
//                    Text(course1.getInformation())
//                        .foregroundColor(Color("secondary"))
//                    
//                    Text("About this course")
//                        .font(.title)
//                        .fontWeight(.bold)
//                    
//                    Text("This course is unlike any other. We care about design and want to make sure that you get better at it in the process. It was written for designers and developers who are passionate about collaborating and building real apps for iOS and macOS. While it's not one codebase for all apps, you learn once and can apply the techniques and controls to all platforms with incredible quality, consistency and performance. It's beginner-friendly, but it's also packed with design tricks and efficient workflows for building great user interfaces and interactions.")
//                        .foregroundColor(Color("secondary"))
//                    
//                    Text("Requirements")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    
//                    Text("Minimal coding experience required, such as in HTML and CSS. Please note that Xcode 11 and Catalina are essential. Once you get everything installed, it'll get a lot friendlier! I added a bunch of troubleshoots at the end of this page to help you navigate the issues you might encounter.")
//                        .foregroundColor(Color("secondary"))
//                    
//                    Text("Animations")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    
//                    Text("SwiftUI provides a number of ways to animate your transitions. They even have their own physics-based built-in functions that allows you to use overshoot and apply bounciness to your animations.")
//                        .foregroundColor(Color("secondary"))
//                }
//                .padding(30)
//                .padding(.bottom, 100)
//                .frame(maxWidth: 712)
//            }
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//}
//
//struct DetailSwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailSwiftUIView()
//    }
//}
