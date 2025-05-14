Extension { #name : 'Dictionary' }

{ #category : '*OpenAPI-Class-Builder' }
Dictionary >> acceptSchemaVisitor: aSchemaVisitor [

	^ aSchemaVisitor visitSchema: self
]

{ #category : '*OpenAPI-Class-Builder' }
Dictionary >> isCombinedType [

	^ (self includesKey: #anyOf) or: [ (self includesKey: #oneOf) or: [ (self includesKey: #allOf)  ]  ]
]

{ #category : '*OpenAPI-Class-Builder' }
Dictionary >> isTypeArray [
	^ ({ self at: 'type' ifAbsent:[{}] } flattened includes: 'array')
]

{ #category : '*OpenAPI-Class-Builder' }
Dictionary >> isTypeBoolean [

	^ { (self at: 'type' ifAbsent: [ {  } ]) } flattened includes:
		  'boolean'
]

{ #category : '*OpenAPI-Class-Builder' }
Dictionary >> isTypeInteger [

	^ { (self at: 'type' ifAbsent: [ {  } ]) } flattened includes:
		  'integer'
]

{ #category : '*OpenAPI-Class-Builder' }
Dictionary >> isTypeNumber [

	^ { (self at: 'type' ifAbsent: [ {  } ]) } flattened includes:
		  'number'
]

{ #category : '*OpenAPI-Class-Builder' }
Dictionary >> isTypeNumberOrInterger [

	^ self isTypeNumber or: [ self isInteger]. 
]

{ #category : '*OpenAPI-Class-Builder' }
Dictionary >> isTypeObject [

	^ { (self at: 'type' ifAbsent: [ {  } ]) } flattened includes:
		  'object'
]

{ #category : '*OpenAPI-Class-Builder' }
Dictionary >> isTypeString [

	^ { (self at: 'type' ifAbsent: [ {  } ]) } flattened includes:
		  'string'
]
