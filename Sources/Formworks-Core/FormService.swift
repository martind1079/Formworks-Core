//
//  FormService.swift
//  FWNavigation
//
//  Created by Martin Doyle on 17/02/2023.
//

import Combine
import Foundation

public class FormManager: ObservableObject {
    let form: FWForm
    @Published var scrollOffset: CGPoint = .zero
    
    
    init(form: FWForm) {
        self.form = form
    }
}

public class FormLoader {
    public enum Result {
        case success(form: FWForm)
        case failure
    }
    
    public func load(_ template: String, completion: @escaping (Result) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            
            guard let form = MockData.testForm else {
                completion(.failure)
                return
            }
            completion(.success(form: form))
        })
    }
}

public class FormService: ObservableObject {
    
    @Published var forms: [FormData] = []
    private var cancellables = Set<AnyCancellable>()
    
    public enum LoadingState {
        case waiting
        case loading
        case loaded
    }
    let loader: FormLoader
    let formReceiver: FormReceiver
    
    public init(loader: FormLoader, formReceiver: FormReceiver, formRepo: FormRepository) {
        self.loader = loader
        self.formReceiver = formReceiver
        formRepo.observeForms().sink { forms in
            self.forms = forms
        }
        .store(in: &cancellables)
    }
    
    @Published var loadingState: LoadingState = .waiting

    
    public func loadTemplate(_ template: String) {
        loadingState = .loading
        loader.load(template) { [weak self] result in
            switch result {
            case .success(let form):
                self?.loadingState = .loaded
                self?.formReceiver.didSelectForm(form)
            case .failure:
                self?.loadingState = .waiting
                break
            }
        }
    }

    
    func loadForm(_ form: String, for template: String) {
        
    }
    
}
