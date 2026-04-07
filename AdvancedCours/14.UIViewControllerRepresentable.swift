//
//  14.UIViewControllerRepresentable.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 07.04.2026.
//

import SwiftUI
import UIKit

// ОБЪЯСНЕНИЕ
/*
 ============================================================
 🚀 UIViewControllerRepresentable — ПОЛНОЕ ПОНИМАНИЕ
 ============================================================

 Это мост между SwiftUI и UIKit.

 👉 Позволяет использовать UIViewController внутри SwiftUI

 ------------------------------------------------------------
 🧠 ЗАЧЕМ ЭТО НУЖНО
 ------------------------------------------------------------

 SwiftUI НЕ покрывает весь UIKit, например:

 - UIImagePickerController (камера / галерея)
 - UITextView
 - WKWebView
 - сторонние UIKit библиотеки

 👉 Поэтому нужен "bridge"

 ------------------------------------------------------------
 🔥 ЖИЗНЕННЫЙ ЦИКЛ (САМОЕ ВАЖНОЕ)
 ------------------------------------------------------------

 1. makeUIViewController(context:)

 👉 вызывается ОДИН РАЗ
 👉 создаёт UIKit контроллер

 Пример:
    let vc = UIImagePickerController()

 ------------------------------------------------------------

 2. updateUIViewController(_:context:)

 👉 вызывается КАЖДЫЙ раз при изменении состояния SwiftUI

 Например:
 - изменился @State
 - изменился @Binding

 👉 используется для обновления UIKit

 В нашем случае:
 ❌ ничего не делаем (не нужно)

 ------------------------------------------------------------

 3. makeCoordinator()

 👉 создаёт Coordinator (связь UIKit → SwiftUI)

 Почему нужен?
 Потому что UIKit работает через delegate

 ------------------------------------------------------------
 🔁 НАПРАВЛЕНИЯ ДАННЫХ
 ------------------------------------------------------------

 SwiftUI → UIKit
    updateUIViewController

 UIKit → SwiftUI
    Coordinator (delegate)

 ------------------------------------------------------------
 🧠 COORDINATOR — КЛЮЧЕВАЯ ЧАСТЬ
 ------------------------------------------------------------

 Coordinator:

 - подписывается на delegate UIKit
 - получает события (например выбор изображения)
 - обновляет SwiftUI через @Binding

 ------------------------------------------------------------
 🔄 ПОЛНЫЙ FLOW
 ------------------------------------------------------------

 SwiftUI Button
    ↓
 sheet открывается
    ↓
 makeUIViewController()
    ↓
 пользователь выбирает изображение
    ↓
 delegate (Coordinator)
    ↓
 image = newImage
    ↓
 SwiftUI обновляется

 ------------------------------------------------------------
 💡 ЗАПОМНИ ПРОСТО
 ------------------------------------------------------------

 makeUIViewController  → создать UIKit
 updateUIViewController → обновить UIKit
 Coordinator            → вернуть данные обратно

 ============================================================
*/


// MARK: - MAIN SWIFTUI VIEW

struct UIViewControllerRepresentableBootcamp: View {
    
    // MARK: - State
    
    @State private var showScreen: Bool = false   // показывает / скрывает sheet
    @State private var image: UIImage? = nil      // выбранное изображение
    
    // MARK: - UI
    
    var body: some View {
        VStack {
            
            Text("hi")
            
            // Показываем изображение, если выбрано
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            // Кнопка открытия UIImagePickerController
            Button(action: {
                showScreen.toggle()
            }) {
                Text("Click Here")
            }
            
            // Открываем UIKit контроллер
            .sheet(isPresented: $showScreen) {
                UIImagePickerControllerRepresentable(
                    image: $image,
                    showScreen: $showScreen
                )
                
                // альтернативный пример:
                // BasicUIViewControllerRepresentable(labelText: "New text here")
            }
        }
    }
}


// MARK: - PREVIEW

struct UIViewControllerRepresentableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerRepresentableBootcamp()
    }
}


// MARK: - UIImagePickerController REPRESENTABLE

struct UIImagePickerControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - Bindings (связь со SwiftUI)
    
    @Binding var image: UIImage?
    @Binding var showScreen: Bool
    
    // MARK: - Создание UIKit контроллера
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.allowsEditing = false
        
        // delegate идёт через Coordinator
        vc.delegate = context.coordinator
        
        return vc
    }
    
    // MARK: - Обновление (SwiftUI → UIKit)
    
    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {
        // вызывается при обновлении состояния
        // здесь можно менять UIKit UI
    }
    
    // MARK: - Создание Coordinator
    
    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image, showScreen: $showScreen)
    }
    
    
    // MARK: - COORDINATOR
    
    class Coordinator: NSObject,
                       UIImagePickerControllerDelegate,
                       UINavigationControllerDelegate {
        
        // MARK: - Bindings
        
        @Binding var image: UIImage?
        @Binding var showScreen: Bool
        
        // MARK: - Init
        
        init(image: Binding<UIImage?>, showScreen: Binding<Bool>) {
            self._image = image
            self._showScreen = showScreen
        }
        
        // MARK: - Delegate
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            // получаем изображение из UIKit
            guard let newImage = info[.originalImage] as? UIImage else { return }
            
            // передаём в SwiftUI
            image = newImage
            
            // закрываем экран
            showScreen = false
        }
    }
}


// MARK: - BASIC UIViewControllerRepresentable (пример)

struct BasicUIViewControllerRepresentable: UIViewControllerRepresentable {
    
    let labelText: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = MyFirstViewController()
        vc.labelText = labelText
        return vc
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) {
        // можно обновлять UI при изменении данных
    }
}


// MARK: - UIKit ViewController

class MyFirstViewController: UIViewController {
    
    var labelText: String = "Starting value"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        let label = UILabel()
        label.text = labelText
        label.textColor = .white
        
        view.addSubview(label)
        label.frame = view.frame
    }
}
