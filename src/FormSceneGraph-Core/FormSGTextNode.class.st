Class {
	#name : #FormSGTextNode,
	#superclass : #FormSGRectangleNode,
	#instVars : [
		'string',
		'firstIndex',
		'lastIndex',
		'font',
		'color',
		'underline',
		'underlineColor',
		'strikethrough',
		'strikethroughColor'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGTextNode >> accept: visitor [
	^ visitor visitTextNode: self
]

{ #category : #accessing }
FormSGTextNode >> color [
	^ color
]

{ #category : #accessing }
FormSGTextNode >> color: anObject [
	color := anObject
]

{ #category : #accessing }
FormSGTextNode >> firstIndex [
	^ firstIndex
]

{ #category : #accessing }
FormSGTextNode >> firstIndex: anObject [
	firstIndex := anObject
]

{ #category : #accessing }
FormSGTextNode >> font [
	^ font
]

{ #category : #accessing }
FormSGTextNode >> font: anObject [
	font := anObject
]

{ #category : #accessing }
FormSGTextNode >> lastIndex [
	^ lastIndex
]

{ #category : #accessing }
FormSGTextNode >> lastIndex: anObject [
	lastIndex := anObject
]

{ #category : #accessing }
FormSGTextNode >> strikethrough [
	^ strikethrough
]

{ #category : #accessing }
FormSGTextNode >> strikethrough: anObject [
	strikethrough := anObject
]

{ #category : #accessing }
FormSGTextNode >> strikethroughColor [
	^ strikethroughColor
]

{ #category : #accessing }
FormSGTextNode >> strikethroughColor: anObject [
	strikethroughColor := anObject
]

{ #category : #accessing }
FormSGTextNode >> string [
	^ string
]

{ #category : #accessing }
FormSGTextNode >> string: anObject [
	string := anObject
]

{ #category : #accessing }
FormSGTextNode >> underline [
	^ underline
]

{ #category : #accessing }
FormSGTextNode >> underline: anObject [
	underline := anObject
]

{ #category : #accessing }
FormSGTextNode >> underlineColor [
	^ underlineColor
]

{ #category : #accessing }
FormSGTextNode >> underlineColor: anObject [
	underlineColor := anObject
]
