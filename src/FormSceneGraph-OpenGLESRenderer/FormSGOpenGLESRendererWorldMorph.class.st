"
I am a world morph that uses OpenGL ES for rendering.
"
Class {
	#name : #FormSGOpenGLESRendererWorldMorph,
	#superclass : #FormSGWorldMorph,
	#pools : [
		'UFFIOpenGLConstants'
	],
	#category : #'FormSceneGraph-OpenGLESRenderer'
}

{ #category : #hooks }
FormSGOpenGLESRendererWorldMorph >> worldRendererClass [
	^ FormSGOpenGLESWorldRenderer
]
