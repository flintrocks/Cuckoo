//
//  VerificationProxyTemplate.swift
//  CuckooGeneratorFramework
//
//  Created by Tadeas Kriz on 11/14/17.
//

import Foundation

extension Templates {
    static let verificationProxy = """
struct __VerificationProxy_{{ container.name }}: Cuckoo.VerificationProxy {
    private let cuckoo_manager: Cuckoo.MockManager
    private let cuckoo_callMatcher: Cuckoo.CallMatcher
    private let cuckoo_sourceLocation: Cuckoo.CuckooSourceLocation

    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.CuckooSourceLocation) {
        self.cuckoo_manager = manager
        self.cuckoo_callMatcher = callMatcher
        self.cuckoo_sourceLocation = sourceLocation
    }

    {% for property in container.properties %}
    var {{property.name}}: Cuckoo.Verify{% if property.isReadOnly %}ReadOnly{%endif%}Property<{{property.type|genericSafe}}> {
        return .init(manager: cuckoo_manager, name: "{{property.name}}", callMatcher: cuckoo_callMatcher, sourceLocation: cuckoo_sourceLocation)
    }
    {% endfor %}

    {% for method in container.methods %}
    @discardableResult
    func {{method.name}}{{method.parameters|matchableGenericNames}}({{method.parameters|matchableParameterSignature}}) -> Cuckoo.__DoNotUse<{{method.returnType|genericSafe}}>{{method.parameters|matchableGenericWhere}} {
        {{method.parameters|parameterMatchers}}
        return cuckoo_manager.verify("{{method.fullyQualifiedName}}", callMatcher: cuckoo_callMatcher, parameterMatchers: matchers, sourceLocation: cuckoo_sourceLocation)
    }
    {% endfor %}
}
"""
}
