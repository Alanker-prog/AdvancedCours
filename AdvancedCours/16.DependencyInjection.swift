//
//  DependencyInjection.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 08.04.2026.
//

// ✴️ MARK: Этот код (DI) из урока, написал свой потому что в видео используется Combine, я переделал на async/await
/*
 DI — зависимости приходят снаружи, не создаются внутри

 Зачем:
   → легко подменить реализацию (Real/Mock/Broken)
   → ViewModel не знает детали реализации
   → тестируемость — можно тестить без сети

 Три участника:
   Protocol    → контракт что умеет сервис
   Real        → реальная реализация (сеть, БД)
   Mock        → фейковая реализация (тесты, Preview)

 В SwiftUI:
   init(service: Protocol = RealService())
   → продакшен: не передаёшь ничего → берётся Real
   → Preview:   передаёшь Mock → быстро без сети
   → тесты:     передаёшь Broken → тестируешь ошибки
 */

import SwiftUI
import Combine
import Foundation

// MARK: - User

struct User: Codable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let age: Int
    let email: String
    let phone: String
    let username: String
    let password: String
    let image: String
    let height: Double
    let weight: Double
}

// MARK: - Mock

extension User {
    static var mock: User {
        User(
            id: 1,
            firstName: "Alan",
            lastName: "Parastaev",
            age: 28,
            email: "alan@example.com",
            phone: "+1234567890",
            username: "alanker",
            password: "",
            image: "https://picsum.photos/200",
            height: 180,
            weight: 75
        )
    }
}

// MARK: - Response Wrapper

struct UserArray: Decodable {
    let users: [User]
}

// MARK: - Protocol

// Контракт — что умеет делать сервис
// ViewModel знает только про протокол
// не знает про конкретную реализацию
protocol NetworkServiceProtocol {
    func getUsers() async throws -> [User]
}

// MARK: - Real Service

// Реальная реализация — ходит в сеть
final class NetworkService: NetworkServiceProtocol {
    func getUsers() async throws -> [User] {
        let (data, _) = try await URLSession.shared.data(
            from: URL(string: "https://dummyjson.com/users")!
        )
        // ✅ dummyjson возвращает { "users": [...] }
        // нужно декодировать через UserArray
        return try JSONDecoder().decode(UserArray.self, from: data).users
    }
}

// MARK: - Mock Service

// Фейковая реализация — для тестов и Preview
// не ходит в сеть — возвращает готовые данные
final class MockNetworkService: NetworkServiceProtocol {
    func getUsers() async throws -> [User] {
        return [User.mock, User.mock, User.mock]
    }
}

// MARK: - Broken Service

// Ещё один вариант — для теста ошибок
final class BrokenNetworkService: NetworkServiceProtocol {
    func getUsers() async throws -> [User] {
        throw URLError(.notConnectedToInternet)
    }
}

// MARK: - ViewModel

@MainActor
final class UserViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Зависимость приходит снаружи через init
    // ViewModel не знает Real это или Mock
    private let service: NetworkServiceProtocol
    
    // MARK: - Init
    
    init(service: NetworkServiceProtocol) {
    //           ↑
    //           принимаем протокол — не конкретный класс
    //           можно передать любую реализацию
        self.service = service
    }
    
    // MARK: - Intent
    
    func loadUsers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            users = try await service.getUsers()
            //                       ↑
            //                       вызываем метод протокола
            //                       не знаем Real или Mock
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

// MARK: - View

struct UserListView: View {
    
    @StateObject private var viewModel: UserViewModel
    
    // MARK: - Init
    
    init(service: NetworkServiceProtocol = NetworkService()) {
    //                                   ↑
    //                                   значение по умолчанию
    //                                   в продакшене — реальный сервис
    //                                   в тестах — подменяем
        self._viewModel = StateObject(
            wrappedValue: UserViewModel(service: service)
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                    
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                        Text(error)
                            .multilineTextAlignment(.center)
                        Button("Try Again") {
                            Task { await viewModel.loadUsers() }
                        }
                    }
                    .padding()
                    
                } else {
                    List(viewModel.users) { user in
                        Text(user.firstName)
                    }
                }
            }
            .navigationTitle("Users")
            .task {
                await viewModel.loadUsers()
            }
        }
    }
}

// MARK: - Preview

#Preview("Real Data") {
    UserListView(service: NetworkService())
    //                     ↑
    //                     реальный сервис — ходит в сеть
}

#Preview("Mock Data") {
    UserListView(service: MockNetworkService())
    //                     ↑
    //                     мок — мгновенно, без сети
}

#Preview("Error State") {
    UserListView(service: BrokenNetworkService())
    //                     ↑
    //                     тестируем экран ошибки
}
