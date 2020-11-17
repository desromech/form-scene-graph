"
I am a node that draws the borders of a rectangle.
"
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
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGBorderNode >> accept: visitor [
	^ visitor visitBorderNode: self
]

{ #category : #accessing }
FormSGBorderNode >> borderRectangles [
	| interiorRectangle |
	interiorRectangle := self interiorRectangle.
	^ (rectangle areasOutside: interiorRectangle)
]

{ #category : #accessing }
FormSGBorderNode >> borderRectanglesDo: aBlock [
	^ self borderRectangles do: aBlock
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
FormSGBorderNode >> interiorRectangle [
	^ rectangle origin + (leftWidth @ bottomWidth) corner: rectangle corner - (rightWidth @ topWidth)
]

{ #category : #testing }
FormSGBorderNode >> isBorderNode [
	^ true
]

{ #category : #accessing }
FormSGBorderNode >> leftWidth [
	^ leftWidth
]

{ #category : #accessing }
FormSGBorderNode >> leftWidth: anObject [
	leftWidth := anObject
]

{ #category : #printing }
FormSGBorderNode >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '; color: '; print: color;
		nextPutAll: '; leftWidth: '; print: leftWidth;
		nextPutAll: '; rightWidth: '; print: rightWidth;
		nextPutAll: '; topWidth: '; print: topWidth;
		nextPutAll: '; bottomWidth: '; print: bottomWidth

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
