//
//  PreferenceKayNav.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 08.01.2026.
//
/*
 🔥Общая идея кода (в одном предложении)
    ◉ Дочерний экран (SecondaryScreen) асинхронно получает данные и “сообщает” родителю (PreferenceKayNav), каким должен быть navigationTitle.
    ◉ Это поток данных снизу вверх, что в SwiftUI делается только через PreferenceKey.
 
 Главное, что нужно запомнить 🧠
 ✅ PreferenceKey:
    ◉ передаёт данные снизу вверх
    ◉ работает только в рамках одной иерархии
    ◉ не заменяет @State или @Binding

 ✅ Используется когда:
    ◉ дочерний view не должен знать о родителе
    ◉ нужно влиять на layout / navigation / safe area
    ◉ PreferenceKey — это как “дочерний view передает записку родителю”
 */
import SwiftUI
/*
 🔥 PreferenceKayNav — родитель
 
 ◉ @State text — источник правды для заголовка навигации
 ◉ При изменении text → navigationTitle обновляется

 NavigationStack {
     VStack {
         SecondaryScreen()
     }
 Иерархия:

 NavigationStack
  └─ VStack
     └─ SecondaryScreen

⚠️ Важно: SecondaryScreen не знает про NavigationStack и navigationTitle.

🟢.navigationTitle(text)
   ◉ Navigation bar подписан на text
   ◉ Любое изменение text → обновление UI

 🔥 Ключевой момент
    ◉ Этот модификатор: слушает PreferenceKey и получает значения от всех дочерних view
    ◉ Как только SecondaryScreen отправит новое значение: text обновится и navigationTitle изменится
 .onPreferenceChange(CustomTitlePreferenceKey.self) { value in
     if let value {
         text = value
     }
 }
 */
struct PreferenceKayNav: View {

    @State private var text: String = "Hello World!"

    var body: some View {
        NavigationStack {
            VStack {
                SecondaryScreen()
            }
            .navigationTitle(text)
            .onPreferenceChange(CustomTitlePreferenceKey.self) { value in
                if let value {
                    text = value
                }
            }
        }
    }
}
/*
 🔥 Это расширение для более чистого кода в SecondaryScreen
 ❕Так SwiftUI API выглядит чисто и декларативно, как дефолтный .navigationTitle.
 
 ◉ Вместо: .preference(key: CustomTitlePreferenceKey.self, value: newValue)
 ◉ Ты пишешь: .customTitle(newValue)
 */
extension View {
    func customTitle(_ text: String?) -> some View {
        preference(key: CustomTitlePreferenceKey.self, value: text)
    }
}

/*
 🔥 SecondaryScreen — источник данных
 
 🟢 @State private var newValue: String? = nil
    ◉ Значение отсутствует при старте
    ◉ Это важно, чтобы не отправлять пустую строку

 🟢 Text("Secondary screen")
      .customTitle(newValue)
 💡 Что происходит:
    ◉ Каждый раз, когда body пересчитывается:
    ◉ значение newValue отправляется вверх как Preference

 ◉ Пока newValue == nil → ничего не происходит, но далее симулирум получкние данных👇

🟢 Симуляция загрузки данных
 ◉ Через 2 секундыт и newValue меняется далее body пересчитывается и Preference отправляется наверх
 .onAppear {
     DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
         newValue = "NEW VALUE FROM DATABASE"
     }
 }
 */
struct SecondaryScreen: View {

    @State private var newValue: String? = nil

    var body: some View {
        Text("Secondary screen")
            .customTitle(newValue)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    newValue = "NEW VALUE FROM DATABASE"
                }
            }
    }
}

/*
 🔥 CustomTitlePreferenceKey — канал связи
 
 🟢 struct CustomTitlePreferenceKey: PreferenceKey - Это тип-ключа 🔑
    ◉ По которому SwiftUI понимает: «Эти значения относятся к одной логической настройке»
 
 🟢 static var defaultValue: String? = nil
    ◉ Значение по умолчанию Используем Optional, чтобы: отличать “нет значения” от “пустая строка”

 🟢 static func reduce(value: inout String?, nextValue: () -> String?) {
       value = nextValue() ?? value
    }
 🧠 Самый важный метод
 Он говорит SwiftUI:
 ◉ «Если есть новое значение — используй его, если нет — оставь старое»
 ◉ Это нужно, если: в иерархии несколько источников значения приходят не одновременно
 */
struct CustomTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String? = nil

    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue() ?? value
    }
}

#Preview {
    PreferenceKayNav()
}
