//
//  9.ViewBuilder.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 06.01.2026.
//

import SwiftUI
/*
🔥 1)Generics + @ViewBuilder
 
🟢 struct HeaderViewGeneric<Content: View>: View {
 ◉ Это generic View, который может принимать любой SwiftUI View в качестве контента.
 ◉ Content — это тип, который обязан реализовывать View.
 
 🟢 init(title: String, @ViewBuilder content: () -> Content) {
 
 ⚠️ Ключевой момент
 ◉ @ViewBuilder позволяет возвращать несколько View без VStack
 ◉ Замыкание () -> Content превращается в один View ( по сути это тюпл(TupleView), это как кастомный VStack или НStack )
 
 📌 Благодаря этому ты можешь писать: Много раздных вью без использования VStack или НStack

 HeaderViewGeneric(title: "Generic Header") {
     Text("Текст")
     Image(systemName: "bolt.fill")
 }

 Без @ViewBuilder это бы не сработало ❌
 */
struct HeaderViewGeneric<Content:View>: View {
    let title:String
    let content:Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .bold()
            content
            
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct ViewBuilderBootcamp: View {
    var body: some View {
        VStack {
            HeaderViewGeneric(title: "Generic Header") {
                Text("В замыкание можно вставить много любых View")
                Image(systemName: "bolt.fill")
            }
            
            Spacer()
        }
        
    }
}

#Preview {
    // 1)Generics + @ViewBuilder 👆
    //ViewBuilderBootcamp()
    
    // 2)LocalViewBuilder — локальный @ViewBuilder 👇
    LocalViewBuilder(type: .one)
}

/*
 🔥 2)LocalViewBuilder — локальный @ViewBuilder(второе использоавние @ViewBuilder)
 
 🟢 Enum для перключения выбора View
 enum ViewType {
     case one, two, three
 }
 
 
 🟢 Зачем здесь @ViewBuilder?
    ◉ Потому что: switch возвращает разные типы View, а SwiftUI требует один тип!
    ◉ @ViewBuilder: скрывает разные типы и собирает их в some View. Без него был бы compile error ❌
 
 headerSection с @ViewBuilder
 @ViewBuilder private var headerSection: some View {
     switch type {
     case .one:
         viewOne
     case .two:
         viewTwo
     case .three:
         viewThree
     }
 }
 
 
 */
struct LocalViewBuilder: View {
    
    enum ViewType {
        case one, two, three
    }
    let type: ViewType
    
    var body: some View {
        VStack {
            headerSection
        }
    }
    
    @ViewBuilder private var headerSection: some View {
        switch type {
        case .one:
            viewOne
        case .two:
            viewTwo
        case .three:
            viewThree
        }
    }
    
    private var viewOne: some View {
        Text("View One!")
    }

    private var viewTwo: some View {
        Image(systemName: "bolt.fill")
    }
    
    private var viewThree: some View {
        VStack {
            Text("View Three")
            Image(systemName: "heart.fill")
        }
    }
    
}

