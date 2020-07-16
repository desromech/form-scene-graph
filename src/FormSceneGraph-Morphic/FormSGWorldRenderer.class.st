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
FormSGWorldRenderer >> checkForNewScreenSize [

	osWindow ifNil: [ ^ self ].
	"This check is required to avoid a glitch with the keyboard focus handling."
	(world worldState realWindowExtent = self actualScreenSize
	and: [world worldState currentCursor isNotNil]) ifTrue: [ ^ self ].
	
	world worldState realWindowExtent: self actualScreenSize.

	world restoreMorphicDisplay.

]

{ #category : #operations }
FormSGWorldRenderer >> deferUpdatesDuring: aBlock [
	"Nothing required here."
]

{ #category : #operations }
FormSGWorldRenderer >> displayWorldState: aWorldState ofWorld: aWorld [
	| submorphs renderer builder rootNodes |
	osWindow ifNil: [ ^ self ].
	submorphs := aWorld submorphs.

	"force re-layout if needed"
	submorphs do: [ :m | m fullBounds ].

	"display is already up-to-date"
	aWorldState checkIfUpdateNeeded
		ifFalse: [ ^ self ].
		
	renderer := self osWindowRenderer.
	builder := FormSGBuilder extent: aWorld extent. 
	rootNodes := OrderedCollection new.
	rootNodes add: (aWorld buildFullSceneGraphWith: builder).
	aWorldState hands reverseDo: [ :each |
		rootNodes add: (each buildFullSceneGraphWith: builder)
	].

	renderer scene rootNode: (builder containerWith: rootNodes).
	renderer updateAll.
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
