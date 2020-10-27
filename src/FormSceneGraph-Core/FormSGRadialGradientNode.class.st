"
I am a node that draws a circle with a radial gradient which is encompassed in a rectangle.
"
Class {
	#name : #FormSGRadialGradientNode,
	#superclass : #FormSGGradientNode,
	#instVars : [
		'center',
		'focalPoint',
		'innerRadius',
		'outerRadius',
		'clipInnerRadius',
		'clipOuterRadius'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGRadialGradientNode >> accept: visitor [
	^ visitor visitRadialGradientNode: self
]

{ #category : #accessing }
FormSGRadialGradientNode >> center [
	^ center
]

{ #category : #accessing }
FormSGRadialGradientNode >> center: anObject [
	center := anObject
]

{ #category : #accessing }
FormSGRadialGradientNode >> clipInnerRadius [
	^ clipInnerRadius
]

{ #category : #accessing }
FormSGRadialGradientNode >> clipInnerRadius: anObject [
	clipInnerRadius := anObject
]

{ #category : #accessing }
FormSGRadialGradientNode >> clipOuterRadius [
	^ clipOuterRadius
]

{ #category : #accessing }
FormSGRadialGradientNode >> clipOuterRadius: anObject [
	clipOuterRadius := anObject
]

{ #category : #accessing }
FormSGRadialGradientNode >> focalPoint [
	^ focalPoint
]

{ #category : #accessing }
FormSGRadialGradientNode >> focalPoint: anObject [
	focalPoint := anObject
]

{ #category : #accessing }
FormSGRadialGradientNode >> innerRadius [
	^ innerRadius
]

{ #category : #accessing }
FormSGRadialGradientNode >> innerRadius: anObject [
	innerRadius := anObject
]

{ #category : #testing }
FormSGRadialGradientNode >> isRadialGradientNode [
	^ true
]

{ #category : #accessing }
FormSGRadialGradientNode >> maxRadius [
	^ ((innerRadius max: clipInnerRadius) max: outerRadius) max: clipOuterRadius
]

{ #category : #accessing }
FormSGRadialGradientNode >> outerRadius [
	^ outerRadius
]

{ #category : #accessing }
FormSGRadialGradientNode >> outerRadius: anObject [
	outerRadius := anObject
]
