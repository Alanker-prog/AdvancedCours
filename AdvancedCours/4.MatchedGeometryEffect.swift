//
//  4.MatchedGeometryEffect.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 03.01.2026.
//

import SwiftUI

struct MatchedGeometryEffectBootcamp: View {
    /*
     🟢 categories
        ◉ Массив названий вкладок (категорий).

     🟢 @State selected -
        ◉ Хранит текущую выбранную категорию
        ◉ При изменении → SwiftUI перерисовывает View

    🟡 @Namespace
       ◉ Создаёт пространство имён для matchedGeometryEffect
       ◉ Связывает разные View как одно и то же визуальное тело

     Без него анимация работать не будет
     */
    let categories: [String] = ["Home", "Popular", "Saved"]
    @State private var selected: String = ""
    @Namespace private var namespace
    
    /*
     ✴️ Что тут происходит:
     🟢 Этот RoundedRectangle:
        ◉ Появляется только у выбранной категории
        ◉ Является визуальным индикатором (полоска под текстом)

     🟢 matchedGeometryEffect:
     ◉ Все эти прямоугольники имеют один и тот же id
     ◉  SwiftUI считает их одним и тем же объектом
     ◉ При смене selected: старый исчезает, a новый появляется и геометрия анимированно “перетекает”
     ◉ Визуально: полоска плавно переезжает от одной категории к другой
     
   ✴️ Обработка нажатия
     .onTapGesture {
         withAnimation(.spring()) {
             selected = category
         }
     }
     📌 При тапе:
     ◉ Меняется selected
     ◉ Запускается spring-анимация
     ◉ SwiftUI: обновляет View и matchedGeometryEffect анимирует перемещение индикатора
     */
    var body: some View {
        HStack{
            ForEach(categories, id: \.self) { category in
                ZStack(alignment: .bottom) {
                    if category == selected {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.pink.opacity(0.8))
                            .matchedGeometryEffect(id: "category_background", in: namespace)
                            .frame(width: 40, height: 3)
                            .offset(y: 10)
                    }
                    
                    
                    Text(category)
                        .foregroundStyle(selected == category ? .red : .white)
                }
                .frame(maxWidth: .infinity)
                .frame( height: 55)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selected = category
                    }
                }
               
            }
        }
        
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        MatchedGeometryEffectBootcamp()
    }
}
