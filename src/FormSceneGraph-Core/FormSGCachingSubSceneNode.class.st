"
I encapsulate a subscene that should always be drawn for performance reasons into a separate ofscreen buffer. This caching requirement is only for performance reasons. My content can always be drawn by directly traversing my child node.

I also hold a modification count, and handles into renderer specific texture/surfaces/render target for actually caching my drawn pixels. 
"
Class {
	#name : #FormSGCachingSubSceneNode,
	#superclass : #FormSGNode,
	#instVars : [
		'clipChildNode',
		'cachedSubSceneForm',
		'modificationCount',
		'cachedSubSceneFormValidationCount',
		'cachedSubSceneAthensCairoSurface',
		'cachedSubSceneAthensCairoSurfaceValidationCount',
		'cachedSubSceneAthensCairoSurfaceSession'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGCachingSubSceneNode >> accept: visitor [
	^ visitor visitCachedSubScene: self
]

{ #category : #'accessing - bounds' }
FormSGCachingSubSceneNode >> boundingBox [
	^ clipChildNode rectangle
]

{ #category : #updating }
FormSGCachingSubSceneNode >> changed [
	modificationCount := modificationCount + 1.
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> child [
	^ clipChildNode child
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> child: aChild [
	self child: aChild rectangle: aChild boundingBox
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> child: aChild rectangle: aClippingRectangle [
	self rectangle: aClippingRectangle.
	clipChildNode child: aChild.
	self changed.
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> children [
	^ { clipChildNode }
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> clipChildNode [
	^ clipChildNode
]

{ #category : #initialization }
FormSGCachingSubSceneNode >> initialize [
	super initialize.
	clipChildNode := FormSGClipNode new
		rectangle: Rectangle empty;
		child: FormSGNullNode uniqueInstance;
		yourself.
	modificationCount := 0.
]

{ #category : #testing }
FormSGCachingSubSceneNode >> isCachingSubSceneNode [
	^ true
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> modificationCount [
	^ modificationCount
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> rectangle [
	^ clipChildNode rectangle
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> rectangle: aRectangle [
	clipChildNode rectangle = aRectangle ifFalse: [ self changed ].
	clipChildNode rectangle: aRectangle
]

{ #category : #'rendering helpers' }
FormSGCachingSubSceneNode >> validCachedAthensCairoSurface [
	^ self validCachedAthensCairoSurfaceWithExtent: self rectangle extent ceiling
]

{ #category : #'rendering helpers' }
FormSGCachingSubSceneNode >> validCachedAthensCairoSurfaceWithExtent: requiredExtent [
	| rectangle logicalExtent translation |
	cachedSubSceneAthensCairoSurfaceSession == Smalltalk session ifFalse: [
		cachedSubSceneAthensCairoSurface := nil.
		cachedSubSceneAthensCairoSurfaceValidationCount := nil.
	].

	(cachedSubSceneAthensCairoSurfaceValidationCount = modificationCount
	and: [ cachedSubSceneAthensCairoSurface extent = requiredExtent ]) ifTrue: [
		^ cachedSubSceneAthensCairoSurface
	].

	rectangle := self rectangle.
	logicalExtent := rectangle extent ceiling.
	(cachedSubSceneAthensCairoSurface isNil or: [ cachedSubSceneAthensCairoSurface extent ~= requiredExtent ]) ifTrue: [
		cachedSubSceneAthensCairoSurface := AthensCairoSurface extent: requiredExtent.
		cachedSubSceneAthensCairoSurfaceSession := Smalltalk session
	].

	translation := rectangle origin rounded negated.
	cachedSubSceneAthensCairoSurface drawDuring: [ :canvas |
		FormSGAthensRenderer render: self child
			withTransform: (FormSGAffineTransform
				scaleX: requiredExtent x / logicalExtent x
				Y: requiredExtent y / logicalExtent y)
				* (FormSGAffineTransform translation: translation) on: canvas
	].

	cachedSubSceneAthensCairoSurfaceValidationCount := modificationCount.
	^ cachedSubSceneAthensCairoSurface
]

{ #category : #'rendering helpers' }
FormSGCachingSubSceneNode >> validCachedForm [
	^ self validCachedFormWithExtent: self rectangle extent ceiling
]

{ #category : #'rendering helpers' }
FormSGCachingSubSceneNode >> validCachedFormWithExtent: requiredExtent [
	| rectangle logicalExtent translation |
	cachedSubSceneFormValidationCount = modificationCount ifTrue: [ ^ cachedSubSceneForm ].

	rectangle := self rectangle.
	logicalExtent := rectangle extent ceiling.
	(cachedSubSceneForm isNil or: [ cachedSubSceneForm extent ~= requiredExtent ]) ifTrue: [
		cachedSubSceneForm := Form extent: rectangle extent depth: 32
	].

	translation := rectangle origin negated.
	cachedSubSceneForm fillColor: Color transparent.
	cachedSubSceneForm getCanvas translateBy: translation during: [:translatedCanvas |
		FormSGCanvasRenderer render: self child withTransform: (FormSGAffineTransform
				scaleX: requiredExtent x / logicalExtent x
				Y: requiredExtent y / logicalExtent y)
				* (FormSGAffineTransform translation: translation) on: translatedCanvas
	].

	cachedSubSceneFormValidationCount := modificationCount.
	^ cachedSubSceneForm
]
