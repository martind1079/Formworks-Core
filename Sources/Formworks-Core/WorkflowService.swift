//
//  WorkflowService.swift
//  FWNavigation
//
//  Created by Martin Doyle on 17/02/2023.
//

import Foundation

public class WorkflowService: ObservableObject {
    
    public enum Result {
        case error(Error)
        case success
    }
    
    public enum WorkflowState {
        case start
        case requiresData
        case processingAction
        case complete
    }
    @Published public var isShowingAlert = false
    public var alertItem: AlertItem? {
        didSet {
            isShowingAlert = true
        }
    }
    
    
    
    @Published public var state: WorkflowState = .start
    public var actions: [WFActionItem] = [WFActionItem(title: "Action 1"), WFActionItem(title: "Action 2")]
    
    public init(actions: [WFActionItem] = []) {
       // self.actions = actions
    }
    
    public func alertForRequierdFields() {
        let okItem = ButtonItem(title: "OK", action: {})
        alertItem = AlertItem(title: "Warning", message: "Please enter all required fields.", buttonItems: [okItem])
    }
    
    public func actionRequested(form: FWForm, completion: @escaping (WorkflowService.Result) -> Void) {
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
