//
//  SubscriberView.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/20/25.
//
import SwiftUI
import Combine

class PublisherViewModel: ObservableObject {
    @Published var count: Int = 0
    @Published var textField: String = ""
    @Published var isEditing: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setUpTimer()
        addTextSubscribers()
    }
    
    func addTextSubscribers() {
        $textField
            .map { text -> Bool in
                if text.count > 3 {
                    return true
                }
                return false
            }
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] isEditing in
                withAnimation(.spring) {
                    self?.isEditing = isEditing
                }
            })
            
            .store(in: &cancellables)
    }
    
    func setUpTimer() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.isEditing ? self.count += 1 : nil
            })
            .store(in: &cancellables)
    }
    
    
}

struct SubscriberView: View {
    let title: String
    @StateObject private var viewModel = PublisherViewModel()
    @State private var isClicked: Bool = false
    
    var body: some View {
        VStack {
            Group {
                Text("\(viewModel.count)")
                    .font(.system(size: 100)).bold()
                    .padding()
            }
            Group {
                Text("3글자 이상이 되면..isEditing : \(viewModel.isEditing)")
                    .font(.title3).bold()
                TextField("입력이 있을때만 Timer가 작동합니다", text: $viewModel.textField)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        HStack {
                            Spacer()
                                Text(viewModel.isEditing ? "✅" : "❌")
                                    .padding(.trailing)
                        }
                    }
                Button(action: {
                    isClicked = true
                }, label: {
                    Text("경고")
                        .frame(maxWidth: .infinity)
                        .padding(10)
                })
                .tint(.red).bold().font(.title3).buttonStyle(.borderedProminent)
                .disabled(!viewModel.isEditing)
                .alert(isPresented: $isClicked) {
                    Alert(title: Text("경고를 누르셨네요"), primaryButton: .destructive(Text("취소")), secondaryButton: .default(Text("확인")))
                }
            }
        }
        .padding()
    }
}

#Preview {
    SubscriberView(title: "구독 연습")
}
