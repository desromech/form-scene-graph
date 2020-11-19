"
I am GPU command list builder that is used for generating the geometry buffers and the commands that are required for drawing a scene graph through a GPU accelerated API such as OpenGL and Vulkan.
"
Class {
	#name : #FormSGGPUCommandListBuilder,
	#superclass : #Object,
	#instVars : [
		'vertices',
		'indices',
		'drawCommands',
		'baseVertex',
		'currentColorR',
		'currentColorG',
		'currentColorB',
		'currentColorA',
		'currentTextureCommand',
		'vertexCount'
	],
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #adding }
FormSGGPUCommandListBuilder >> addIndices: newIndices [
	newIndices do: [ :each |
		indices add: each + baseVertex
	]
]

{ #category : #'draw commands' }
FormSGGPUCommandListBuilder >> beginCommandRecording [
	drawCommands add: FormSGGPUBeginCommandRecording uniqueInstance.
	^ drawCommands size
]

{ #category : #'mesh building' }
FormSGGPUCommandListBuilder >> beginTriangles [
	baseVertex := vertexCount.
	drawCommands last isDrawElements ifTrue: [ ^ self ].

	drawCommands add: (FormSGGPUDrawElementsCommand new
		firstIndex: indices size;
		indexCount: 0;
		yourself)
]

{ #category : #accessing }
FormSGGPUCommandListBuilder >> color: color [
	currentColorR := color red.
	currentColorG := color green.
	currentColorB := color blue.
	currentColorA := color alpha.
]

{ #category : #accessing }
FormSGGPUCommandListBuilder >> drawCommands [
	^ drawCommands
]

{ #category : #'draw commands' }
FormSGGPUCommandListBuilder >> endCommandRecording [
	drawCommands add: FormSGGPUEndCommandRecording uniqueInstance.
	^ drawCommands size
]

{ #category : #'mesh building' }
FormSGGPUCommandListBuilder >> endSubmesh [
	| lastDrawCommand |
	lastDrawCommand := drawCommands last.
	self assert: lastDrawCommand isDrawElements.
	lastDrawCommand indexCount: indices size - lastDrawCommand firstIndex.
]

{ #category : #accessing }
FormSGGPUCommandListBuilder >> indices [
	^ indices
]

{ #category : #initialization }
FormSGGPUCommandListBuilder >> initialize [
	super initialize.
	self reset.
]

{ #category : #'draw commands' }
FormSGGPUCommandListBuilder >> noTexture [
	currentTextureCommand isNoTexture ifTrue: [ ^ self ].
	drawCommands add: (currentTextureCommand := FormSGGPUNoTextureCommand uniqueInstance)
]

{ #category : #'draw commands' }
FormSGGPUCommandListBuilder >> replayCommandsFrom: startCommandIndex to: endCommandIndex [
	startCommandIndex + 1 to: endCommandIndex - 1 do: [ :index |
		drawCommands add: (drawCommands at: index)
	]
]

{ #category : #initialization }
FormSGGPUCommandListBuilder >> reset [
	vertices := OrderedCollection new.
	indices := OrderedCollection new.
	drawCommands := OrderedCollection new.
	currentTextureCommand := FormSGGPUNoTextureCommand uniqueInstance.
	drawCommands add: currentTextureCommand.

	baseVertex := 0.
	vertexCount := 0.
	currentColorR := 1.0.
	currentColorG := 1.0.
	currentColorB := 1.0.
	currentColorA := 1.0.
]

{ #category : #'draw commands' }
FormSGGPUCommandListBuilder >> setFormTexture: form [
	(currentTextureCommand isSetFormTexture and: [ currentTextureCommand form == form ]) ifTrue: [ ^ self ].
	
	drawCommands last isSetFormTexture ifTrue: [ 
		drawCommands last form: form.
		^ self
	].

	drawCommands add: (currentTextureCommand := FormSGGPUSetFormTextureCommand new form: form; yourself)
]

{ #category : #'draw commands' }
FormSGGPUCommandListBuilder >> setFormTexture: form withModificationCount: modificationCount [
	(currentTextureCommand isSetFormTextureWithModificationCount
	and: [ currentTextureCommand form == form
	and: [ currentTextureCommand modificationCount = modificationCount]]) ifTrue: [ ^ self ].

	drawCommands last isSetFormTextureWithModificationCount ifTrue: [ 
		drawCommands last
			form: form;
			modificationCount: modificationCount.
		^ self
	].
	drawCommands add: (currentTextureCommand := FormSGGPUSetFormTextureWithModificationCountCommand new
		form: form;
		modificationCount: modificationCount;
		yourself)
]

{ #category : #'draw commands' }
FormSGGPUCommandListBuilder >> setScissor: rectangle [
	drawCommands last isSetScissor ifTrue: [ 
		drawCommands last rectangle: rectangle.
		^ self
	].

	drawCommands add: (FormSGGPUSetScissorCommand new rectangle: rectangle).
]

{ #category : #'draw commands' }
FormSGGPUCommandListBuilder >> useCompositeAlphaBlending [
	drawCommands add: FormSGGPUUseCompositeAlphaBlendingCommand uniqueInstance
]

{ #category : #'draw commands' }
FormSGGPUCommandListBuilder >> useSubpixelFontFirstPassBlending [
	drawCommands add: FormSGGPUUseSubpixelFontFirstPassBlendingCommand uniqueInstance
]

{ #category : #'draw commands' }
FormSGGPUCommandListBuilder >> useSubpixelFontSecondPassBlending [
	drawCommands add: FormSGGPUUseSubpixelFontSecondPassBlendingCommand uniqueInstance
]

{ #category : #'mesh building' }
FormSGGPUCommandListBuilder >> vertexPosition: position [
	self vertexX: position x y: position y r:
		currentColorR g: currentColorG b: currentColorB a: currentColorA
		u: 0.0 v: 0.0
]

{ #category : #'mesh building' }
FormSGGPUCommandListBuilder >> vertexPosition: position color: color [
	self vertexX: position x y: position y r: color red g: color green b: color blue a: color alpha u: 0.0 v: 0.0
]

{ #category : #'mesh building' }
FormSGGPUCommandListBuilder >> vertexPosition: position color: color texcoord: texcoord [
	self vertexX: position x y: position y r: color red g: color green b: color blue a: color alpha u: texcoord x v: texcoord y
]

{ #category : #'mesh building' }
FormSGGPUCommandListBuilder >> vertexPosition: position texcoord: texcoord [
	self vertexX: position x y: position y r: currentColorR g: currentColorG b: currentColorB a: currentColorA u: texcoord x v: texcoord y
]

{ #category : #'mesh building' }
FormSGGPUCommandListBuilder >> vertexX: x y: y r: r g: g b: b a: a u: u v: v [
	vertices
		add: x asFloat;
		add: y asFloat;
		
		add: r asFloat;
		add: g asFloat;
		add: b asFloat;
		add: a asFloat;
		
		add: u asFloat;
		add: v asFloat.
	vertexCount := vertexCount + 1.
]

{ #category : #accessing }
FormSGGPUCommandListBuilder >> vertices [
	^ vertices
]
