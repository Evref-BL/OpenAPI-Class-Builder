Class {
	#name : 'BaselineOfOpenAPIClassBuilder',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfOpenAPIClassBuilder',
	#package : 'BaselineOfOpenAPIClassBuilder'
}

{ #category : 'baselines' }
BaselineOfOpenAPIClassBuilder >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'NeoJSON'
			with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].

		spec
			package: 'OpenAPI-Class-Builder'
			with: [ spec requires: #( 'NeoJSON' ) ] ]
]
