//
//  ProtocolsBootcamp.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 07.04.2026.
//

import SwiftUI

/*
 ============================================================
 🚀 PROTOCOLS В SWIFTUI — ПОЛНОЕ ПОНИМАНИЕ
 ============================================================

 Этот файл показывает, как использовать протоколы для:

 - абстракции данных
 - смены тем (theme)
 - смены поведения (data source)

 ------------------------------------------------------------
 🧠 ОСНОВНАЯ ИДЕЯ
 ------------------------------------------------------------

 Вместо жёсткой привязки к конкретным типам:

 ❌ DefaultColorTheme
 ❌ DefaultDataSource

 Мы используем ПРОТОКОЛЫ:

 ✅ ColorThemeProtocol
 ✅ ButtonDataSourceProtocol

 👉 Это делает код гибким и переиспользуемым

 ------------------------------------------------------------
 🔥 ЧТО МЫ РЕШАЕМ
 ------------------------------------------------------------

 Мы хотим:

 - менять цвета UI
 - менять текст кнопки
 - менять поведение кнопки

 👉 НЕ меняя сам View

 ------------------------------------------------------------
 🧩 АРХИТЕКТУРА
 ------------------------------------------------------------

 View (ProtocolsBootcamp)
    ↓
 принимает протоколы
    ↓
 конкретная реализация подставляется снаружи

 ------------------------------------------------------------
 💡 ПРЕИМУЩЕСТВА
 ------------------------------------------------------------

 - легко менять поведение
 - легко тестировать
 - можно подставлять mock данные
 - соответствует Dependency Injection

 ------------------------------------------------------------
 🧠 ПРОСТАЯ МЕТАФОРА
 ------------------------------------------------------------

 Protocol = контракт

 View говорит:
 👉 "мне не важно КТО ты, главное чтобы ты умел это делать"

 ============================================================
*/


// MARK: - COLOR THEMES (темы приложения)

protocol ColorThemeProtocol {
    var primary: Color { get }    // основной цвет (например кнопка)
    var secondary: Color { get }  // текст
    var tertiary: Color { get }   // фон
}


// MARK: - DEFAULT THEME

struct DefaultColorTheme: ColorThemeProtocol {
    let primary: Color = .blue
    let secondary: Color = .white
    let tertiary: Color = .gray
}


// MARK: - ALTERNATIVE THEME

struct AlternativeColorTheme: ColorThemeProtocol {
    let primary: Color = .red
    let secondary: Color = .white
    let tertiary: Color = .green
}


// MARK: - ANOTHER THEME

struct AnotherColorTheme: ColorThemeProtocol {
    var primary: Color = .blue
    var secondary: Color = .red
    var tertiary: Color = .purple
}


// MARK: - BUTTON PROTOCOLS

// текст кнопки
protocol ButtonTextProtocol {
    var buttonText: String { get }
}

// действие при нажатии
protocol ButtonPressedProtocol {
    func buttonPressed()
}

// объединяем оба протокола
protocol ButtonDataSourceProtocol: ButtonTextProtocol, ButtonPressedProtocol { }


// MARK: - DATA SOURCES

// полноценный data source (текст + действие)
class DefaultDataSource: ButtonDataSourceProtocol {
    
    var buttonText: String = "Protocols are awesome!"
    
    func buttonPressed() {
        print("Button was pressed!")
    }
}


// только текст (без действия)
class AlternativeDataSource: ButtonTextProtocol {
    var buttonText: String = "Protocols are lame."
}


// MARK: - MAIN VIEW

struct ProtocolsBootcamp: View {
    
    // внедрение зависимостей (Dependency Injection)
    let colorTheme: ColorThemeProtocol
    let dataSource: ButtonDataSourceProtocol
    
    var body: some View {
        ZStack {
            
            // фон
            colorTheme.tertiary
                .ignoresSafeArea()
            
            // кнопка
            Text(dataSource.buttonText)
                .font(.headline)
                .foregroundColor(colorTheme.secondary)
                .padding()
                .background(colorTheme.primary)
                .cornerRadius(10)
                .onTapGesture {
                    dataSource.buttonPressed()
                }
        }
    }
}


// MARK: - PREVIEW

struct ProtocolsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        
        // можно легко менять реализации
        ProtocolsBootcamp(
            colorTheme: DefaultColorTheme(),
            dataSource: DefaultDataSource()
        )
        
        // попробуй:
        // colorTheme: AlternativeColorTheme()
        // dataSource: DefaultDataSource()
    }
}
