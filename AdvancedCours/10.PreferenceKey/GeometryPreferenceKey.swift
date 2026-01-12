//
//  GeometryPreferenceKey.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 09.01.2026.
//

import SwiftUI

struct GeometryPreferenceKey: View {
    
 var textWidth = ["Something", "Something Bigger", "Smoll"]
    
    // ⚠️ Измерить всю фигуру использовать CGSize ⚠️
    @State private var maxWidth: CGFloat = 300 // Измеряет только ширину
    
    var body: some View {
        VStack {
            /*
             Что здесь происходит:
             🔸 GeometryReader
                ◉ Он измеряет размер Text
                ◉ geo.size.width — фактическая ширина конкретного текста
             
             🔸 .overlay { GeometryReader }
                ◉ overlay не влияет на размер Text
                ◉ Используется только для «подглядывания» за размерами

             🔸 Color.clear
                ◉ Прозрачный view Нужен просто как контейнер
                ◉ Он накладывается на text как невидимый контейнер

             🔸 .maxViewWidth(geo.size.width)
                ◉ Передаёт ширину наверх через PreferenceKey
             */
            ForEach(textWidth, id: \.self) { text in
                Text(text)
                    .overlay {
                        GeometryReader { geo in
                            Color.clear
                                .maxViewWidth(geo.size.width)
                        }
                    }
            }
            Rectangle()
                .fill(.blue)
                .frame(width: maxWidth, height: 2)
        }
        /*
         🔥 Получение значения в родителе
            ◉ Когда хоть один Text изменит ширину, обновится newValue
            ◉ Далее newValue передаст значение в maxWidth
         ⚠️ Как итог maxWidth указан в рмаке(.frame) у Rectangle() в месте с текстом увиличится и Rectangle()-синяя поллска⚠️
         */
        .onPreferenceChange(MaxViewWidth.self) { newValue in
            maxWidth = newValue
        }
    }
}

#Preview {
    GeometryPreferenceKey()
}
/*
🔥 PreferenceKey — передача данных снизу вверх
   ◉ PreferenceKey позволяет передавать данные от дочерних view к родителю
   ◉ defaultValue = 0 — стартовое значение
   ◉ reduce: вызывается для каждого Text и выбирает максимальную ширину
   ◉ В итоге MaxViewWidth хранит ширину самого длинного текста
 */
struct MaxViewWidth: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
/*
🔥 Расширение для сокрашения модификатора в GeometryReader
   ✅ чтобы писать: .maxViewWidth(geo.size.width)
   ❌ вместо: .preference(key: MaxViewWidth.self, value: geo.size.width)
 */
extension View {
    func maxViewWidth(_ value: CGFloat) -> some View {
        self.preference(key: MaxViewWidth.self, value: value)
    }
}
