//
//  Home.swift
//  UI-695
//
//  Created by nyannyan0328 on 2022/10/10.
//

import SwiftUI

struct Home: View {
    @State var animated : Bool = false
    @State var b : CGFloat = 0
    @State var c : CGFloat = 0
    var body: some View {
        VStack(spacing: 15) {
            
          
            IsomtricView(depath: 25) {
                
              
                ImageView()
                
            } side: {
                
                ImageView()
                
              
                
            } bottom: {
                
                ImageView()
               
                
            }
             .frame(width: 180,height: 300)
             .modifier(CustomProjection(b: b, c: c))
             .rotation3DEffect(.init(degrees: animated ? 45 : 0), axis: (x:0, y:0, z: 1))
             .scaleEffect(0.75)

            
            VStack {
                
                VStack(alignment:.leading,spacing: 10){
                    
                    Text("Isometric View")
                    
                    HStack{
                        
                        Button("View 1"){
                            
                            withAnimation(.interactiveSpring(response: 0.5,dampingFraction: 0.8,blendDuration: 0.7)){
                                
                                animated = true
                                b = -0.2
                                c = -0.2
                            }
                            
                            
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                        
                        Button("View 2"){
                            
                            withAnimation(.easeInOut(duration: 1.1)){
                                
                                animated = true
                            }
                            
                        }
                        .buttonStyle(.bordered)
                        .tint(.orange)
                        
                        Button("REST"){
                            
                            withAnimation(.interactiveSpring(response: 0.5,dampingFraction: 0.8,blendDuration: 0.7)){
                                
                                animated = false
                            }
                            
                        }
                        
                        .buttonStyle(.bordered)
                        .tint(.green)
                        
                        
                    }
                    
                    
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
    }
    
    @ViewBuilder
    func ImageView ()->some View{
     
        Image("p1")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 200,height: 330)
            .clipped()
        
          
        
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomProjection : GeometryEffect{
    
    var b : CGFloat
    var c : CGFloat
    
    var animatableData: AnimatablePair<CGFloat,CGFloat>{
        
        get{
            
            return AnimatablePair(b, c)
            
            
        }
        set{
            
            b = newValue.first
            c = newValue.second
        }
        
    }
    
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        return .init(.init(1, b, c, 1, 0, 0))
          
    }
    
}
struct IsomtricView<Content : View,Side : View,Bottom : View> : View{
    
    var content : Content
    var side : Side
    var bottom : Bottom
    var depath : CGFloat
    
    init(depath: CGFloat,@ViewBuilder content: @escaping()->Content, @ViewBuilder side: @escaping()->Side,@ViewBuilder bottom: @escaping()->Bottom) {
        self.content = content()
        self.side = side()
        self.bottom = bottom()
        self.depath = depath
    }
    
    var body: some View{
        
        Color.clear
            .overlay {
                GeometryReader{
                    
                    let size = $0.size
                    
                    
                    ZStack{
                        
                        content
                        DepathView(isBottom: true)
                        DepathView()
                        
                        
                    }
                    .frame(width: size.width,height: size.height)
                    
                    
                    
                    
                 
                    
                }
                 
            }
    }
    @ViewBuilder
    func DepathView(isBottom : Bool = false) -> some View{
        
        ZStack{
            if isBottom{
                
                
                bottom
                    .scaleEffect(y:depath,anchor: .bottom)
                    .frame(height: depath,alignment: .bottom)
                    .overlay(content: {
                        
                        Rectangle()
                            .fill(.black.opacity(0.25))
                            .blur(radius: 5)
                    })
                    .clipped()
                    .projectionEffect(.init(.init(1, 0, 1, 1, 0, 0)))
                    .offset(y:depath)
                    .frame(maxHeight: .infinity,alignment: .bottom)
            }
            else{
                
                side
                    .scaleEffect(x:depath,anchor: .trailing)
                    .frame(width: depath,alignment: .trailing)
                    .overlay(content: {
                        
                        Rectangle()
                            .fill(.black.opacity(1))
                            .blur(radius: 5)
                    })
                     .clipped()
                    .projectionEffect(.init(.init(1, 1, 0, 1, 0, 0)))
                    .offset(x:depath)
                    .frame(maxWidth: .infinity,alignment: .trailing)
                    
                
            }
                
        }
    }
}
