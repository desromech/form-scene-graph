Class {
	#name : #FormSGCachedSubScene,
	#superclass : #FormSGNode,
	#instVars : [
		'clipChildNode',
		'cachedSubSceneForm',
		'modificationCount',
		'cachedSubSceneFormValidationCount',
		'cachedSubSceneAthensCairoSurface',
		'cachedSubSceneAthensCairoSurfaceValidationCount'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGCachedSubScene >> accept: visitor [
	^ visitor visitCachedSubScene: self
]

{ #category : #'display box access' }
FormSGCachedSubScene >> boundingBox [
	^ clipChildNode rectangle
]

{ #category : #updating }
FormSGCachedSubScene >> changed [
	modificationCount := modificationCount + 1.
]

{ #category : #accessing }
FormSGCachedSubScene >> child [
	^ clipChildNode child
]

{ #category : #accessing }
FormSGCachedSubScene >> child: aChild [
	clipChildNode child: aChild..
	self changed.
]

{ #category : #accessing }
FormSGCachedSubScene >> children [
	^ { clipChildNode }
]

{ #category : #accessing }
FormSGCachedSubScene >> clipChildNode [
	^ clipChildNode
]

{ #category : #initialization }
FormSGCachedSubScene >> initialize [
	super initialize.
	clipChildNode := FormSGClipNode new.
	modificationCount := 0.
]

{ #category : #accessing }
FormSGCachedSubScene >> modificationCount [
	^ modificationCount
]

{ #category : #accessing }
FormSGCachedSubScene >> rectangle [
	^ clipChildNode rectangle
]

{ #category : #accessing }
FormSGCachedSubScene >> rectangle: aRectangle [
	clipChildNode rectangle = aRectangle ifFalse: [ self changed ].
	clipChildNode rectangle: aRectangle
]

{ #category : #'as yet unclassified' }
FormSGCachedSubScene >> validCachedAthensCairoSurface [
	| rectangle requiredExtent translation |
	cachedSubSceneAthensCairoSurfaceValidationCount = modificationCount ifTrue: [ ^ cachedSubSceneAthensCairoSurface ].

	rectangle := self rectangle.
	requiredExtent := rectangle extent ceiling.
	(cachedSubSceneAthensCairoSurface isNil or: [ cachedSubSceneAthensCairoSurface extent ~= requiredExtent ]) ifTrue: [
		cachedSubSceneAthensCairoSurface := AthensCairoSurface extent: requiredExtent
	].

	translation := rectangle origin negated.
	cachedSubSceneAthensCairoSurface drawDuring: [ :canvas |
		FormSGAthensRenderer render: self child withTransform: (FormSGAffineTransform translation: translation) on: canvas
	].

	cachedSubSceneAthensCairoSurfaceValidationCount := modificationCount.
	^ cachedSubSceneAthensCairoSurface
]

{ #category : #'as yet unclassified' }
FormSGCachedSubScene >> validCachedForm [
	| rectangle requiredExtent translation |
	cachedSubSceneFormValidationCount = modificationCount ifTrue: [ ^ cachedSubSceneForm ].

	rectangle := self rectangle.
	requiredExtent := rectangle extent ceiling.
	(cachedSubSceneForm isNil or: [ cachedSubSceneForm extent ~= requiredExtent ]) ifTrue: [
		cachedSubSceneForm := Form extent: rectangle extent depth: 32
	].

	translation := rectangle origin negated.
	cachedSubSceneForm fillColor: Color transparent.
	cachedSubSceneForm getCanvas translateBy: translation during: [:translatedCanvas |
		FormSGCanvasRenderer render: self child withTransform: (FormSGAffineTransform translation: translation) on: translatedCanvas
	].

	cachedSubSceneFormValidationCount := modificationCount.
	^ cachedSubSceneForm
]
