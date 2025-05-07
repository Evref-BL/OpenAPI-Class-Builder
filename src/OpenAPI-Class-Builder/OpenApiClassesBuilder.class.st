"
I am a class builder tool that looks at a OpenAPI Json schema and outputs matching classes with proper accessors. 
	
```language=Pharo&caption=Example
   | jsonString |
	jsonString := '<path/to/>/schema.json' asFileReference .
	OpenApiClassesBuilder newClassNamed: 'MyClassName' compileFromString: jsonString contents. 
```
"
Class {
	#name : 'OpenApiClassesBuilder',
	#superclass : 'Object',
	#instVars : [
		'jsonObject',
		'jsonString',
		'packageName',
		'prefix'
	],
	#category : 'OpenAPI-Class-Builder-Objects',
	#package : 'OpenAPI-Class-Builder',
	#tag : 'Objects'
}

{ #category : 'compiling' }
OpenApiClassesBuilder class >> compileFromString: jsonString [

	| jsonObject |
	
	jsonObject := NeoJSONReader fromString: jsonString.

	^ self new
		createClassNamed: 'CopilotMetrics'
		fromApiSchemaDic: jsonObject
]

{ #category : 'compiling' }
OpenApiClassesBuilder class >> newClassNamed: aClassName compileFromFilePath: path [

	| jsonObject jsonString |
	jsonString := path asFileReference.

	jsonObject := NeoJSONReader fromString: jsonString.

	^ self new createClassNamed: aClassName fromApiSchemaDic: jsonObject
]

{ #category : 'compiling' }
OpenApiClassesBuilder class >> newClassNamed: aClassName compileFromString: jsonString [

	| jsonObject |
	
	jsonObject := NeoJSONReader fromString: jsonString.

	^ self new
		createClassNamed: aClassName
		fromApiSchemaDic: jsonObject
]

{ #category : 'compiling' }
OpenApiClassesBuilder class >> newClassNamed: aClassName inPackage: aPackageName withPrefix: aPrefix compileFromFilePath: path [

	| jsonObject jsonString |
	jsonString := path asFileReference.

	jsonObject := NeoJSONReader fromString: jsonString.

	^ self new
		  withPrefix: aPrefix;
		  inPackage: aPackageName;
		  createClassNamed: aClassName fromApiSchemaDic: jsonObject
]

{ #category : 'compiling' }
OpenApiClassesBuilder class >> newClassNamed: aClassName withPrefix: aPrefix compileFromFilePath: path [

	| jsonObject jsonString |
	jsonString := path asFileReference.

	jsonObject := NeoJSONReader fromString: jsonString.

	^ self new
		  withPrefix: aPrefix;
		  createClassNamed: aClassName fromApiSchemaDic: jsonObject
]

{ #category : 'generator' }
OpenApiClassesBuilder >> addComment: aComment inMethod: aMethodName inClass: aClass [

	| transformation |
	transformation := (RBAddMethodCommentTransformation
		                   comment: aComment
		                   inMethod: aMethodName asSymbol
		                   inClass: aClass name asSymbol) generateChanges.
	RBRefactoryChangeManager instance performChange:
		transformation model changes.
	^ aClass
]

{ #category : 'adding' }
OpenApiClassesBuilder >> addVariable: aVarName inClass: aClass [

	| transformation |
	
	((aClass instanceVariables collect: #name) includes: aVarName) ifFalse: [ 
		transformation := (RBAddVariableTransformation
		                   variable: aVarName
		                   class: aClass name asSymbol
		                   classVariable: false) generateChanges.
	RBRefactoryChangeManager instance performChange:
		transformation model changes.
		 ] .
	
	
	^ aClass
]

{ #category : 'compiler' }
OpenApiClassesBuilder >> createAccessorsFromProperties: properties inClass: newClass [

	properties keysDo: [ :key | "Generate instance variable"
		| comment |
		comment := (properties at: key)
			           at: #description
			           ifAbsent: [ 'TODO comment' ].

		"Generate Accessor Methods"
		self createAccessorsInClass: newClass ForVarNamed: key.
		self addComment: comment inMethod: key inClass: newClass ].

	^ newClass
]

{ #category : 'generator' }
OpenApiClassesBuilder >> createAccessorsInClass: aClass ForVarNamed: aVarName [

	| transformation |
	self addVariable: aVarName inClass: aClass.  

	transformation := (RBAddVariableAccessorTransformation
		                   variable: aVarName
		                   class: aClass name asSymbol
		                   classVariable: false) generateChanges.

	RBRefactoryChangeManager instance performChange:
		transformation model changes.
	^ aClass
]

{ #category : 'compiler' }
OpenApiClassesBuilder >> createClassNamed: className fromApiSchemaDic: schema [ 

	^ self createClassNamed: className fromApiSchemaDic: schema withParentClass: nil
]

{ #category : 'compiler' }
OpenApiClassesBuilder >> createClassNamed: className fromApiSchemaDic: schema withParentClass: parentClass [

	| properties newClass arrayItems |
	"Determine if this is an object or array"
	({ (schema at: 'type') } flattened includes: 'object') ifTrue: [ "Step 1: Create a New Class""Step 2: Add Instance Variables""Step 3: Generate Accessor Methods""Step 4: Add a Reference to Parent Class""Step 5: Handle Nested Objects"
		newClass := self
			            createNewClass: className
			            inPackage: packageName.

		properties := schema at: 'properties' ifAbsent: [ Dictionary new ].

		self createAccessorsFromProperties: properties inClass: newClass.


		parentClass ifNotNil: [
			self
				createAccessorsInClass: newClass
				ForVarNamed: parentClass asVariableName ].
		properties keysAndValuesDo: [ :key :value |
			self
				createClassNamed: key
				fromApiSchemaDic: value
				withParentClass: newClass ] ].

	({ (schema at: 'type') } flattened includes: 'array') ifTrue: [ "Step 6: Handle Arrays"
		arrayItems := schema at: 'items'.
		({ (arrayItems at: 'type') } flattened includes: 'object') ifTrue: [
			self
				createClassNamed: className
				fromApiSchemaDic: arrayItems
				withParentClass: parentClass ] ].

	^ newClass
]

{ #category : 'generator' }
OpenApiClassesBuilder >> createNewClass: aClassName inPackage: aPackageName [

	| transformation className |
	className := prefix , aClassName asPharoClassName.

	self class environment at: className asSymbol ifAbsent: [
		transformation := (RBInsertNewClassTransformation className:
				                   className)
			                  superclass: #Object;
			                  packageName: aPackageName asSymbol;
			                  execute ].


	^ self class environment at: className asSymbol
]

{ #category : 'as yet unclassified' }
OpenApiClassesBuilder >> inPackage: aPackageName [
	packageName := aPackageName. 
]

{ #category : 'initialization' }
OpenApiClassesBuilder >> initialize [

	packageName := 'OpenAPI-Class-Generated'.
	prefix := 'OpenApi'
]

{ #category : 'accessing' }
OpenApiClassesBuilder >> prefix [
	"a class prefix to add when generating a class"
	
	^ prefix
]

{ #category : 'accessing' }
OpenApiClassesBuilder >> withPrefix: aString [

	prefix := aString
]
