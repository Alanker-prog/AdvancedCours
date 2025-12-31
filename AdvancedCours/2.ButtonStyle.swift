//
//  2.ButtonStyle.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 28.12.2025.
//

import SwiftUI

/*
 ✴️ Это переиспользуемый стиль кнопки, который реагирует на нажатие, масштабируя и затемняя её, и она обернута  в удобный модификатор для чистого и читаемого кода.
 
🟢 struct PressableButtonStyle: ButtonStyle {
   ➡️ Создаем собственный стиль кнопки.
   ⚠️ ButtonStyle — это протокол, который говорит SwiftUI: «Я опишу, как выглядит кнопка в разных состояниях».
 
 🟢 let scaledAmaunt: CGFloat
    ➡️ Это коэффициент масштабирования кнопки при нажатии.
    🔸0.95 → кнопка немного уменьшается
    🔸 1.2 → кнопка увеличивается
    🔸  1.0 → без изменений
 
 🟢 init (scaledAmaunt: CGFloat) {
         self.scaledAmaunt = scaledAmaunt
    }
    ➡️ Позволяет передавать scaledAmaunt при использовании стиля.
    ⚠️ Без этого ты не смог бы настраивать эффект извне.

 🔥 makeBody(configuration:) — это сердце стиля
 🟢 func makeBody(configuration: Configuration) -> some View {
 ➡️ SwiftUI вызывает этот метод каждый раз, когда: кнопка рисуется или меняется состояние (нажата / не нажата)
 
 ❕configuration❕Это объект, который SwiftUI передаёт стилю:
    ➡️ configuration.label → внутренний контент кнопки (Text, HStack, что угодно)
    ➡️ configuration.isPressed → true, если кнопка сейчас нажата
 
 🔹 Что происходит внутри
 🟢 configuration.label
       .scaleEffect(configuration.isPressed ? scaledAmaunt : 1.0)
       .opacity(configuration.isPressed ? 0.9 : 1.0)

 Читаем как предложение: «Если кнопка нажата → масштабируй её до scaledAmaunt и сделай чуть прозрачнее»

 🔁 Когда палец отпускают — всё возвращается обратно.
 ⚠️ ВАЖНО: Ты не создаёшь новую кнопку, а модифицируешь label, который SwiftUI тебе передал.
 
 🟢 extension View { ➡️ Создаем расширение что бы сократить код в основном view
 
 Вместо:
 ❌ .buttonStyle(PressableButtonStyle(scaledAmaunt: 0.95))

 Ты можешь писать:
 ✅ .withPressableStyle()
 или
 ✅ .withPressableStyle(scaledAmaunt: 1.2)
 
 🟢 withDefaultButtonFormatting() — кастомное расширение, которого нет в стандартном SwiftUI
 
 🟢 .withPressableStyle(scaledAmaunt: 1.2)
 ➡️ Когда пользователь нажимает кнопку:
    кнопка увеличивается на 20%
    становится чуть прозрачнее

 ➡️ Это работает, потому что:
    Button использует PressableButtonStyle
    SwiftUI сам переключает isPressed

 4️⃣ Важная концепция (очень важно понять)
 ❗ ButtonStyle:
 не знает, что внутри кнопки, не хранит состояние, реагирует на состояние, которое даёт SwiftUI

 SwiftUI делает примерно так:
 нажали кнопку →
 isPressed = true →
 перерисовать makeBody →
 анимация
 */
struct PressableButtonStyle: ButtonStyle {
    
    let scaledAmaunt: CGFloat
    
    init (scaledAmaunt: CGFloat) {
        self.scaledAmaunt = scaledAmaunt
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaledAmaunt : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            //.brightness(configuration.isPressed ? 0.05 : 0)
    }
}

extension View {
    
    func withPressableStyle(scaledAmaunt: CGFloat = 0.95) -> some View {
        buttonStyle(PressableButtonStyle(scaledAmaunt: scaledAmaunt))
    }
}

struct ButtonStyleBootcamp: View {
    var body: some View {
        Button {
            
        } label: {
            Text("Click Me")
                .font(.headline)
                .withDefaultButtonFormatting()
        }
        .padding()
        .withPressableStyle(scaledAmaunt: 1.2)
    }
}

#Preview {
    ButtonStyleBootcamp()
}
