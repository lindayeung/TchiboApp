//
//  NavigationStack.swift
//  GreenerBox
//
//  Created by Linda Yeung on 11/25/20.
//

import Foundation
import SwiftUI


extension View {
    func asAnyView() -> AnyView { AnyView(self) }
}

struct StackItem: Equatable{
    static func == (lhs: StackItem, rhs: StackItem) -> Bool {
        lhs.id == rhs.id
    }
    
    let view: AnyView
    
    var id = UUID()
    
    init(_ view: AnyView) {
        self.view = view
    }
}


class NavigationStackItems: ObservableObject {
    @Published fileprivate(set) var viewStack: [StackItem] = []
    
    func push(_ item: StackItem) {
        withAnimation {
            viewStack.append(item)
        }
    }

    func pop() {
        withAnimation {
            if !(viewStack.isEmpty) {
                viewStack.remove(at: viewStack.count - 1)
            }
        }
    }
    
    fileprivate func peek() -> StackItem? {
        if !(viewStack.isEmpty) {
            return viewStack[viewStack.count - 1]
        }
        return nil
    }
    
    fileprivate func atRootView() -> Bool {
        viewStack.isEmpty
    }
}

struct NavigationStack<Content: View>: View {
    private var rootView: () -> Content
    @ObservedObject var viewStackItems: NavigationStackItems
    @State var stackViewOffset: CGFloat = 500

    
    init(withStack viewStackItems: NavigationStackItems, @ViewBuilder viewForContent: @escaping () -> Content) {
        self.viewStackItems = viewStackItems
        self.rootView = viewForContent
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            self.body(forSize: geometry.size)
        }
    }
    
    
    func body(forSize size: CGSize) -> some View {
        ZStack {
                rootView()
                    .opacity(self.viewStackItems.viewStack.isEmpty ? 1 : 0)
            
                ForEach(viewStackItems.viewStack, id: \.id) { stackItem in
                    Group {
                        if self.viewStackItems.peek()?.id == stackItem.id {
                            stackItem.view
                                .transition(AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .identity))
                        }
                        else {
                            stackItem.view
                            .hidden()
                                .transition(.identity)
                        }
                    }

                }
            }
        }
}



struct Visibility: ViewModifier {
    var isHidden: Bool
    
    func body(content: Content) -> some View {
        Group {
            if isHidden {
                content
                    .hidden()
            }
            else {
                content
            }
        }
    }
}
