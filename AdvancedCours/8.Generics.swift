//
//  8.Generics.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 05.01.2026.
//

import SwiftUI
import Observation

/*
 🔥 GenericsView<T: View> — универсальный (generic) View
 
    ◉ <T: — любой тип,
    ◉ View> - Ограничение но любой тип. Любой тип, но только типа вью View
    ◉ content — внутри может быть любой тип который является типом View (Text, Image, Button, etc.)
    ◉ title — обычная строка

    Использование в основном View:
 🟢 GenericsView(content: Text("Custom content"), title: "New View")
 */
struct GenericsView<T: View>: View {
    let content: T
    let title: String
    
    var body: some View {
        VStack {
            content
            Text(title)
        }
    }
    
}

/*
 🔥 GenericModel<T> — универсальная модель данных
 
    ◉ T — любой тип данных
    ◉ value: T? — optional → данные могут исчезать

 🟢 Метод removeInfo()
   func removeInfo() -> GenericModel {
       GenericModel(value: nil)
   }

   ◉ удаляет данные и возвращает новую модель без данных
 */
struct GenericModel<T> {
    let value: T?
    func removeInfo() -> GenericModel {
        GenericModel(value: nil)
    }
}

/*
 🔥 @Observable GenericsViewModel — источник состояния
 
 ◉ @Observable - это макрос делает класс наблюдаемым
 ◉ все var внутри @Observable класса автоматически наблюдаемы (не нужно писать @StateObject как в Combine)
 ◉ let в нутри накого класса не наблюдаются(игнор.),не чему меняться нет смысла наблюдать
 
 ⚠️ @ObservationIgnored - исключение
    ◉ var тоже игнорируются! Используется для: ❕кеша,сервисов,логгеров❕
 
 Состояние
 🟢 var genericsStringModel = GenericModel(value: "Hello, world!")
 🟢 var genericsBoolModel = GenericModel(value: true)
    ◉ одна модель со String, а другая — с Bool
    ◉ один и тот же GenericModel<T> переиспользуется для разных типов String и Bool
 
 Логика
 🟢 func removeData() {
      genericsStringModel = genericsStringModel.removeInfo()
      genericsBoolModel = genericsBoolModel.removeInfo()
  }
    ◉ при нажатии кнопки: создаются новые модели, SwiftUI видит изменение var и View перерисовывается
 
 */
@Observable
final class GenericsViewModel {
    
     var genericsStringModel = GenericModel(value: "Hello, world!")
     var genericsBoolModel = GenericModel(value: true)
    
    func removeData() {
        genericsStringModel = genericsStringModel.removeInfo()
        genericsBoolModel = genericsBoolModel.removeInfo()
    }
}


struct GenericsBootcamp: View {
    
    @State private var vm = GenericsViewModel()
    
    var body: some View {
        VStack {
            
            GenericsView(content: Text("Custom content"), title: "New View")
            
            Text(vm.genericsStringModel.value ?? "no data")
            Text(vm.genericsBoolModel.value?.description ?? "no data")//description нужен, потому что Bool ≠ String
            
            Button("Remove") {
                vm.removeData()
            }
        }
    }
}


#Preview {
    GenericsBootcamp()
}
