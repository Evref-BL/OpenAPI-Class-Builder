Class {
	#name : 'SchemaVisitor',
	#superclass : 'Object',
	#category : 'OpenAPI-Class-Builder',
	#package : 'OpenAPI-Class-Builder'
}

{ #category : 'visiting' }
SchemaVisitor >> visitAbstractType: aSchemaNode [

	1 halt
]

{ #category : 'visiting' }
SchemaVisitor >> visitArrayType: aSchemaNode [

	1 halt. 
]

{ #category : 'visiting' }
SchemaVisitor >> visitCombinedType: aSchemaNode [
	1 halt.
	
	aSchemaNode valuesDo: [ :schemas |
		schemas do: [ :schema |
			schema acceptSchemaVisitor: self. 
			
			 ].  
		
		 ]
]

{ #category : 'visiting' }
SchemaVisitor >> visitObjectType: aSchemaNode [

	1 halt
]

{ #category : 'visiting' }
SchemaVisitor >> visitSchema: aJsonSchema [

	aJsonSchema isTypeObject ifTrue: [ self visitObjectType: aJsonSchema ].

	aJsonSchema isTypeArray ifTrue: [ self visitArrayType: aJsonSchema ].

	aJsonSchema isCombinedType ifTrue: [
		self visitCombinedType: aJsonSchema ].

]
