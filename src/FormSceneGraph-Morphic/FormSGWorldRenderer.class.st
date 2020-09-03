Class {
	#name : #FormSGWorldRenderer,
	#superclass : #OSWorldRenderer,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #accessing }
FormSGWorldRenderer class >> isApplicableFor: aWorld [
	^ false
]

{ #category : #initialization }
FormSGWorldRenderer >> actualScreenSize [
	^ (super actualScreenSize / world sceneScaleFactor) ceiling
]

{ #category : #operations }
FormSGWorldRenderer >> buildSceneGraphForWorldState: aWorldState ofWorld: aWorld [
	| builder rootNodes scaleFactor |
	scaleFactor := aWorld sceneScaleFactor.
	builder := FormSGBuilder extent: self actualScreenSize.
	rootNodes := OrderedCollection new.
	rootNodes add: (aWorld buildFullSceneGraphWith: builder).
	aWorldState hands reverseDo: [ :each |
		rootNodes add: (each buildFullSceneGraphWith: builder)
	].
	aWorldState damageRecorder reset.
	^ builder scale: (builder containerWith: rootNodes) with: scaleFactor
]

{ #category : #initialization }
FormSGWorldRenderer >> checkForNewScreenSize [

	osWindow ifNil: [ ^ self ].
	world worldState realWindowExtent = self actualScreenSize ifTrue: [ ^ self ].
	world worldState realWindowExtent: self actualScreenSize.

	world restoreMorphicDisplay.

]

{ #category : #initialization }
FormSGWorldRenderer >> convertRawMouseEventPosition: aPosition [
	^ (aPosition / world sceneScaleFactor + 0.5) floor
]

{ #category : #operations }
FormSGWorldRenderer >> deferUpdatesDuring: aBlock [
	"Nothing required here."
]

{ #category : #operations }
FormSGWorldRenderer >> displayNewSceneScene: newSceneGraph [
	| renderer |
	renderer := self osWindowRenderer.
	renderer scene rootNode: newSceneGraph.
	renderer updateAll.

]

{ #category : #operations }
FormSGWorldRenderer >> displayWorldState: aWorldState ofWorld: aWorld [
	| submorphs newSceneGraph |
	osWindow ifNil: [ ^ self ].

	"force re-layout if needed"
	submorphs := aWorld submorphs.
	submorphs do: [ :m | m fullBounds ].

	"display is already up-to-date"
	aWorldState checkIfUpdateNeeded
		ifFalse: [ ^ nil ].
		
	self isProfilingRenderingTime ifTrue: [
		| sceneGraphBuildingTime displayTextLines builder font displayRectangle | 
		sceneGraphBuildingTime := [ newSceneGraph := self buildSceneGraphForWorldState: aWorldState ofWorld: aWorld ] timeToRunWithoutGC.
		newSceneGraph ifNil: [ ^ self ].

		displayTextLines := {
			'Graph Bld Time: {1} ms [{2}]' format: {sceneGraphBuildingTime printPaddedWith: Character space to: 4 . self class name}.
		}.
		previousFrameRenderingTime ifNotNil: [
			displayTextLines := displayTextLines , { 
				'P. Total time : {1} ms [{2}]' format: {previousFrameRenderingTime printPaddedWith: Character space to: 4 . self class name}.
			}.
		].

		displayRectangle := (0@0 extent: 280@40).
		builder := FormSGBuilder extent: aWorld extent.
		font := TextStyle defaultFont.
		newSceneGraph := builder containerWith: {
				newSceneGraph.
				builder solidRectangle: displayRectangle color: Color white
			} ,
			(displayTextLines collectWithIndex: [:line :index |
				builder string: line in: (10@(10*index) extent: 200@10) font: font color: Color black.
			]).
				
		previousFrameRenderingTime := [
			self displayNewSceneScene: newSceneGraph
		] timeToRunWithoutGC.

		displayTextLines do: [ :line |
			Stdio stdout nextPutAll: line; lf
		]
	] ifFalse: [ 
		newSceneGraph := self buildSceneGraphForWorldState: aWorldState ofWorld: aWorld.
		newSceneGraph ifNil: [ ^ self ].

		self displayNewSceneScene: newSceneGraph
	].

]

{ #category : #operations }
FormSGWorldRenderer >> drawDuring: aBlock [
	"Nothing required here."
]

{ #category : #initialization }
FormSGWorldRenderer >> osWindowRenderer [
		
	^ osWindow renderer ifNil: [
		osWindow newGenericRenderer.
		osWindow renderer scene: FormSGOSWindowGenericRendererScene new.
		osWindow renderer
	].
	
]

{ #category : #operations }
FormSGWorldRenderer >> updateDamage: allDamage [
	"Nothing required here."
]
