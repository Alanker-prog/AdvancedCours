//
//  3.AnyTransition.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 02.01.2026.
//

import SwiftUI
//Это кастомный ViewModifier
/*
🟢 .rotationEffect(Angle(degrees: rotation))
    ◉ (rotationEffect) - Поворачивает вью
    ◉ (Angle(degrees: rotation)) - позволяет задать передать любой угол.
 ⚠️ Ниже в рассширении extension AnyTransition мы через функцию  static func rotating(rotation: Double)
 можем предать любой угол и сохранить его в (🟢 let rotation: Double)
 
 🟢 .offset(
    ◉ Смещает фигуру(Вью) по осям (x: и y:) за пределы экрана
 
 ‼️ Желтые ошибки у UIScreen.main.bounds.width, нужно будет исправить через GeometryReader
 */
struct RotationViewModifiers: ViewModifier {
    
    let rotation: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rotation))
            .offset(
                x: rotation != 0 ? UIScreen.main.bounds.width : 0,
                y: rotation != 0 ? UIScreen.main.bounds.width : 0)
    }
}

// Расширение для премешений и врашений
/*
 🔥 static var rotating:
 🟢 active: RotationViewModifiers(rotation: 180)
     ◉ В активном состояни фигура = (true) появляется на экране и крутится
 🟢 identity: RotationViewModifiers(rotation: 0))
     ◉ В не активном состоянии = (false) и остается на месте без поварота(тоесть за пределами экрана)
 
 🔥 static func rotating(rotation: Double)
 🟢 active: RotationViewModifiers(rotation: rotation),
    ◉ Этот метод делает тоже самое что и пременная выше, но через (rotation: rotation) можно передать любой угол (например 360, 720 или 1080)
 
 🔥  static var rotateOn: (асимметричный переход)
 ◉ Здесь разное поведение:
 🟢 Insertion (появление) → вращение
 🟢 Removal (исчезновение) → уезд влево
 ⚠️ Это называется асимметричный переход
 */
extension AnyTransition {
    
    static var rotating: AnyTransition {
        modifier(
            active: RotationViewModifiers(rotation: 180),
            identity: RotationViewModifiers(rotation: 0))
    }
    
    static func rotating(rotation: Double) -> AnyTransition {
        modifier(
            active: RotationViewModifiers(rotation: rotation),
            identity: RotationViewModifiers(rotation: 0))
    }
    
    static var rotateOn: AnyTransition {
        asymmetric(
            insertion: .rotating,
            removal: .move(edge: .leading))
    }
}

//Основной экран
/*
🟢 @State private var showRectangle: Bool = false
   ◉ управляет тем, показан прямоугольник или нет
 
 🟢 if showRectangle {
 📌 Когда showRectangle:
    ◉ true → прямоугольник появляется с анимацией
    ◉ false → исчезает с анимацией
 */
struct AnyTransitionBootcamp: View {
    
    @State private var showRectangle: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if showRectangle {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.gray)
                    .frame(width: 250, height: 400)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //.transition(.rotating(rotation: 1080)) - метод rotating
                    //.transition(AnyTransition.rotating) - пременная rotating
                    .transition(.rotateOn)
            }
            
            Spacer()
            
            Text("Click Me!")
                .withDefaultButtonFormatting()
                .padding()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1)) {
                        showRectangle.toggle()
                    }
                }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AnyTransitionBootcamp()
    }
    
}
