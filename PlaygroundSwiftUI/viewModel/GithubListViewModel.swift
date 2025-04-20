//
//  GithubListViewModel.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/19/25.
//
// https://api.github.com/search/users?q=Kimyonhae

import Combine
import Foundation


enum NetworkError: Error, LocalizedError {
    case invalidURL
    case transportError(Error)
    case serverError(statusCode: Int)
    case decodingError(Error)
    case emptyQuery

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "오류: 유효하지 않은 URL입니다."
        case .transportError(let error): return "오류: 네트워크 통신 중 오류 발생 (\(error.localizedDescription))"
        case .serverError(let statusCode): return "오류: 서버 오류 (상태 코드: \(statusCode))"
        case .decodingError(let error): return "오류: 데이터 처리 중 오류 발생 (\(error.localizedDescription))"
        case .emptyQuery: return "검색어를 입력해주세요."
        }
    }
}


class GithubListViewModel: ObservableObject {
    @Published var users: [GithubUser] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    // 구독 관리
    private var cancelables: Set<AnyCancellable> = []
    
    init() {
        setUpSearchSubscribers()
    }
    
    // TODO: Publisher 설정
    func setUpSearchPublisher() -> AnyPublisher<[GithubUser], Never> {
        $searchText
            .debounce(for: 0.8, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] query in
                self?.isLoading = !query.isEmpty
                self?.errorMessage = nil
                if query.isEmpty {
                    self?.users = []
                }
            })
            .filter { !$0.isEmpty}
            .tryMap { query -> URLRequest in
                guard let url = URL(string: "https://api.github.com/search/users?q=\(query)") else {
                    throw NetworkError.invalidURL
                }
                return URLRequest(url: url)
            }
            .catch { [weak self] error -> Empty<URLRequest, Never> in
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
                return Empty()
            }
            .flatMap { request -> AnyPublisher<[GithubUser], Never> in
                URLSession.shared.dataTaskPublisher(for: request)
                    .tryMap { data, response -> Data in
                        guard let response = response as? HTTPURLResponse else {
                            throw NetworkError.serverError(statusCode: 0) // response 타입이 이상한 경우
                        }
                        
                        guard (200..<300).contains(response.statusCode) else {
                            throw NetworkError.serverError(statusCode: response.statusCode)
                        }
                        
                        return data
                    }
                    .decode(type: SearchResponse.self, decoder: JSONDecoder())
                    .map { jsonData in
                        jsonData.items
                    }
                    .mapError { error -> NetworkError in
                        if let urlError = error as? URLError {
                            return .transportError(urlError)
                        }else if let decodingError = error as? DecodingError {
                            return .decodingError(decodingError)
                        }else if let newError = error as? NetworkError {
                            return newError
                        }else {
                            return .transportError(error)
                        }
                    }
                    .catch { [weak self] error -> Just<[GithubUser]> in
                        DispatchQueue.main.async {
                            self?.errorMessage = error.localizedDescription
                            self?.isLoading = false
                        }
                        
                        return Just([])
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    // TODO: Subscriber 설정
    func setUpSearchSubscribers() {
        setUpSearchPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("구독 실패 Error : \(error)")
                case .finished:
                    print("구독 완료")
                }
            }, receiveValue: { [weak self] val in
                self?.users = val
                
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            })
            .store(in: &cancelables)
    }
    
    func fetchGithubUsers(username: String ,completion:@escaping (Bool) -> Void) {
        guard let url = URL(string: "https://api.github.com/search/users?q=\(username)") else {
            print(NetworkError.invalidURL)
            return completion(false)
        }
        
        if username.isEmpty { // username이 없으면 StatusCode가 422가 나옴
            self.users = []
            return completion(false)
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                print(NetworkError.transportError(error))
                return completion(false)
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<399:
                    print("정상적으로 데이터를 가져왔습니다.")
                    guard let data = data else {
                        print("Error : 데이터가 없습니다.")
                        return
                    }
                    do {
                        let jsonData = try JSONDecoder().decode(SearchResponse.self, from: data)
                        self.users = jsonData.items
                    } catch {
                        print("Error : \(error)")
                    }
                    completion(true)

                case 400..<500:
                    print(NetworkError.serverError(statusCode: response.statusCode))
                    completion(false)
                default:
                    print(NetworkError.serverError(statusCode: response.statusCode))
                    completion(false)
                }
            }
        }
        
        task.resume()
    }
}
