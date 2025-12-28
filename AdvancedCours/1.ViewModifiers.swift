//
//  1.ViewModifiers.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 26.12.2025.
//

import SwiftUI

/*
 🔥 Cоздаем кастомный модификатор представления DefaultButtonViewModifiers типа ❕ViewModifier(вид модификатора)❕
    ⚠️ У ViewModifier есть тело(body), оно находится в методе и содержит Content
       ➡️ content — это то View, к contentу мы применяем модификаторы и далее можем применить все эти праметры к любому тексту(Text), что бы быстро сдать кнопку вызвав .modifier
    ❌ Не применять к contentу модификаторы .font и .padding(), потому что шрифт у кнопок может отличаться на разных экранах как и фактическое растояния от края экрана, лучше .padding() задавть на прямую 
 
 🟢 let backgroundColor: Color
    ➡️ Модификатор принимает параметр — цвет фона, мы сможем переназначать цвет фона в коде через этот параметр
 */
struct DefaultButtonViewModifiers: ViewModifier {
    
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            //.font(.callout)
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(20)
            //.padding()
    }
}

/*
 🔥 Создаем расширение что бы еще немного сократить код в оновном теле
   🟢 (backgroundColor: Color = .orange) - задаем цвет по умочанию, кнопка автоматом будет оранжевой, но вызвав в коде модификатор с доп параметром .withDefaultButtonFormatting(backgroundColor: .green) все равно сможем изминить цвет.
 
   🟢 Этот модификатор задаем по умолчанию в рвсширении modifier(DefaultButtonViewModifiers(backgroundColor: backgroundColor))
       ➡️ После чего можно вызывать модификатор напрямую .withDefaultButtonFormatting
       ➡️ Если нужно изменить цвет вызови модификатор с доп параметром .withDefaultButtonFormatting(backgroundColor: .green)
 */
extension View {
    
    func withDefaultButtonFormatting(backgroundColor: Color = .orange) -> some View {
        modifier(DefaultButtonViewModifiers(backgroundColor: backgroundColor))
    }
}

/*
 🔥Применяем наши кастомные модификаторы к тексту что бы привратить их в кнопки!
 
 1️⃣ Text. Прямое использование через модификатор modifier(зеленая кнопка)
 
 2️⃣ Text. Через extension-метод(желтая кнопка), но вызван дополнительный параметр функции из рассширения (backgroundColor: .yellow) для изминения цвета.
 
 3️⃣ Text. тоже Через extension-метод, но со значением по умолчанию (backgroundColor: Color = .orange)
 */
struct ViewModifiersBootcamp: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Hello, World!")
                .modifier(DefaultButtonViewModifiers(backgroundColor: .green))
            
            Text("Hello, everyone!")
                .withDefaultButtonFormatting(backgroundColor: .yellow)
            
            Text("Hello!")
                .withDefaultButtonFormatting()
        }
        .padding()
        
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ViewModifiersBootcamp()
    }
    
}
