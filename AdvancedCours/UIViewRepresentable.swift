import SwiftUI

// MARK: - Preview View

struct UIViewRepresentableBootcamp: View {
    
    @State private var text: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text(text)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            // MARK: SwiftUI TextField
            HStack {
                Text("SwiftUI:")
                    .frame(width: 60, alignment: .leading)
                
                TextField("Type here...", text: $text)
                    .frame(height: 55)
                    .padding(.horizontal, 8)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            // MARK: UIKit TextField
            HStack {
                Text("UIKit:")
                    .frame(width: 60, alignment: .leading)
                
                UITextFieldViewRepresentable(text: $text)
                    .updatePlaceholder("New placeholder!!!")
                    .frame(height: 55)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Preview

#Preview {
    UIViewRepresentableBootcamp()
}

// MARK: - UITextField Representable

struct UITextFieldViewRepresentable: UIViewRepresentable {
    
    // MARK: Properties
    
    @Binding var text: String
    var placeholder: String
    let placeholderColor: UIColor
    
    // MARK: Init
    
    init(
        text: Binding<String>,
        placeholder: String = "Default placeholder...",
        placeholderColor: UIColor = .red
    ) {
        self._text = text
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
    }
    
    // MARK: UIViewRepresentable
    
    func makeUIView(context: Context) -> UITextField {
        let textField = getTextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    // SwiftUI → UIKit
    // Вызывается каждый раз когда SwiftUI обновляет View
    // Синхронизируем text из SwiftUI в UITextField
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    // UIKit → SwiftUI
    // Coordinator перехватывает события UITextField
    // и обновляет @Binding text
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    // MARK: Modifier
    
    func updatePlaceholder(_ text: String) -> UITextFieldViewRepresentable {
        var viewRepresentable = self
        viewRepresentable.placeholder = text
        return viewRepresentable
    }
    
    // MARK: Private
    
    private func getTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: placeholderColor]
        )
        return textField
    }
}

// MARK: - Coordinator

extension UITextFieldViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        // Срабатывает при каждом изменении текста в UITextField
        // Передаём новое значение в SwiftUI через @Binding
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}

// MARK: - Basic UIView Example

struct BasicUIViewRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
//                              ↑
//                              убрал some — не нужен здесь
//                              updateUIView требует конкретный тип
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
//                      ↑
//                      UIView вместо UIViewType — конкретный тип
    }
}
