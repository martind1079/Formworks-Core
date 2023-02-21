//
//  WorkflowService.swift
//  FWNavigation
//
//  Created by Martin Doyle on 17/02/2023.
//

import Foundation

class WorkflowService: ObservableObject {
    
    enum Result {
        case error(Error)
        case success
    }
    
    enum WorkflowState {
        case start
        case requiresData
        case processingAction
        case complete
    }
    @Published var isShowingAlert = false
    var alertItem: AlertItem? {
        didSet {
            isShowingAlert = true
        }
    }
    
    
    
    @Published var state: WorkflowState = .start
    var actions: [WFActionItem] = [WFActionItem(title: "Action 1"), WFActionItem(title: "Action 2")]
    
    init(actions: [WFActionItem] = []) {
       // self.actions = actions
    }
    
    func alertForRequierdFields() {
        let okItem = ButtonItem(title: "OK", action: {})
        alertItem = AlertItem(title: "Warning", message: "Please enter all required fields.", buttonItems: [okItem])
    }
    
    func actionRequested(form: FWForm, completion: @escaping (WorkflowService.Result) -> Void) {
        state = .processingAction
        form.validate { [weak self] isValid in
            if isValid {
                self?.state = .complete
                completion(.success)
            } else {
                self?.state = .requiresData
                completion(.error(NSError()))
            }
        }
    }
}
