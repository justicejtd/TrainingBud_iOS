//
//  SwiftUIView.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 16/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        VStack {
            Text("Second View").font(.system(size: 36))
            Text("Loaded by SecondView").font(.system(size: 14))
        }
    }
}

class ChildHostingController: UIHostingController<SwiftUIView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: SwiftUIView());
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
