Class {
	#name : #FormSGBorderNode,
	#superclass : #FormSGRectangleNode,
	#instVars : [
		'color',
		'leftWidth',
		'rightWidth',
		'bottomWidth',
		'topWidth'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGBorderNode >> accept: visitor [
	^ visitor visitBorderNode: self
]

{ #category : #accessing }
FormSGBorderNode >> borderRectanglesDo: aBlock [
	| interiorRectangle |
	interiorRectangle := rectangle origin + (leftWidth @ bottomWidth) corner: rectangle corner - (rightWidth @ topWidth).
	(rectangle areasOutside: interiorRectangle) do: aBlock
]

{ #category : #accessing }
FormSGBorderNode >> bottomWidth [
	^ bottomWidth
]

{ #category : #accessing }
FormSGBorderNode >> bottomWidth: anObject [
	^ bottomWidth := anObject
]

{ #category : #accessing }
FormSGBorderNode >> color [
	^ color
]

{ #category : #accessing }
FormSGBorderNode >> color: anObject [
	color := anObject
]

{ #category : #accessing }
FormSGBorderNode >> leftWidth [
	^ leftWidth
]

{ #category : #accessing }
FormSGBorderNode >> leftWidth: anObject [
	leftWidth := anObject
]

{ #category : #accessing }
FormSGBorderNode >> rightWidth [
	^ rightWidth
]

{ #category : #accessing }
FormSGBorderNode >> rightWidth: anObject [
	^ rightWidth := anObject
]

{ #category : #accessing }
FormSGBorderNode >> topWidth [
	^ topWidth
]

{ #category : #accessing }
FormSGBorderNode >> topWidth: anObject [
	^ topWidth := anObject
]

{ #category : #accessing }
FormSGBorderNode >> width: aWidth [
	leftWidth := rightWidth := bottomWidth := topWidth := aWidth
]
