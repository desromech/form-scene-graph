"
I encapsulate a subscene that should always be drawn for performance reasons into a separate ofscreen buffer. This caching requirement is only for performance reasons. My content can always be drawn by directly traversing my child node.

I also hold a modification count, and handles into renderer specific texture/surfaces/render target for actually caching my drawn pixels. 
"
Class {
	#name : #FormSGCachingSubScene,
	#superclass : #FormSGNode,
	#instVars : [
		'clipChildNode',
		'cachedSubSceneForm',
		'modificationCount',
		'cachedSubSceneFormValidationCount',
		'cachedSubSceneAthensCairoSurface',
		'cachedSubSceneAthensCairoSurfaceValidationCount'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGCachingSubScene >> accept: visitor [
	^ visitor visitCachedSubScene: self
]

{ #category : #'accessing - bounds' }
FormSGCachingSubScene >> boundingBox [
	^ clipChildNode rectangle
]

{ #category : #updating }
FormSGCachingSubScene >> changed [
	modificationCount := modificationCount + 1.
]

{ #category : #accessing }
FormSGCachingSubScene >> child [
	^ clipChildNode child
]

{ #category : #accessing }
FormSGCachingSubScene >> child: aChild [
	clipChildNode child: aChild..
	self changed.
]

{ #category : #accessing }
FormSGCachingSubScene >> children [
	^ { clipChildNode }
]

{ #category : #accessing }
FormSGCachingSubScene >> clipChildNode [
	^ clipChildNode
]

{ #category : #initialization }
FormSGCachingSubScene >> initialize [
	super initialize.
	clipChildNode := FormSGClipNode new.
	modificationCount := 0.
]

{ #category : #accessing }
FormSGCachingSubScene >> modificationCount [
	^ modificationCount
]

{ #category : #accessing }
FormSGCachingSubScene >> rectangle [
	^ clipChildNode rectangle
]

{ #category : #accessing }
FormSGCachingSubScene >> rectangle: aRectangle [
	clipChildNode rectangle = aRectangle ifFalse: [ self changed ].
	clipChildNode rectangle: aRectangle
]

{ #category : #'rendering helpers' }
FormSGCachingSubScene >> validCachedAthensCairoSurface [
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

{ #category : #'rendering helpers' }
FormSGCachingSubScene >> validCachedForm [
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
