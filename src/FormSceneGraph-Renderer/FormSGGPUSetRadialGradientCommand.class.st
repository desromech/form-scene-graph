"
I am command used for specifying a radial gradient as a texture.
"
Class {
	#name : #FormSGGPUSetRadialGradientCommand,
	#superclass : #FormSGGPUDrawCommand,
	#instVars : [
		'center',
		'focalPoint',
		'clipInnerRadius',
		'innerRadius',
		'outerRadius',
		'clipOuterRadius',
		'startColor',
		'endColor'
	],
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUSetRadialGradientCommand >> accept: visitor [
	^ visitor setRadialGradientCommand: self
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> center [
	^ center
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> center: anObject [
	center := anObject
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> clipInnerRadius [
	^ clipInnerRadius
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> clipInnerRadius: anObject [
	clipInnerRadius := anObject
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> clipOuterRadius [
	^ clipOuterRadius
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> clipOuterRadius: anObject [
	clipOuterRadius := anObject
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> endColor [
	^ endColor
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> endColor: anObject [
	endColor := anObject
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> focalPoint [
	^ focalPoint
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> focalPoint: anObject [
	focalPoint := anObject
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> innerRadius [
	^ innerRadius
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> innerRadius: anObject [
	innerRadius := anObject
]

{ #category : #testing }
FormSGGPUSetRadialGradientCommand >> isSetRadialGradient [
	^ true
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> outerRadius [
	^ outerRadius
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> outerRadius: anObject [
	outerRadius := anObject
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> startColor [
	^ startColor
]

{ #category : #accessing }
FormSGGPUSetRadialGradientCommand >> startColor: anObject [
	startColor := anObject
]
