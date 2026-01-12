//
//  ScrollViewOffsetPreferenceKey.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 10.01.2026.
//

import SwiftUI

// MARK: В соседнем файле в этой папке есть такой же код, но реализация через @Binding
/*
 🔸 Если ДАННЫЕ: @State, @Binding, @Observable
 🔸 Если СОБЫТИЕ: @escaping, .onAppear, .onTapGesture
 🔸Если LAYOUT: scrollPosition, scrollTransition, safeAreaInset
 */

// MARK: - PreferenceKey
/*
 🔥 PreferenceKey — механизм SwiftUI для передачи данных из дочерних в родительские вью.
 
 🟢 struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    ◉ объявляешь собственный 🔑(ключ) предпочтений, который будет передавать значение типа CGFloat (обычно offset). С низу на верх(работает как NavigationTitle)
 
 🟢 static var defaultValue: CGFloat = 0
    ◉ Значение по умолчанию. Используется, если ни один дочерний View не установил значение
    ⚠️ defaultValue — начальное значение
 
 🟢 static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    ⚠️ reduce — вызывается, если значений несколько(имеется ввиду что при смешении(offset) в ScrollView приходят постоянно новые значения, для этого нужен метод reduce)
 
 🟢 value = nextValue() - берем оновое последние смешение(offset) и сохраняем в value
    Пример альтернатив:
     ◉ value += nextValue()     // суммировать
     ◉  value = max(value, nextValue()) // взять максимум
 */
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - View Extension (@escaping)
/*
 🔥Это расширение добавляет к любому View возможность следить за его вертикальной позицией на экране.

🟢 (_ action: @escaping (_ offset: CGFloat) -> ())
    ◉ action — замыкание,оно принимает смещение CGFloat и ничего не возвращает
    ◉ @escaping Замыкание помечается как @escaping, если оно будет вызвано ПОЗЖЕ,тоесть оно ожидает когда поступят новые значения при смещении
 
 🟢 GeometryReader узнаёт и расчитывает положение View
 
 🟢 .preference  когда (При скролле значение меняется) preference Передаёт minY наверх через PreferenceKey
     ◉.frame(in: .global).minY → вертикальная позиция, это значение отправляется через PreferenceKey
     ◉ .global).minY - Вычисляет где верхняя(minY) граница относительно всего экрана (global)

 🟢 onPreferenceChange(...) { value in
       action(value)
    }
    ❕ onPreferenceChange хранит замыкание и ждет изменения от ключа ScrollViewOffsetPreferenceKey
    ❕Как только меняется offset(приходят новые даныне)спабатывает (@escaping) и вызывается action(offset)
  
 ⚠️ Поэтому Swift требует @escaping
  Что было бы без @escaping. Если убрать @escaping, компилятор скажет: Escaping closure captures non-escaping parameter
 ❌ Swift думает: «Ты пытаешься сохранить замыкание и вызвать его позже — так нельзя без @escaping»
 */
extension View {
    func OnScroolViewOffsetChange(_ action: @escaping (_ offset: CGFloat) -> ()) -> some View {
        self
            .background {
                GeometryReader { geo in
                    Text("")
                        .preference(key: ScrollViewOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
            }
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                action(value)
            }
    }
}

// MARK: - Main View
/*
🟢 .opacity(Double(scrollViewOffset) / 78.0)
   ◉ Изменяет прозрачность в зависимости от скролла
   ◉ Чем выше скролл → тем меньше прозрачность

🟢 OnScroolViewOffsetChange { offset in
   ◉ Передаёт текущий offset в scrollViewOffset

 🟢 .overlay {
       Text("\(scrollViewOffset)")
   }
   ◉ Просто отображает текущее значение offset на экране.

 
 🟢 .overlay(alignment: .top) {
       navBarLayer
           .opacity(scrollViewOffset < -7.0 ? 1.0 : 0.0)
   }
 ◉ Красный Навбар появляется, когда пользователь прокрутил вниз ,Порог: -7
 ⚠️ Это имитация стандартного NavigationTitle.
 */
struct ScrollViewOffsetPreferenceKeyMain: View {
    
    let title: String = "New Title Here!"
    @State var scrollViewOffset: CGFloat = 0
    
    var body: some View {
        
            ZStack {
                Color.gray.ignoresSafeArea()
                ScrollView {
                    VStack {
                        titleLayer
                            .opacity(Double(scrollViewOffset) / 78.0)
                            .OnScroolViewOffsetChange { offset in
                                self.scrollViewOffset = offset
                            }
                            
                        
                        contentLayer
                    
                    }
                    .padding()
                }
                .overlay(content: {
                    Text("\(scrollViewOffset)")
                })
                .overlay(alignment: .top) {
                        navBarLayer
                        .opacity(scrollViewOffset < -7.0 ? 1.0 : 0.0)
                }
            }
        }
    }

// MARK: - Preview

#Preview {
    ScrollViewOffsetPreferenceKeyMain()
}

// MARK: - Subviews

extension ScrollViewOffsetPreferenceKeyMain {
    
    private var titleLayer: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var contentLayer: some View {
        ForEach(0..<30) { _ in
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 300,height: 200)
                .foregroundStyle(Color.blue.opacity(0.5))
        }
    }
    
    private var navBarLayer: some View {
        Text(title)
        .font(.headline)
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .background(.red)
    }
}
